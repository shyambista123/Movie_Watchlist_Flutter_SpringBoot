import 'package:flutter/material.dart';
import 'package:frontend/authService.dart';
import 'package:frontend/screens/movieWatchlistPage.dart';
import 'package:frontend/screens/watchedListPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> moviesWatched = [];
  List<Map<String, dynamic>> moviesWatchlist = [];
  late AuthService _authService;
  String fullName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _fetchUserDetails();
    _fetchMovies();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final token = await _authService.getToken();
      final apiUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse('$apiUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          fullName = userData['name'] ?? '';
          email = userData['email'] ?? '';
        });
      } else {
        print('Failed to load user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _fetchMovies() async {
    try {
      final token = await _authService.getToken();
      final apiUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse('$apiUrl/api/movies'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> allMoviesDynamic = json.decode(response.body);
        final List<Map<String, dynamic>> allMovies =
            allMoviesDynamic.cast<Map<String, dynamic>>();

        setState(() {
          moviesWatched =
              allMovies.where((movie) => movie['watched'] == true).toList();
          moviesWatchlist =
              allMovies.where((movie) => movie['watched'] == false).toList();
        });
      } else {
        print('Failed to load movies');
      }
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.blueAccent,
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        fullName.isNotEmpty ? fullName : 'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email.isNotEmpty ? email : 'Loading...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 130, 209, 26),
                child: const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: "Watched List"),
                    Tab(text: "Movie Watchlist"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 300,
                  child: TabBarView(
                    children: [
                      WatchedListPage(moviesWatched: moviesWatched),
                      MovieWatchlistPage(moviesWatchlist: moviesWatchlist),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
