import 'package:AppSynergy_Chat_app/views/signIn.dart';
import 'package:AppSynergy_Chat_app/views/signUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignInScreen = true;

  void toggleScreen() {
    setState(() {
      showSignInScreen = !showSignInScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignInScreen ? SignIn(toggleScreen) : SignUp(toggleScreen);
  }
}
