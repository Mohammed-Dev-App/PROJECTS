import 'package:flutter/material.dart';
import 'package:youtube_app/helper.dart';
import 'package:youtube_app/models/channel_model.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/screens/play_list_page.dart';
import 'package:youtube_app/screens/video_page.dart';
import 'package:youtube_app/services/youtube_api_service.dart';

class ChannelPage extends StatefulWidget {
  final String channelId;
  const ChannelPage({super.key, required this.channelId});

  @override
  State<ChannelPage> createState() => ChannelPageState();
}

class ChannelPageState extends State<ChannelPage>
    with SingleTickerProviderStateMixin {
  final YoutubeApiService _apiService = YoutubeApiService();
  ChannelModel? channel;
  List<VideoModel> videos = [];
  List<VideoModel> videosShort = [];
  List<List<String>> videoPlaylistIds = [];
  List<List<String>> playlist = [];
  bool isloading = true;
  bool isloadingmore = false;
  String? videoPageToken;

  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadChannelData() async {
    setState(() {
      isloading = true;
    });

    final channelResult = await Helper.handleRequest(
      () => _apiService.fetchChannelDetails(widget.channelId),
    );

    final videoResult = await _apiService.fetchChannelVideos(
      widget.channelId,
      '',
    );

    final shortResult = await _apiService.fetchChannelVideos(
      widget.channelId,
      'short',
    );

    final playlistResult = await _apiService.fetchPlayList(widget.channelId);
    for (var i in playlistResult) {
      final result = await _apiService.fetchPlaylistVideos(i[0]);
      videoPlaylistIds.add(result);
    }

    if (mounted) {
      setState(() {
        channel = channelResult;
        videos = videoResult;
        videosShort = shortResult;
        playlist = playlistResult;

        isloading = false;
      });
    }
  }

  Future<void> loadMoreVideos() async {
    debugPrint("Tab bar index ${_tabController.index}");
    setState(() {
      isloadingmore = true;
    });
    final nextPageToken = _apiService.nextPageToken;
    if (mounted) {
      debugPrint("Video Page Token $nextPageToken");
      int currentTab = _tabController.index;
      if (currentTab == 0) {
        final moreVideos = await _apiService.fetchChannelVideos(
          widget.channelId,

          '',
          nextPageToken: nextPageToken,
        );
        if (mounted) {
          setState(() {
            videos.addAll(moreVideos);
            isloadingmore = false;
          });
        }
      } else if (currentTab == 1) {
        final moreVideos = await _apiService.fetchChannelVideos(
          widget.channelId,

          'short',
          nextPageToken: nextPageToken,
        );
        if (mounted) {
          setState(() {
            videosShort.addAll(moreVideos);
            isloadingmore = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController = ScrollController();
      _scrollController.addListener(onScroll);
      loadChannelData();
    });

    _tabController = TabController(length: 3, vsync: this);
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
    if (isloading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (channel == null) {
      return Scaffold(body: Center(child: Text("Failed to load Channel")));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.cast)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                channel!.bannerUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: Center(child: Icon(Icons.error)),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(channel!.thumbnailUrl),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    // flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                channel!.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (channel!.isVerified)
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.blueAccent,
                              ),
                          ],
                        ),
                        Text(
                          channel!.handle,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Text(
                          "${channel!.subscriberCount} subscribers • ${channel!.videoCount} videos",

                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel!.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // style: TextStyle(color: Colors.grey[400]),
                  ),
                  if (channel!.links.isNotEmpty)
                    Text(
                      channel!.links.first,
                      style: TextStyle(color: Colors.blue),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: Text("Subscribe"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: Text("Join"),
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [Text("HOME"), Text("SHORTS"), Text("PLAYLIST")],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildVideoList(videos),
                  buildVideoList(videosShort),
                  buildPlayList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoList(List<VideoModel> value) {
    // loadChannelData(value);
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: value.length,
      itemBuilder: (context, index) {
        final video = value[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return VideoPage(video: video);
                },
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(video.thumbnaiUrl, fit: BoxFit.cover),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            video.duration,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${video.viewCount} + ${video.publishedTime}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPlayList() {
    if (playlist.isEmpty) {
      return Center(
        child: Text(
          "No Playlist",
          style: TextStyle(fontSize: 34, color: Colors.blueAccent),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          if (videoPlaylistIds[index].isEmpty) return SizedBox.shrink();

          return GestureDetector(
            onTap: () {
              debugPrint(
                "video length ${videoPlaylistIds[index].length.toString()}",
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlayListPage(videosId: videoPlaylistIds[index]);
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      playlist[index][1],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(width: 8),
                  Stack(
                    children: [
                      Image.network(
                        playlist[index][2],
                        height: 125,
                        width: 125,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            height: 125,
                            width: 125,

                            child: Icon(
                              Icons.hide_image_sharp,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 125,
                          height: 50,
                          color: Colors.black.withOpacity(0.6),
                          child: Row(
                            children: [
                              Icon(Icons.menu, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "+${videoPlaylistIds[index].length}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
