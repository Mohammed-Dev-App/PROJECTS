import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupaStorageService {
  SupaStorageService() {}

  final client = SupabaseClient(
    'https://gxdfwhxnufdqiedcjhhi.supabase.co',
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4ZGZ3aHhudWZkcWllZGNqaGhpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTQ0NDA5NiwiZXhwIjoyMDY3MDIwMDk2fQ.VTZWWV96x__KX_KRPitXIKzx01tFJZkMIpE4M6052HQ",
  );
  Future<String?> saveUserImageToStorage(
    String _uid,
    PlatformFile _file,
  ) async {
    try {
      final storagePath = 'images/users/$_uid';

      print("Image Name ${_file.name}");

      final filePath = File(_file.path!);
      await client.storage
          .from(storagePath)
          .upload("profile.${_file.extension}", filePath);

      final publicUrl = client.storage.from('images').getPublicUrl(storagePath);
      print("true");

      return publicUrl;
    } catch (e) {
      print(' Error uploading image: $e');
      return null;
    }
  }

  Future<String?> saveChatImageToStorage(
    String _chatId,
    String _userID,
    PlatformFile _file,
  ) async {
    try {
      final filePath = File(_file.path!);
      final fileName =
          "${Timestamp.now().microsecondsSinceEpoch}.${_file.extension}";
      final storagePath = 'chats/$_chatId/$_userID/$fileName';

      await client.storage.from('images').upload(storagePath, filePath);

      final publicUrl = client.storage.from('images').getPublicUrl(storagePath);
      print("Image uploaded. URL: $publicUrl");

      return publicUrl;
    } catch (e) {
      print('Error uploading chat image: $e');
      return null;
    }
  }
}
