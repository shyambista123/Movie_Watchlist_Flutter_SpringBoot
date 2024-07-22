import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.blueAccent,
                child: const Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "john.doe@example.com",
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
                color: Colors.blue,
                child: const TabBar(
                  indicatorColor: Colors.white,
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
                  child: const TabBarView(
                    children: [
                      Center(child: Text("Watched List")),
                      Center(child: Text("Movie Watchlist")),
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
