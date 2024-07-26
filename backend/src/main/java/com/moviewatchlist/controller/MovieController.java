package com.moviewatchlist.controller;

import com.moviewatchlist.model.Movie;
import com.moviewatchlist.model.User;
import com.moviewatchlist.repository.UserRepository;
import com.moviewatchlist.service.MovieService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/movies")
@RequiredArgsConstructor
public class MovieController {

    private final MovieService movieService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<Movie>> getAllMovies() {
        User currentUser = getCurrentUser();
        List<Movie> userMovies = movieService.getMoviesByUser(currentUser);
        return ResponseEntity.ok(userMovies);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable Long id) {
        User currentUser = getCurrentUser();
        Optional<Movie> movie = movieService.getMovieByIdAndUser(id, currentUser);
        if (movie.isPresent()) {
            return ResponseEntity.ok(movie.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<Movie> createMovie(@RequestBody Movie movie) {
        User currentUser = getCurrentUser();
        movie.setUser(currentUser); // Assuming Movie entity has a User field
        Movie createdMovie = movieService.saveMovie(movie, getCurrentUser());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdMovie);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Movie> updateMovie(@PathVariable Long id, @RequestBody Movie movie) {
        User currentUser = getCurrentUser();
        Optional<Movie> existingMovieOptional = movieService.getMovieByIdAndUser(id, currentUser);

        if (existingMovieOptional.isPresent()) {
            Movie existingMovie = existingMovieOptional.get();
            existingMovie.setTitle(movie.getTitle());
            existingMovie.setGenre(movie.getGenre());
            existingMovie.setWatched(movie.getWatched());
            existingMovie.setWatchDate(movie.getWatchDate());

            Movie updatedMovie = movieService.saveMovie(existingMovie, getCurrentUser());
            return ResponseEntity.ok(updatedMovie);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMovie(@PathVariable Long id) {
        User currentUser = getCurrentUser();
        Optional<Movie> existingMovie = movieService.getMovieByIdAndUser(id, currentUser);
        if (existingMovie.isPresent()) {
            movieService.deleteMovie(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/{id}/watched")
    public ResponseEntity<Movie> addToWatched(@PathVariable Long id) {
        User currentUser = getCurrentUser();
        try {
            Movie updatedMovie = movieService.addToWatchedAndUser(id, currentUser);
            return ResponseEntity.ok(updatedMovie);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/watched")
    public ResponseEntity<List<Movie>> getAllWatchedMovies() {
        User currentUser = getCurrentUser();
        List<Movie> watchedMovies = movieService.getAllWatchedMovies(currentUser);
        return ResponseEntity.ok(watchedMovies);
    }

    private UserDetails getCurrentUserDetails() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            Object principal = authentication.getPrincipal();
            if (principal instanceof UserDetails) {
                return (UserDetails) principal;
            } else {
                throw new UsernameNotFoundException("User not found in security context.");
            }
        }
        throw new UsernameNotFoundException("User not authenticated.");
    }

    private User getCurrentUser() {
        UserDetails userDetails = getCurrentUserDetails();
        return userRepository.findByEmail(userDetails.getUsername());
    }

}
