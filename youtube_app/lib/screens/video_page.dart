import 'package:flutter/material.dart';
import 'package:youtube_app/helper.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/screens/channel_page.dart';
import 'package:youtube_app/services/youtube_api_service.dart';
import 'package:youtube_app/widgets/comments_section.dart';
import 'package:youtube_app/widgets/video_info_section.dart';
import 'package:youtube_app/widgets/video_list.dart';
import 'package:youtube_app/widgets/youtube_player_widget.dart';

class VideoPage extends StatefulWidget {
  final VideoModel video;
  const VideoPage({super.key, required this.video});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final YoutubeApiService _apiService = YoutubeApiService();
  List<VideoModel> recommendedVideos = [];
  bool isloading = true;
  String? error;
  late YoutubePlayerWidgetState _playerState;
  List<Map<String, dynamic>> commentd = [];
  bool iscommentLoading = true;
  bool iscommentExpanded = false;
  bool isFullScreen = false;
  bool isloadingMore = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadComments();
      debugPrint("commentd length after load: ${commentd.length}");

      await loadRecommendedVideos();
      debugPrint("Video id: ${widget.video.id}");
      debugPrint("Video content : ${commentd[0]}");
    });
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

  void toggleComments() {
    setState(() {
      iscommentExpanded = !iscommentExpanded;
    });
  }

  Future<void> loadComments() async {
    return Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          iscommentLoading = true;
        });
      }
      final comments = await _apiService.fetchComments(widget.video.id);
      if (mounted) {
        setState(() {
          commentd.addAll(comments);
          iscommentLoading = false;
        });
        debugPrint(commentd.toString());
      }
    });
  }

  Future<void> loadRecommendedVideos() async {
    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          isloading = true;
          error = null;
        });
        final videos = await _apiService.fetchVideos(query: widget.video.title);
        if (mounted) {
          setState(() {
            isloading = false;
            recommendedVideos = videos;
            debugPrint(recommendedVideos.toString());
          });
        }
      }
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
          recommendedVideos.addAll(moreVideos);
          isloadingMore = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      body: Column(
        children: [
          YoutubePlayerWidget(
            videoId: widget.video.id,
            onPlayerStateCreated: (state) {
              _playerState = state;
            },
            onFullScreenChange: (_isFullScreen) {
              setState(() {
                isFullScreen = _isFullScreen;
              });
            },
          ),
          if (!isFullScreen)
            Expanded(
              child:
                  iscommentExpanded
                      ? CommentsSection(
                        comments: commentd,
                        isloading: iscommentLoading,
                        onCommentTap: toggleComments,
                        isCommentExpanded: true,
                        onClose: toggleComments,
                      )
                      : ListView(
                        controller: _scrollController,
                        children: [
                          VideoInfoSection(
                            video: widget.video,
                            onChannelTap: () {
                              _playerState.pause();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChannelPage(
                                        channelId: widget.video.channeld,
                                      ),
                                ),
                              );
                            },
                          ),
                          CommentsSection(
                            comments: commentd,
                            isloading: iscommentLoading,
                            onCommentTap: toggleComments,
                            isCommentExpanded: false,
                            onClose: toggleComments,
                          ),
                          if (isloading)
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            )
                          else if (error != null)
                            Center(
                              child: Text(
                                error!,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          else
                            Column(
                              children:
                                  recommendedVideos.map((video) {
                                    return VideoList(
                                      onValueSelected: (video) {
                                        _playerState.pause();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    VideoPage(video: video),
                                          ),
                                        );
                                      },
                                      videos: [video],
                                      isloading: false,
                                    );
                                  }).toList(),
                            ),
                        ],
                      ),
            ),
        ],
      ),
    );
  }
}
