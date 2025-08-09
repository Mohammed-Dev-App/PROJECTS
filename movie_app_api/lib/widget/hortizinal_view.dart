import 'package:flutter/material.dart';
import 'package:movie_app_api/screens/pages/movie_detalis.dart';

class HortizinalView extends StatelessWidget {
  final List<dynamic> movies;
  HortizinalView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(movies.length, (index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MovieDetalis(movie: movie);
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Image.network(
                    "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(child: Text(movie['title'])),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
