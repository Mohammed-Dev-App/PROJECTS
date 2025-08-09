import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsSection extends StatelessWidget {
  final List<Map<String, dynamic>> comments;
  final bool isloading;
  final VoidCallback onCommentTap;
  final bool isCommentExpanded;
  final VoidCallback onClose;
  const CommentsSection({
    super.key,
    required this.comments,
    required this.isloading,
    required this.onCommentTap,
    required this.isCommentExpanded,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (isloading)
      return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    if (isCommentExpanded) {
      return buildExpandeComments();
    }
    return buildCollapsedComment();
  }

  Widget buildCollapsedComment() {
    if (comments.isEmpty) return SizedBox.shrink();
    return InkWell(
      onTap: onCommentTap,
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "comment ${comments.length}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white60),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                    comments.first['authProfileImage'] ??
                        'https://placeholder.com/150',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        comments.first['author'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        comments.first['text'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandeComments() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          buildHeader(),
          buildTaps(),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];

                return buildCommentItem(comment);
              },
            ),
          ),
          buildAddComment(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Text(
            "Comments ${comments.length}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildTaps() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [buildTap("Top", false), buildTap("Newest", false)],
        ),
      ),
    );
  }

  Widget buildTap(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white12 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildCommentItem(Map<String, dynamic> comment) {
    final DateTime publishedAt = DateTime.parse(comment['publishedAt']);
    final String timeAgo = timeago.format(publishedAt);

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              comment['authProfileImage'] ?? 'https://placeholder.com/150',
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['author'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  comment['text'] ?? '',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Colors.white60,
                    ),
                    SizedBox(width: 4),
                    Text(
                      (comment['likeCount'].toString()),
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.thumb_down_outlined,
                      size: 16,
                      color: Colors.white60,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddComment() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 16, child: Icon(Icons.person, size: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                "Add a comment...",
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
