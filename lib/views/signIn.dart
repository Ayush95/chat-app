import 'package:AppSynergy_Chat_app/helper/helperMethods.dart';
import 'package:AppSynergy_Chat_app/services/auth.dart';
import 'package:AppSynergy_Chat_app/services/database.dart';
import 'package:AppSynergy_Chat_app/views/chatRoomScreen.dart';
import 'package:AppSynergy_Chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  QuerySnapshot snapshot;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  signIn() {
    if (formKey.currentState.validate()) {
      HelperMethods.saveUserEmailSharedPreference(_emailController.text);
      setState(() {
        _isLoading = true;
      });

      databaseMethods.getUserbyEmail(_emailController.text).then((value) {
        snapshot = value;
        HelperMethods.saveUserNameSharedPreference(
            snapshot.docs[0].data()['name']);
      });

      authMethods
          .signInwithEmailandPassword(
            _emailController.text,
            _passwordController.text,
          )
          .then(
            (value) => {
              HelperMethods.saveUserLoggedInSharedPreference(true),
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(),
                ),
              ),
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context).size.height - 50,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: _emailController,
                        style: simpleTextFieldColor(),
                        decoration: textInputDecoration(
                          'email',
                        ),
                        validator: (val) {
                          return RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+")
                                  .hasMatch(val)
                              ? null
                              : 'Please provide a valid email';
                        },
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      style: simpleTextFieldColor(),
                      decoration: textInputDecoration(
                        'password',
                      ),
                      obscureText: true,
                      validator: (val) {
                        return val.length < 6
                            ? 'Password should be greater than 6 characters'
                            : null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: simpleTextFieldColor(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Sign In with Facebook',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: simpleTextFieldColor(),
                        ),
                        GestureDetector(
                          onTap: () => widget.toggle(),
                          child: Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }
}
