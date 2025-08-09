import 'package:chat_master/services/cloud_storage_service.dart';
import 'package:chat_master/services/database_service.dart';
import 'package:chat_master/services/media_service.dart';
import 'package:chat_master/services/navigation_service.dart';
import 'package:chat_master/services/supa_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashScreen({super.key, required this.onInitializationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((_) {
      _setup().then((_) => widget.onInitializationComplete());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat",
      theme: ThemeData(scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1)),
      home: Scaffold(
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerService();
  }

  void _registerService() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
    GetIt.instance.registerSingleton<SupaStorageService>(SupaStorageService());
  }
}
