import 'package:chat_master/services/database_service.dart';
import 'package:chat_master/services/media_service.dart';
import 'package:chat_master/services/supa_storage_service.dart';
import 'package:chat_master/widget/rounded_image_network.dart';
import 'package:flutter/material.dart';
import 'package:chat_master/provider/authentication_provider.dart';

import 'package:chat_master/widget/custom_input_filed.dart';
import 'package:chat_master/widget/rounded_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;

  late SupaStorageService _supaStorageService;

  String? _name;
  String? _email;
  String? _password;
  String? defaultImage;

  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();

    _supaStorageService = GetIt.instance.get<SupaStorageService>();

    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            _profileImageField(),
            SizedBox(height: _deviceHight * 0.05),
            _registerForm(),
            SizedBox(height: _deviceHight * 0.05),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((_file) {
          _profileImage = _file;
          setState(() {
            print(_profileImage!.path);
          });
        });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            size: _deviceHight * 0.15,
            image: _profileImage!,
          );
        } else {
          setState(() {
            defaultImage =
                "https://gxdfwhxnufdqiedcjhhi.supabase.co/storage/v1/object/public/images/default/DefaultImage.jpg";
          });
          return RoundedImageNetwork(
            imagePath:
                "https://gxdfwhxnufdqiedcjhhi.supabase.co/storage/v1/object/public/images/default/DefaultImage.jpg",
            size: _deviceHight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputFiled(
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
              regEx: '',
              hintText: "Name",
              obscureText: false,
            ),
            CustomInputFiled(
              onSaved: (value) {
                _email = value;
                setState(() {});
              },
              hintText: 'Email',
              obscureText: false,
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ),
            CustomInputFiled(
              onSaved: (value) {
                _password = value;
                setState(() {});
              },
              hintText: 'Password',
              obscureText: true,
              regEx: r'.{8,}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      hight: _deviceHight * 0.065,
      width: _deviceWidth * 0.65,
      onPresses: () async {
        if (_registerFormKey.currentState!.validate() &&
            _profileImage != null) {
          _registerFormKey.currentState!.save();
          String? _uid = await _auth.registerUsingEmailAndPassword(
            _email!,
            _password!,
          );
          // String? _imageURL = await _cloudStorageService.saveUserImageToStorage(
          //   _uid!,
          //   _profileImage!,
          // );
          String? _imageURL = await _supaStorageService.saveUserImageToStorage(
            _uid!,
            _profileImage!,
          );
          await _db.createUser(_name!, _uid, _email!, _imageURL!);
          await _auth.logout();
          await _auth.loginUsingEmailAndPassword(_email!, _password!);
        } else if (_registerFormKey.currentState!.validate() &&
            _profileImage == null) {
          _registerFormKey.currentState!.save();
          String? _uid = await _auth.registerUsingEmailAndPassword(
            _email!,
            _password!,
          );

          await _db.createUser(_name!, _uid!, _email!, defaultImage!);
          await _auth.logout();
          await _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
      },
    );
  }
}
