import 'package:flutter/material.dart';
import 'package:youtube_app/screens/search_page.dart';

class YoutubeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const YoutubeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: Image.asset("assest/images/logo.png"),
      title: Row(
        children: [
          Text(
            "M",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "tube",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return PageNotFound();
            //     },
            //   ),
            // );
          },
          icon: Icon(Icons.cast, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return PageNotFound();
            //     },
            //   ),
            // );
          },
          icon: Icon(Icons.notifications_outlined, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SearchPage();
                },
              ),
            );
          },
          icon: Icon(Icons.search, color: Colors.white),
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.menu, color: Colors.white),
        // ),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey,
          child: Text("A", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
