import 'package:flutter/material.dart';
import 'package:youtube_app/helper.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/screens/video_page.dart';
import 'package:youtube_app/services/youtube_api_service.dart';
import 'package:youtube_app/widgets/video_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final YoutubeApiService _apiService = YoutubeApiService();
  bool isloading = false;
  List<VideoModel> searchResult = [];

  final TextEditingController _controller = TextEditingController();
  Future<void> performSearch(String query) async {
    await Helper.handleRequest(() async {
      setState(() {
        isloading = true;
      });
      final videos = await _apiService.fetchVideos(query: query);

      setState(() {
        searchResult = videos;
        isloading = false;
      });
      debugPrint(searchResult.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search Youtube",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              performSearch(value);
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                performSearch(_controller.text);
              }
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child:
                isloading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      child: VideoList(
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
                        videos: searchResult,
                        isloading: false,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
