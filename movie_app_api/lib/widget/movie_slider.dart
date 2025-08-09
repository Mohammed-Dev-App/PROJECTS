import 'package:flutter/material.dart';
import 'package:movie_app_api/packages/carousel_slider/carousel_slider.dart';
import 'package:movie_app_api/packages/carousel_slider/carousel_options.dart';
import 'package:movie_app_api/packages/carousel_slider/carousel_controller.dart'
    as cs;
import 'package:movie_app_api/screens/pages/movie_detalis.dart';

class MovieSlider extends StatelessWidget {
  final List<dynamic> topRatedMovies;
  MovieSlider({super.key, required this.topRatedMovies});
  //CarouselController cs = CarouselController() ;
  cs.CarouselController _cs = cs.CarouselController();
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: topRatedMovies.length,
      itemBuilder: (context, index, realindex) {
        final movie = topRatedMovies[index];
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500/${movie['backdrop_path']}",
              fit: BoxFit.cover,
            ),
          ),
        );
      },

      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: Duration(seconds: 3),
        enableInfiniteScroll: true,
        pageSnapping: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
    );
  }
}
