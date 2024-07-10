package com.moviewatchlist.controller;

import com.moviewatchlist.model.User;
import com.moviewatchlist.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class UserController {
    final UserRepository userRepository;
    @GetMapping("/users")
    public List<User> allUsers(){
        return userRepository.findAll();
    }
}
