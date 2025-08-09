import 'package:chat_app/controler/signup_controller.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userForm = GlobalKey<FormState>();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController Country = TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: SingleChildScrollView(
        child: Form(
          key: userForm,
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/images/logo.png"),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: Email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                  },
                  decoration: InputDecoration(label: Text("Email")),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: Name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                  },
                  decoration: InputDecoration(label: Text("Name")),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: Country,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Country is required";
                    }
                  },
                  decoration: InputDecoration(label: Text("Country")),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0, 50),
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (userForm.currentState!.validate()) {
                            isloading = true;
                            setState(() {});
                            await SignupController.createAccount(
                              context: context,
                              Email: Email.text,
                              Password: Password.text,
                              Name: Name.text,
                              Country: Country.text,
                            );
                            isloading = false;
                          }
                        },
                        child:
                            isloading
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : Text("Create account"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
