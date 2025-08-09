import 'package:flutter/material.dart';
import 'package:movie_app_api/services/movie_service.dart';
import 'package:movie_app_api/widget/hortizinal_view.dart';

class MovieDetalis extends StatefulWidget {
  final dynamic movie;
  const MovieDetalis({super.key, required this.movie});

  @override
  State<MovieDetalis> createState() => _MovieDetalisState();
}

class _MovieDetalisState extends State<MovieDetalis> {
  List<dynamic> movies = [];
  int page = 1;
  @override
  void initState() {
    //print(printD);
    getData();

    super.initState();
  }

  Future<void> getData() async {
    MovieService movieService = MovieService();
    movies = await movieService.similarMovies(widget.movie['id'], page);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie['title'].toString())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://image.tmdb.org/t/p/w200/${widget.movie['backdrop_path']}",
              width: 150,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              "title : ${widget.movie['title']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Overview ${widget.movie['overview']}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              "Rating: ${widget.movie['vote_average']}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Vote count: ${widget.movie['vote_count']}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Popularity: ${widget.movie['popularity']}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Similar Movies",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            HortizinalView(movies: movies),
          ],
        ),
      ),
    );
  }
}
