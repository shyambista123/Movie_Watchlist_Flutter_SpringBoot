# Movie Watchlist Backend

## Overview

The Movie Watchlist Backend is a RESTful API built with Spring Boot. It provides functionalities for managing movies, including user authentication and personalized movie management. Users can register, log in, add, edit, delete, and view movies. They can also maintain a watched list that is specific to their account.

## Features

- **User Authentication**
  - Register
  - Login
  - Logout

- **Movie Management**
  - Add Movie
  - Edit Movie
  - Delete Movie
  - View Movies

- **Watched List**
  - Add movies to watched list
  - View movies in watched list

- **User-Specific Access**
  - Users can only access their own movies

## Technologies Used

- **Spring Boot**: Framework for building the REST API.
- **Spring Security**: For authentication and authorization.
- **JPA**: For database interactions.
- **PostgreSQL Database**: For storing movie and user data.

## Getting Started

### Prerequisites

- Java 17 or higher
- Maven
- IDE (e.g., IntelliJ IDEA, Eclipse)

