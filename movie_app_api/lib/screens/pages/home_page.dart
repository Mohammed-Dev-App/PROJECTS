import 'package:flutter/material.dart';
import 'package:movie_app_api/main.dart';
import 'package:movie_app_api/screens/pages/movie_page.dart';
import 'package:movie_app_api/services/movie_service.dart';
import 'package:movie_app_api/widget/filter_movie_list.dart';
import 'package:movie_app_api/widget/hortizinal_view.dart';
import 'package:movie_app_api/widget/movie_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> popularMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> filterMovies = [];
  bool issearchBarEmpty = true;
  bool isloading = true;
  int page = 1;
  void filterMovie(String query) {
    setState(() {
      filterMovies =
          popularMovies
              .where(
                (movie) => movie['title'].toLowerCase().toString().contains(
                  query.toLowerCase(),
                ),
              )
              .toList() +
          upcomingMovies
              .where(
                (movie) => movie['title'].toLowerCase().toString().contains(
                  query.toLowerCase(),
                ),
              )
              .toList() +
          topRatedMovies
              .where(
                (movie) => movie['title'].toLowerCase().toString().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
      issearchBarEmpty = false;
    });
  }

  // String popular = "https://api.themoviedb.org/3/movie/popular";
  // String upcoming = "https://api.themoviedb.org/3/movie/upcoming";
  // String image_url = "https://image.tmdb.org/t/p/original/";
  // String api_key = "7c90258f985d1ea70b3856fa8acfd802";

  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TextField(
          onChanged: (value) {
            if (value.isEmpty)
              issearchBarEmpty = true;
            else
              filterMovie(value);
          },
          decoration: InputDecoration(
            hintText: "Search Movie",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    //print(printD);
    fetchMovies();

    super.initState();
  }

  Future<void> fetchMovies() async {
    MovieService movieService = MovieService();
    popularMovies = await movieService.popularMovies(page);

    upcomingMovies = await movieService.upcomingMovies(page);
    topRatedMovies = await movieService.topRatedMovies(page);
    setState(() {});
    isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30),

            searchBar(),
            SizedBox(height: 10),
            isloading
                ? Center(child: const CircularProgressIndicator())
                : !issearchBarEmpty
                ? Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Filter Movies",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FilterMovieList(movies: filterMovies),
                  ],
                )
                : Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MoviePage(title: "Top Rated Movies");
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Top Rated Movies",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MovieSlider(topRatedMovies: topRatedMovies),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MoviePage(title: "Upcoming Movies");
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Upcoming Movies",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    HortizinalView(movies: upcomingMovies),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MoviePage(title: "Popular Movies");
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Popular Movies",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    HortizinalView(movies: popularMovies),
                    SizedBox(height: 20),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
