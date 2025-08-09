// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:image_gallery_saver/image_gallery_saver.dart';

// class SaveService {
//   Future<void> saveNetworkImageToGallery(String imageUrl) async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       final result = await ImageGallerySaver.saveImage(
//         Uint8List.fromList(response.bodyBytes),
//         quality: 80,
//         name: "chat_image_${DateTime.now().millisecondsSinceEpoch}",
//       );
//       print("Saved to gallery: $result");
//     } catch (e) {
//       print(e);
//       print("Error in saved image");
//     }
//   }
// }
