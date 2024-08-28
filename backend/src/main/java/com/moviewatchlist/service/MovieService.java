package com.moviewatchlist.service;

import com.moviewatchlist.model.Movie;
import com.moviewatchlist.model.User;
import com.moviewatchlist.repository.MovieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MovieService {

    private final MovieRepository movieRepository;

    public List<Movie> getMoviesByUser(User user) {
        return movieRepository.findByUser(user);
    }
    public Optional<Movie> getMovieByIdAndUser(Long id, User user) {
        return movieRepository.findByIdAndUser(id, user);
    }

    public Movie saveMovie(Movie movie, User user) {
        Date watch_date = movie.getWatchDate();
        if (watch_date != null && watch_date.before(new Date())) {
            movie.setWatched(true);
        }
        return movieRepository.save(movie);
    }

    public void deleteMovie(Long id) {
        movieRepository.deleteById(id);
    }

    public Movie addToWatchedAndUser(Long id, User user) {
        Optional<Movie> optionalMovie = movieRepository.findByIdAndUser(id, user);
        if (optionalMovie.isPresent()) {
            Movie movie = optionalMovie.get();
            movie.setWatched(true);
            movie.setWatchDate(new Date());
            return movieRepository.save(movie);
        } else {
            throw new RuntimeException("Movie not found with id: " + id + " for user: " + user.getEmail());
        }
    }

    public List<Movie> getAllWatchedMovies(User user) {
        return movieRepository.findByWatchedTrue();
    }

}
