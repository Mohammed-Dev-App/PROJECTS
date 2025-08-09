import 'package:chat_app/controler/login_controler.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userForm = GlobalKey<FormState>();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(title: Text("Login ")),
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("assets/images/logo.png"),
              ),
              TextFormField(
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: Email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                },
                decoration: InputDecoration(label: Text("Email")),
              ),
              SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: Password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                },
                decoration: InputDecoration(label: Text("Password")),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (userForm.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          await LoginControler.login(
                            context: context,
                            Email: Email.text,
                            Password: Password.text,
                          );
                          setState(() {});
                          isLoading = false;
                        }
                      },
                      child:
                          isLoading
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text("Login"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignupScreen();
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text("Dont have an account"),
                    SizedBox(width: 10),
                    Text(
                      "Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
