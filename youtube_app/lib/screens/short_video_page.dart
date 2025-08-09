// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:youtube_app/helper.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/screens/video_page.dart';
import 'package:youtube_app/services/youtube_api_service.dart';
import 'package:youtube_app/widgets/video_list.dart';

class ShortVideoPage extends StatefulWidget {
  const ShortVideoPage({super.key});

  @override
  State<ShortVideoPage> createState() => _ShortVideoPageState();
}

class _ShortVideoPageState extends State<ShortVideoPage> {
  final YoutubeApiService _apiService = YoutubeApiService();
  bool isloading = true;
  bool isloadingMore = false;
  List<VideoModel> videos = [];
  final ScrollController _scrollController = ScrollController();
  Future<void> loadVideos() async {
    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          isloading = true;
        });
      }

      final _videos = await _apiService.fetchShortVideos();
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
      final moreVideos = await _apiService.fetchShortVideos(
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
    loadVideos();
    _scrollController.addListener(onScroll);
    debugPrint("I am ShortPage");
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
