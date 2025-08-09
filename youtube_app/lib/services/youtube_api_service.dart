import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_app/helper.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/models/channel_model.dart';

class YoutubeApiService {
  final String _baseUrl = "https://www.googleapis.com/youtube/v3";
  final String _apiKey = "YOUR_API_KEY"; //WRITE YOUR_API_KEY

  String? _nextPageToken;

  Future<List<VideoModel>> fetchVideos({
    String query = "",
    String? pageToken,
    int maxResult = 10,
    String videoCategoryId = '',
  }) async {
    return await Helper.handleRequest<List<VideoModel>>(() async {
          final Uri uri =
              query.isEmpty
                  ? Uri.parse(
                    '$_baseUrl/videos?part=snippet,statistics,contentDetails&relevanceLanguage=ar&chart=mostPopular${videoCategoryId != '' ? '&videoCategoryId=$videoCategoryId' : ''}&maxResults=$maxResult${pageToken != null ? '&pageToken=$pageToken' : ''}&key=$_apiKey',
                  )
                  : Uri.parse(
                    '$_baseUrl/search?part=snippet&q=$query&type=video&maxResults=$maxResult${pageToken != null ? '&pageToken=$pageToken' : ''}&key=$_apiKey',
                  );

          final response = await http.get(uri);
          debugPrint(uri.toString());
          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            _nextPageToken = data['nextPageToken'];
            final List<dynamic> items = data['items'];

            final List<VideoModel> videos = [];

            if (query.isNotEmpty) {
              for (var item in items) {
                final videoId = item['id']?['videoId'];
                if (videoId != null) {
                  final details = await getVideoDetails(videoId);
                  if (details.isNotEmpty) {
                    final video = await VideoModel.fromJson(details);
                    if (video != null) {
                      videos.add(video);
                    }
                  }
                }
              }
            } else {
              for (var item in items) {
                final video = await VideoModel.fromJson(item);
                if (video != null) {
                  videos.add(video);
                }
              }
            }

            return videos;
          } else {
            debugPrint("API Error: ${response.statusCode} - ${response.body}");
            return [];
          }
        }) ??
        [];
  }

  Future<List<VideoModel>> fetchShortVideos({
    String? pageToken,
    int maxResult = 10,
  }) async {
    return await Helper.handleRequest<List<VideoModel>>(() async {
          final Uri uri = Uri.parse(
            '$_baseUrl/search?part=snippet'
            '&maxResults=$maxResult'
            '&q=*'
            '&type=video'
            '&videoDuration=short'
            '&relevanceLanguage=ar'
            '${pageToken != null ? '&pageToken=$pageToken' : ''}'
            '&key=$_apiKey',
          );

          debugPrint("Fetching shorts: $uri");

          final response = await http.get(uri);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            _nextPageToken = data['nextPageToken'];
            final List<dynamic> items = data['items'];

            final List<VideoModel> videos = [];

            for (var item in items) {
              try {
                final videoId = item['id']?['videoId'];
                if (videoId != null) {
                  final details = await getVideoDetails(videoId);
                  if (details.isNotEmpty) {
                    final video = await VideoModel.fromJson(details);
                    if (video != null) {
                      videos.add(video);
                    }
                  }
                }
              } catch (e, stack) {
                debugPrint("❌ Error parsing short video item: $e\n$stack");
              }
            }

            return videos;
          } else {
            debugPrint(
              "❌ API Error: ${response.statusCode} - ${response.body}",
            );
            return [];
          }
        }) ??
        [];
  }

  Future<Map<String, dynamic>> getVideoDetails(String videoId) async {
    return await Helper.handleRequest(() async {
      final uri = Uri.parse(
        '$_baseUrl/videos?part=snippet,statistics,contentDetails&id=$videoId&key=$_apiKey',
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        return items.isNotEmpty ? items.first : null;
      }
      debugPrint(
        "Video details API Err :${response.statusCode} -${response.body}  ",
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchComments(String videoId) async {
    return await Helper.handleRequest<List<Map<String, dynamic>>>(() async {
          final uri = Uri.parse(
            "$_baseUrl/commentThreads?part=snippet&videoId=$videoId&maxResults=20&key=$_apiKey",
          );
          debugPrint(uri.toString());
          final response = await http.get(uri);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<dynamic> items = data['items'];

            return items.map((item) {
              final snippet = item['snippet']['topLevelComment']['snippet'];
              return {
                'author': snippet['authorDisplayName'],
                'authorProfileImageUrl': snippet['authorProfileImageUrl'],
                'text': snippet['textDisplay'],
                'likeCount': snippet['likeCount'],
                'publishedAt': snippet['publishedAt'],
              };
            }).toList();
          } else {
            debugPrint(
              "Comment API Error: ${response.statusCode} + ${response.body}",
            );
            return [];
          }
        }) ??
        [];
  }

  Future<ChannelModel?> fetchChannelDetails(String channelId) async {
    return Helper.handleRequest<ChannelModel?>(() async {
      final uri = Uri.parse(
        '$_baseUrl/channels?part=snippet,statistics,brandingSettings&id=$channelId&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        if (items.isNotEmpty) {
          return ChannelModel.fromJson(items.first);
        } else {
          return null;
        }
      } else {
        debugPrint('Channel API: ${response.statusCode} - ${response.body}');
        return null;
      }
    });
  }

  Future<List<VideoModel>> fetchChannelVideos(
    String channelId,
    String? option, {
    String? nextPageToken,
  }) async {
    return await Helper.handleRequest<List<VideoModel>>(() async {
          final uri = Uri.parse(
            '$_baseUrl/search?part=snippet&channelId=$channelId&maxResults=15${option != '' ? '&type=video&videoDuration=$option' : '&order-date=type-video'}${nextPageToken != null ? '&pageToken=$nextPageToken' : ''}&key=$_apiKey',
          );
          final response = await http.get(uri);
          debugPrint(uri.toString());
          if (response.statusCode == 200) {
            final dynamic data = json.decode(response.body);
            _nextPageToken = data['nextPageToken'];
            // debugPrint("next page token$nextPageToken");
            final List<dynamic> items = data['items'];

            final List<VideoModel> videos = [];
            debugPrint("I am after items");
            for (var item in items) {
              // debugPrint(item);

              final videoId = item['id']['videoId'] ?? '';
              if (videoId == '') {
                continue;
              }
              //  debugPrint("I am after videoId");
              final details = await getVideoDetails(videoId);
              //debugPrint("I am after getVideoDetails");
              final video = await VideoModel.fromJson(details);
              //debugPrint("I am after videoModel");
              if (video != null) {
                videos.add(video);
              }
            }
            debugPrint(
              "Channel Video API Success: ${response.statusCode} + ${response.body}",
            );
            //   debugPrint("$videos");
            return videos;
          } else {
            debugPrint(
              "Channel Video API Error: ${response.statusCode} + ${response.body}",
            );
            return [];
          }
        }) ??
        [];
  }

  String? get nextPageToken => _nextPageToken;

  Future<List<List<String>>> fetchPlayList(String channelId) async {
    return await Helper.handleRequest<List<List<String>>>(() async {
          final uri = Uri.parse(
            '$_baseUrl/playlists?part=snippet&channelId=$channelId&key=$_apiKey',
          );
          final response = await http.get(uri);
          debugPrint(uri.toString());
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<dynamic> items = data['items'];
            if (items.isNotEmpty) {
              List<List<String>> playlist = [];
              for (var item in items) {
                final List<String> result = [];
                result.add(item['id']);
                result.add(item['snippet']['title']);
                result.add(
                  item['snippet']['thumbnails']['default']['url'] ??
                      item['snippet']['thumbnails']['high']['url'] ??
                      item['snippet']['thumbnails']['medium']['url'],
                );
                playlist.add(result);
              }
              //  debugPrint("Items value ${playlist.toString()}");
              return playlist;
            } else {
              return [];
            }
          } else {
            debugPrint(
              "API Error to Fetch PlayList ${response.statusCode} + ${response.body}",
            );
            return [];
          }
        }) ??
        [];
  }

  Future<List<String>> fetchPlaylistVideos(String playlistId) async {
    return await Helper.handleRequest<List<String>>(() async {
          final uri = Uri.parse(
            '$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&key=$_apiKey',
          );
          final response = await http.get(uri);
          debugPrint(uri.toString());
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<dynamic> items = data['items'];
            debugPrint("After items");
            List<String> videos = [];
            if (items.isNotEmpty) {
              for (var item in items) {
                debugPrint("Item playlist value is $item");
                String result = item['snippet']['resourceId']['videoId'] ?? '';
                debugPrint("After Video Model");
                debugPrint(result.toString());
                if (result == '') {
                  continue;
                }
                videos.add(result);
              }

              debugPrint(videos.toString());
              return videos;
            } else {
              return [];
            }
          } else {
            debugPrint(
              "API Error to Fetch PlayList Videos ${response.statusCode} + ${response.body}",
            );
            return [];
          }
        }) ??
        [];
  }
}
