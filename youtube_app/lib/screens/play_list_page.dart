// import 'package:flutter/material.dart';
// import 'package:youtube_app/widgets/youtube_player_widget.dart';

// class PlayListVideo extends StatelessWidget {
//   final List<String> videosId;
//   PlayListVideo({super.key, required this.videosId});
//   late YoutubePlayerWidgetState _playerState;
//   bool isFullScreen = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           YoutubePlayerWidget(
//             videoId: videosId[0],
//             onPlayerStateCreated: (state) {
//               _playerState = state;
//             },
//             onFullScreenChange: (_isFullScreen) {
//               isFullScreen = _isFullScreen;
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/services/youtube_api_service.dart';
import 'package:youtube_app/widgets/youtube_player_widget.dart';

class PlayListPage extends StatefulWidget {
  final List<String> videosId;
  final int? currentVideo;
  const PlayListPage({
    super.key,
    required this.videosId,
    this.currentVideo = 0,
  });

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  late YoutubePlayerWidgetState _playerState;
  final YoutubeApiService _apiService = YoutubeApiService();
  bool isFullScreen = false;
  bool isloading = false;
  List<VideoModel?> video = [];

  Widget actionError = Center(
    child: CircularProgressIndicator(color: Colors.blueAccent),
  );
  loadVideoDetails() async {
    setState(() {
      isloading = false;
      actionError = Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    });
    try {
      for (var id in widget.videosId) {
        final details = await _apiService.getVideoDetails(id);
        final result = await VideoModel.fromJson(details);
        setState(() {
          video.add(result);
        });
      }
      debugPrint("video length ${video.length}");
      setState(() {
        isloading = true;
      });
    } catch (e) {
      setState(() {
        actionError = Center(
          child: Text(
            "Please, check your connection",
            style: TextStyle(fontSize: 24, color: Colors.blueAccent),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVideoDetails();
    });
    // debugPrint("video length ${video.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              loadVideoDetails();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body:
          isloading
              ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      child: Column(
                        children: [
                          isFullScreen
                              ? YoutubePlayerWidget(
                                videoId: widget.videosId[widget.currentVideo!],
                                onPlayerStateCreated: (state) {
                                  _playerState = state;
                                },
                                onFullScreenChange: (isFullScreenVideo) {
                                  setState(() {
                                    isFullScreen = isFullScreenVideo;
                                  });
                                },
                              )
                              : YoutubePlayerWidget(
                                videoId: widget.videosId[widget.currentVideo!],
                                onPlayerStateCreated: (state) {
                                  _playerState = state;
                                },
                                onFullScreenChange: (isFullScreenVideo) {
                                  setState(() {
                                    isFullScreen = isFullScreenVideo;
                                  });
                                },
                              ),
                          Text(
                            video[widget.currentVideo!]!.title,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // SingleChildScrollView(
                          //   child: ListView.builder(
                          //     itemCount: video.length,
                          //     itemBuilder: (cintext, index) {
                          //       return currentVideo != index
                          //           ? Text(
                          //             " video[index]!.title",
                          //             style: TextStyle(color: Colors.white),
                          //           )
                          //           : null;
                          //     },
                          //   ),
                          // ),
                          //videoList(),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            child:
                                index != widget.currentVideo
                                    ? Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            video[index]!.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Image.network(
                                              video[index]!.thumbnaiUrl,
                                              height: 100,
                                              // width: 200,
                                            ),
                                            Positioned(
                                              right: 2,
                                              bottom: 8,
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                color: Colors.black,
                                                child: Text(
                                                  video[index]!.duration,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                    : SizedBox.shrink(),
                            onTap: () {
                              setState(() {
                                _playerState.pause();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PlayListPage(
                                        videosId: widget.videosId,
                                        currentVideo: index,
                                      );
                                    },
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      );
                    }, childCount: video.length),
                  ),
                ],
              )
              : actionError,
    );
  }

  // Widget videoList() {
  //   return ListView.builder(
  //     itemCount: video.length,
  //     itemBuilder: (cintext, index) {
  //       return currentVideo != index
  //           ? Text(video[index]!.title, style: TextStyle(color: Colors.white))
  //           : null;
  //     },
  //   );
  // }
}
