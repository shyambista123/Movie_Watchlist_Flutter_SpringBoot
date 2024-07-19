package com.moviewatchlist.controller;

import com.moviewatchlist.model.User;
import com.moviewatchlist.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {
    final UserService userService;
    @PostMapping("/register")
    public User registerUser(@RequestBody User user) {
        return userService.saveUser(user);
    }

    @PostMapping("/login")
    public String loginUser(@RequestBody User user) {
        if (userService.authenticate(user.getEmail(), user.getPassword())) {
            return "Login successful!";
        } else {
            return "Invalid email or password.";
        }
    }

}