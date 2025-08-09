import 'package:flutter/material.dart';
import 'package:fun_fact/provider/provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    final ThemeModel = Provider.of<ThemeProvider>(context);
    isCheck = ThemeModel.isDarkModeChecked;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("App Theme Mode", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Switch(
                value: isCheck,
                onChanged: (value) {
                  isCheck = value;
                  // ThemeProvider().isDarkModeChecked = isCheck;
                  ThemeModel.updateMode(value);
                  Navigator.pop(context);

                  setState(() {});
                },
              ),

              SizedBox(width: 20),
              Text(isCheck ? "Dark Mode" : "Light Mode"),
            ],
          ),
        ],
      ),
    );
  }
}
