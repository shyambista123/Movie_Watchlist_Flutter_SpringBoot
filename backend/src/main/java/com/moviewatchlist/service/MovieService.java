package com.moviewatchlist.service;

import com.moviewatchlist.model.Movie;
import com.moviewatchlist.model.User;
import com.moviewatchlist.repository.MovieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MovieService {

    private final MovieRepository movieRepository;

    public List<Movie> getAllMovies() {
        return movieRepository.findAll();
    }

    public Optional<Movie> getMovieById(Long id) {
        return movieRepository.findById(id);
    }

    public Movie saveMovie(Movie movie, User user) {
        movie.setUser(user); // Set the user who is creating the movie
        return movieRepository.save(movie);
    }

    public void deleteMovie(Long id) {
        movieRepository.deleteById(id);
    }

    public Movie addToWatched(Long id) {
        Optional<Movie> optionalMovie = movieRepository.findById(id);
        if (optionalMovie.isPresent()) {
            Movie movie = optionalMovie.get();
            movie.setWatched(true);
            return movieRepository.save(movie);
        } else {
            throw new RuntimeException("Movie not found with id: " + id);
        }
    }

    public List<Movie> getAllWatchedMovies() {
        return movieRepository.findByWatchedTrue();
    }

}
