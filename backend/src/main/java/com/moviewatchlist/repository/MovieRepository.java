package com.moviewatchlist.repository;

import com.moviewatchlist.model.Movie;
import com.moviewatchlist.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MovieRepository extends JpaRepository<Movie, Long> {
    Movie findByTitle(String title);

    List<Movie> findByUser(User user);

    Optional<Movie> findByIdAndUser(Long id, User user);
    List<Movie> findByWatchedTrue();
}
