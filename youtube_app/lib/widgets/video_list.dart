import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoList extends StatelessWidget {
  List<VideoModel> videos;

  bool isloading;
  final ValueChanged<VideoModel> onValueSelected;

  VideoList({
    super.key,
    required this.onValueSelected,
    required this.videos,

    required this.isloading,
  });
  Future<void> videoMainfest(VideoModel video) async {
    var _yt = YoutubeExplode();

    try {
      final manifest = await _yt.videos.streamsClient.getManifest(video.id);
      final muxed = manifest.muxed.toList();
      for (final stream in muxed) {
        debugPrint("muxed $stream");
      }
    } catch (e, stack) {
      debugPrint("Exception during download: $e\n$stack");
    } finally {
      _yt.close();
    }
  }

  bool show = false;
  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children:
              videos
                  .map(
                    (video) => GestureDetector(
                      onTap:
                          () =>
                              onValueSelected(video), //videoMainfest(video), //
                      child: Column(
                        children: [
                          // SizedBox(height: 5),
                          Stack(
                            alignment:
                                video.isLive
                                    ? Alignment.topRight
                                    : Alignment.bottomRight,
                            children: [
                              Image.network(
                                video.thumbnaiUrl,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                    height: 220,
                                    width: double.infinity,
                                    child: Icon(
                                      Icons.hide_image_sharp,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              if (!video.isLive)
                                Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    video.duration,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              if (video.isLive)
                                Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Live",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    video.channelAvatarUrl,
                                  ),
                                  radius: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        video.channelTitle,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        " ${video.viewCount} + ${video.publishedTime}",
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    videoMainfest(video);
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
        if (show)
          Container(
            color: Colors.grey[900],
            height: MediaQuery.of(context).size.height - 300,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(color: Colors.white54, child: Text("144p")),
                Container(color: Colors.white54, child: Text("244p")),
                Container(color: Colors.white54, child: Text("360p")),
              ],
            ),
          ),
      ],
    );
  }
}
