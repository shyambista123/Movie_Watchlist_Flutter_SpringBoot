import 'package:flutter/material.dart';

class Movielist extends StatefulWidget {
  const Movielist({super.key});

  @override
  State<Movielist> createState() => _MovielistState();
}

class _MovielistState extends State<Movielist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie WatchList",
        style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.greenAccent[400],
        centerTitle: true
      ),
      body: const Text("No Movies!!!"),
    );
  }
}