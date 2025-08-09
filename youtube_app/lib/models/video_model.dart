import 'package:youtube_app/helper.dart';

class VideoModel {
  final String id;
  final String title;
  final String thumbnaiUrl;
  final String channelTitle;
  final String viewCount;
  final String publishedTime;
  final String channelAvatarUrl;
  final String duration;
  final String channeld;
  final String description;
  final bool isLive;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnaiUrl,
    required this.channelTitle,
    required this.viewCount,
    required this.publishedTime,
    required this.channelAvatarUrl,
    required this.duration,
    required this.channeld,
    required this.description,
    required this.isLive,
  });
  static Future<VideoModel?> fromJson(Map<String, dynamic> json) async {
    return await Helper.handleRequest<VideoModel>(() async {
      final snippet = json['snippet'] ?? ();
      final statistics = json['statistics'] ?? ();
      final contentDetails = json['contentDetails'] ?? ();

      String videoId = '';
      if (json['id'] is String) {
        videoId = json['id'];
      } else if (json['id'] is Map) {
        //  print("playlist id ${json['id']['playlistId']}");
        videoId = json['id']?['videoId'] ?? json['id']?['playlistId'] ?? '';
      }

      String viewCount = 'o views';
      if (statistics['viewCount'] != null) {
        int views = int.tryParse(statistics['viewCount'].toString()) ?? 0;
        if (views > 1000000) {
          viewCount = '${(views / 1000000).toStringAsFixed(1)}M views';
        } else if (views > 1000) {
          viewCount = '${(views / 1000).toStringAsFixed(1)}K views';
        } else if (views < 1000) {
          viewCount = '${(views)} views';
        }
      }

      String durationStr = '0:00';
      if (contentDetails['duration'] != null) {
        final duration = contentDetails['duration'].toString();
        final regexp = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
        final match = regexp.firstMatch(duration);

        if (match != null) {
          final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
          final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
          final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

          if (hours > 0) {
            durationStr =
                '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          } else {
            durationStr =
                '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
          }
        }
      }

      String liveBroadcastContent = snippet['liveBroadcastContent'] ?? '';
      bool isLiveVideo = false;
      if (liveBroadcastContent.isNotEmpty) {
        if (liveBroadcastContent == 'live') {
          isLiveVideo = true;
        }
      }

      return VideoModel(
        id: videoId,
        title: snippet['title'],
        thumbnaiUrl:
            snippet['thumbnails']?['high']?['url'] ??
            snippet['thumbnails']?['default']?['url'] ??
            '',
        channelTitle: snippet['channelTitle'],
        viewCount: viewCount,
        publishedTime: await getTimeAgo(snippet['publishedAt']) ?? '',
        channelAvatarUrl:
            'https://picsum.photos/seed/${snippet['channelId']}/200/200',
        duration: durationStr,
        channeld: snippet['channelId'] ?? '',
        description: snippet['description'] ?? '',
        isLive: isLiveVideo,
      );
    });
  }

  static Future<String?> getTimeAgo(String publishedAt) async {
    return await Helper.handleRequest<String>(() async {
      if (publishedAt.isEmpty) return '';

      final DateTime published = DateTime.parse(publishedAt);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(published);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} years ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} months ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inSeconds > 30) {
        return '${difference.inSeconds} just now';
      }
      return '';
    });
  }
}
