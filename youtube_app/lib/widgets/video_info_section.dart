import 'package:flutter/material.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/services/youtube_api_service.dart';

class VideoInfoSection extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onChannelTap;
  const VideoInfoSection({
    super.key,
    required this.video,
    required this.onChannelTap,
  });
  @override
  State<VideoInfoSection> createState() => VideoInfoSectionState();
}

class VideoInfoSectionState extends State<VideoInfoSection> {
  final YoutubeApiService _apiService = YoutubeApiService();

  Future<String> getSubscriberCount() async {
    final channel = await _apiService.fetchChannelDetails(
      widget.video.channeld,
    );
    return channel!.subscriberCount;
  }

  String subscriber = '';

  @override
  initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final subscriberCount = await getSubscriberCount();
    setState(() {
      subscriber = subscriberCount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            widget.video.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                widget.video.viewCount,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Text("+", style: TextStyle(color: Colors.grey[400])),
              SizedBox(width: 8),
              Text(
                widget.video.publishedTime,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            widget.onChannelTap();
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.video.channelAvatarUrl),
          ),
          title: Text(
            widget.video.channelTitle,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "$subscriber subscribers",
            style: TextStyle(color: Colors.grey[400]),
          ),
          trailing: TextButton(
            onPressed: () {},
            child: Text(
              "SUBSCRIBE",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
