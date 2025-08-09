import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final dynamic user;
  const UserCard({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?['name'] ?? {};
    final firstname = name['firstname'] ?? '';
    final lastname = name['lastname'] ?? '';
    final email = user?['email'] ?? '';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.deepPurple,
              child: Text(
                "${firstname.isNotEmpty ? firstname[0] : ''}"
                "${lastname.isNotEmpty ? lastname[0] : ''}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$firstname $lastname",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(email),
          ],
        ),
      ),
    );
  }
}
