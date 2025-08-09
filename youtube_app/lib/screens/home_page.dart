import 'package:flutter/material.dart';
import 'package:youtube_app/helper.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/screens/video_page.dart';
import 'package:youtube_app/services/youtube_api_service.dart';
import 'package:youtube_app/widgets/categorywise.dart';
import 'package:youtube_app/widgets/video_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  final YoutubeApiService _apiService = YoutubeApiService();
  bool isloading = true;
  bool isloadingMore = false;
  List<VideoModel> videos = [];
  String categorey = '';
  final List<String> categories = [
    "All",
    "Movie ",
    "Music",
    "Pets",
    "Sports",
    "Games",
    "Comedy",
    "News",
    "Science",
  ];
  final List<String> categories_id = [
    '',
    "1",
    "10",
    "15",
    "17",
    "20",
    "23",
    "25",
    "28",
  ];

  final ScrollController _scrollController = ScrollController();
  Future<void> loadVideos({String category = ''}) async {
    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          isloading = true;
        });
      }
      final _videos = await _apiService.fetchVideos(videoCategoryId: category);
      if (mounted) {
        setState(() {
          isloading = false;
          videos = _videos;
        });
      }
      debugPrint(_videos.length.toString());
    });
  }

  Future<void> loadMoreVideos() async {
    if (isloadingMore) return;

    final nextPageToken = _apiService.nextPageToken;

    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          isloadingMore = true;
        });
      }
      debugPrint("next Page Token $nextPageToken ");
      final moreVideos = await _apiService.fetchVideos(
        pageToken: nextPageToken,
      );
      if (mounted) {
        setState(() {
          videos.addAll(moreVideos);
          isloadingMore = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadVideos(category: categorey);
    debugPrint("Home Page");
    _scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint("Scroller Action");
      loadMoreVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Categorywise(
            categories: categories,
            selectedCategoryIndex: selectedCategory,
            onCategorySelected: (index) {
              setState(() {
                selectedCategory = index;
                if (index != 0) {
                  categorey = categories_id[index];
                  loadVideos(category: categorey);
                } else {
                  loadVideos();
                }
              });
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadVideos,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      VideoList(
                        onValueSelected: (video) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VideoPage(video: video);
                              },
                            ),
                          );
                        },
                        videos: videos,
                        isloading: isloading,
                      ),
                    ]),
                  ),

                  if (isloadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
