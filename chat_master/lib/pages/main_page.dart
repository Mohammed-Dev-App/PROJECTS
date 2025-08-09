import 'package:flutter/material.dart';

import '../services/save_service.dart';

class MainPage extends StatelessWidget {
  final String image;
  const MainPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              //       SaveService().saveNetworkImageToGallery(image);
            },
            child: Icon(Icons.save_sharp, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.white.withOpacity(0.2),
      ),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        maxScale: 4,
        minScale: 0.5,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.network(image),
        ),
      ),
    );
  }
}
