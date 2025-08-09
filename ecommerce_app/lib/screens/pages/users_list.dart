import 'package:ecommerce_app/screens/widget/custom_appbar.dart';
import 'package:ecommerce_app/screens/widget/user_card.dart';
import 'package:ecommerce_app/screens/widget/user_profile.dart';
import 'package:ecommerce_app/screens/widget/users_solid.dart';
import 'package:ecommerce_app/services/ecommerce_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<dynamic> users = [];
  bool isloading = true;
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  Future<void> fetchUsers() async {
    EcommerceService ecommerceService = EcommerceService();
    users = await ecommerceService.fetchUsers();

    setState(() {
      users;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Users List"),

      body:
          isloading
              ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.all(8),
                  children: List.generate(10, (index) => UsersSolid()),
                ),
              )
              : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: EdgeInsets.all(8),
                children: List.generate(users.length, (index) {
                  final user = users[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UserProfile(user: user);
                          },
                        ),
                      );
                    },
                    child: UserCard(user: user ?? []),
                  );
                }),
              ),
    );
  }
}
