import 'package:chat_master/provider/authentication_provider.dart';
import 'package:chat_master/services/navigation_service.dart';
import 'package:chat_master/widget/custom_input_filed.dart';
import 'package:chat_master/widget/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late NavigationService _navigationService;
  final loginKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return _buildUi();
  }

  Widget _buildUi() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHight * 0.02,
        ),
        height: _deviceHight * .98,
        width: _deviceWidth * .97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTile(),
            SizedBox(height: _deviceHight * 0.04),

            _logiForm(),
            SizedBox(height: _deviceHight * 0.05),
            _loginButton(),
            SizedBox(height: _deviceHight * 0.02),
            _registerAccountLinl(),
          ],
        ),
      ),
    );
  }

  Widget _pageTile() {
    return Container(
      height: _deviceHight * 0.10,
      child: Text(
        "Chat",
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _logiForm() {
    return Container(
      height: _deviceHight * 0.20,
      child: Form(
        key: loginKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomInputFiled(
                onSaved: (value) {
                  email = value;
                  setState(() {});
                },
                hintText: 'Email',
                obscureText: false,
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ),
            ),
            Expanded(
              child: CustomInputFiled(
                onSaved: (value) {
                  password = value;
                  setState(() {});
                },
                hintText: 'Password',
                obscureText: true,
                regEx: r".{8,}",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
      name: 'Login',
      hight: _deviceHight * 0.065,
      width: _deviceWidth * 0.65,
      onPresses: () {
        if (loginKey.currentState!.validate()) {
          loginKey.currentState!.save();
          print("ُEmail $email");
          print("Password $password");
          _auth.loginUsingEmailAndPassword(email!, password!);
        }
      },
    );
  }

  Widget _registerAccountLinl() {
    return GestureDetector(
      onTap: () {
        return _navigationService.navigateToRoute('/register');
      },
      child: Container(
        child: Text(
          "Don\'t have an account",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
