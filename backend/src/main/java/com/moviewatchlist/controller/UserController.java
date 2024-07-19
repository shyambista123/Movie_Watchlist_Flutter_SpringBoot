package com.moviewatchlist.controller;

import com.moviewatchlist.model.User;
import com.moviewatchlist.repository.UserRepository;
import com.moviewatchlist.service.UserService;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {
    final UserService userService;
    final UserRepository userRepo;

    @GetMapping
    public List<User> allUsers(){
        return userRepo.findAll();
    }
    @PostMapping("/register")
    public User registerUser(@RequestBody User user) {
        return userService.saveUser(user);
    }

    @PostMapping("/login")
    public String loginUser(@RequestBody User user) {
        if (SecurityContextHolder.getContext().getAuthentication().isAuthenticated()) {
            return "Login successful!";
        } else {
            return "Invalid email or password.";
        }
    }
}