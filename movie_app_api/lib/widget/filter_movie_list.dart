import 'package:flutter/material.dart';
import 'package:movie_app_api/screens/pages/movie_detalis.dart';

class FilterMovieList extends StatelessWidget {
  final List<dynamic> movies;
  const FilterMovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        final movie = movies[index];
        return ListTile(
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
          leading: Image.network(
            "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
            width: 50,
            height: 400,
            fit: BoxFit.cover,
          ),
          title: Text(movie['title']),
          subtitle: Text(movie['overview'], textAlign: TextAlign.justify),
        );
      },
    );
  }
}
