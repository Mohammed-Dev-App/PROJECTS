import 'package:ecommerce_app/screens/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final dynamic user;
  const UserProfile({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Profile Page"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    '${user['name']['firstname'][0]}'
                    '${user['name']['lastname'][0]}',

                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  '${user['name']['firstname']}'
                  ' '
                  '${user['name']['lastname']}',

                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${user['email']}'
                  ' ',

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  user['username'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  user['phone'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  '${user['address']['number']} , ${user['address']['street']} , ${user['address']['city']} ,${user['address']['zipcode']}',

                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
