package com.moviewatchlist;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MainController {
    @GetMapping("/")
    public String index() {
        return "<h1 style='color: red;'>Welcome to Movie Watchlist</h1>";
    }
}
