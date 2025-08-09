// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  ValueChanged<int>? onTap;
  int selected;
  BottomNavigationBarWidget({
    super.key,
    required this.onTap,
    required this.selected,
  });

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      currentIndex: widget.selected,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow_outlined),
          label: "Shorts",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, size: 40),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.subscript_outlined),
          label: "Subscription",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: "You",
        ),
      ],
      onTap: widget.onTap,
    );
  }
}
