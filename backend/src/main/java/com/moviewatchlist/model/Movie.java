package com.moviewatchlist.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Movie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private String genre;
    private Boolean watched;
    private Date watchDate;
    private Date createdAt;
    @ManyToOne
    @JoinTable(name = "user_id")
    private User user;
}
