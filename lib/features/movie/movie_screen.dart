// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'movie_model.dart';

class MovieScreen extends StatefulWidget {
  static String routeName = "movie";
  static String routeURL = "/movie";

  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = db.collection("movie").snapshots();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder(
      stream: streamData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return _buildBody(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildBody(BuildContext contex, List<DocumentSnapshot> snapshot) {
    List<Movie> movies = snapshot.map((e) => Movie.fromSnapshot(e)).toList();
    return ListView(
      children: [
        Stack(
          children: [
            CarouselImage(movies: movies),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}

class CarouselImage extends StatefulWidget {
  final List<Movie> movies;
  const CarouselImage({
    super.key,
    required this.movies,
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  late List<Movie> movies;
  late List<Widget> images;
  late List<String> keywords;
  late List<bool> likes;

  @override
  void initState() {
    super.initState();
    movies = widget.movies;
    images = movies.map((e) => Image.asset(e.poster)).toList();
    keywords = movies.map((e) => e.keyword).toList();
    likes = movies.map((e) => e.like).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(movies[index].toString());
      },
    );
  }
}
