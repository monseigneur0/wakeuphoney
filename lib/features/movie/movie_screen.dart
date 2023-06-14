// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  static String routeName = "movie";
  static String routeURL = "/movie";
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("movie")),
    );
  }
}
