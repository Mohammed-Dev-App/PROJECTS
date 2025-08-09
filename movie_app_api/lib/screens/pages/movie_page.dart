import 'package:flutter/material.dart';
import 'package:movie_app_api/screens/pages/movie_detalis.dart';
import 'package:movie_app_api/services/movie_service.dart';

class MoviePage extends StatefulWidget {
  final String title;
  MoviePage({super.key, required this.title});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<dynamic> _Movies = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int page = 1;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    getData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore &&
        !isLoading) {
      loadMore();
    }
  }

  Future<void> getData() async {
    MovieService movieService = MovieService();
    List<dynamic> newMovies = [];

    if (widget.title == "Popular Movies") {
      newMovies = await movieService.popularMovies(page);
    } else if (widget.title == "Upcoming Movies") {
      newMovies = await movieService.upcomingMovies(page);
    } else {
      newMovies = await movieService.topRatedMovies(page);
    }

    setState(() {
      _Movies.addAll(newMovies);
      isLoading = false;
    });
  }

  Future<void> loadMore() async {
    setState(() {
      isLoadingMore = true;
      page += 1;
    });

    await getData();

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: EdgeInsets.all(8),
                    children: List.generate(_Movies.length, (index) {
                      final movie = _Movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetalis(movie: movie),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w200/${movie['backdrop_path']}",
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  movie['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  if (isLoadingMore)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
    );
  }
}
