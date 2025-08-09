import 'package:chat_master/models/chat_user.dart';
import 'package:chat_master/services/database_service.dart';
import 'package:chat_master/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    // _auth.signOut();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        print("User are Loggin");
        _databaseService.updateUserSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then((_snapshot) {
          Map<String, dynamic> _userData =
              _snapshot.data()! as Map<String, dynamic>;

          user = ChatUser.fromJSON({
            "uid": _user.uid.toString(),
            "name": _userData['name'],
            "email": _userData['email'],
            "image": _userData['image'],
            "lastActive": _userData['lastActive'],
          });

          _navigationService.removeAndNavigateToRoute('/home');
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }
  Future<void> loginUsingEmailAndPassword(
    String _email,
    String _password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException {
      print("Error logging user");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUsingEmailAndPassword(
    String _email,
    String _password,
  ) async {
    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return _credential.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {}
  }
}
