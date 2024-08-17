package com.moviewatchlist.controller;

import com.moviewatchlist.model.User;
import com.moviewatchlist.repository.UserRepository;
import com.moviewatchlist.service.JwtService;
import com.moviewatchlist.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserRepository userRepo;


    @PostMapping("/register")
    public User registerUser(@RequestBody User user) {
        return userService.signUp(user);
    }
    @PostMapping("login")
    public String login(@RequestBody User user){

        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword()));

        if(authentication.isAuthenticated())
            return jwtService.generateToken(user.getUsername());
        else
            return "Login Failed";
    }
    @PostMapping("/logout")
    public String logout(@RequestHeader("Authorization") String token) {
        // Remove "Bearer " prefix if present
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        jwtService.blacklistToken(token);
        return "Logged out successfully";
    }
    @GetMapping("/me")
    public User getCurrentUser(@RequestHeader("Authorization") String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        if (jwtService.isTokenExpired(token)) {
            throw new RuntimeException("Invalid Token: Token has expired");
        }

        String username = jwtService.extractUserName(token);

        return userRepo.findByEmail(username);
    }
}
