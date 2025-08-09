import 'package:chat_app/providers/userprovider.dart';
import 'package:chat_app/screens/edit_profile_screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userprov = Provider.of<Userprovider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            CircleAvatar(
              child: Text(userprov.userName[0], style: TextStyle(fontSize: 45)),
              radius: 50,
            ),
            SizedBox(height: 8),
            Text(
              userprov.userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(userprov.userEmail),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditProfileScreen();
                    },
                  ),
                );
              },
              child: Text("Edit profile"),
            ),
          ],
        ),
      ),
    );
  }
}
