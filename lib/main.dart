import 'package:AppSynergy_Chat_app/helper/authenticate.dart';
import 'package:AppSynergy_Chat_app/helper/helperMethods.dart';
import 'package:AppSynergy_Chat_app/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void initState() {
    super.initState();
    getLoginInfo();
  }

  getLoginInfo() async {
    await HelperMethods.getUserLoggedFromSharedPreference().then((value) {
      setState(() {
        isLoggedIn = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? ChatRoomScreen() : Authenticate(),
    );
  }
}
