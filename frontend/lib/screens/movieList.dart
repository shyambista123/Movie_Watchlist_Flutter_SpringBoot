import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/authService.dart';
import 'package:frontend/screens/addEditMoviePage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/profilePage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Movielist extends StatefulWidget {
  const Movielist({super.key});

  @override
  State<Movielist> createState() => _MovielistState();
}

class _MovielistState extends State<Movielist> {
  List<dynamic> movies = [];
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _fetchTokenAndMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Movie WatchList",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 90, 201, 47),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showLogoutConfirmationDialog();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMovies,
        child: movies.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie_creation_outlined,
                        size: 100, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      "No movies in your watchlist",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = movies[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 90, 201, 47),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.movie,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie['title'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                    Icons.category, 'Genre: ${movie['genre']}'),
                                _buildInfoRow(
                                  Icons.visibility,
                                  'Watched: ${movie['watched'] ? 'Yes' : 'No'}',
                                ),
                                if (movie['watchDate'] != null)
                                  _buildInfoRow(
                                    Icons.calendar_today,
                                    'Watch Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(movie['watchDate']))}',
                                  ),
                                if (movie['createdAt'] != null)
                                  _buildInfoRow(
                                    Icons.access_time,
                                    'Created At: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(movie['createdAt']))}',
                                  ),
                              ],
                            ),
                          ),
                          ButtonBar( 
                            alignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text('Edit'),
                                onPressed: () =>
                                    navigateToEditPage(movie['id'], movie),
                              ),
                              TextButton(
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  confirmDeleteDialog(movie['id']);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 90, 201, 47),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  // Stay on the current page 
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: navigateToAddPage,
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: navigateToProfilePage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color.fromARGB(255, 90, 201, 47)),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void navigateToEditPage(dynamic movieId, Map<String, dynamic> movieData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMoviePage(
          movieId: movieId.toString(),
          movieData: movieData,
        ),
      ),
    );
  }

  void navigateToProfilePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void navigateToAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMoviePage(),
      ),
    );
  }

  Future<void> _fetchTokenAndMovies() async {
    final token = await _authService.getToken();
    if (token != null) {
      await _fetchMovies();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _fetchMovies() async {
    final token = await _authService.getToken();
    final apiUrl = dotenv.env['API_URL'] ?? '';
    final response = await http.get(
      Uri.parse('$apiUrl/api/movies'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    } else {
      print('Failed to load movies');
    }
  }

  Future<void> deleteMovie(int id) async {
    final token = await _authService.getToken();
    final apiUrl = dotenv.env['API_URL'] ?? '';

    final response = await http.delete(
      Uri.parse('$apiUrl/api/movies/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      await _fetchMovies();
    } else {
      print('Failed to delete movie');
    }
  }

  Future<void> confirmDeleteDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this movie?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteMovie(id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    final token = await _authService.getToken();
    final apiUrl = dotenv.env['API_URL'] ?? '';
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await _authService.deleteToken();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
