import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskapp/view/splashScreenView.dart';

class SignInView extends StatelessWidget {

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      getDataFromLocalAndSync();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: RaisedButton(
          child: Text('Sign in Anonymously'),
          onPressed: _signInAnonymously,
        ),
      ),
    );
  }
}