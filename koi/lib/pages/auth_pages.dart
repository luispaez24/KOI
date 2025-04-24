import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koi/pages/home_page.dart';
import 'package:koi/pages/login.dart';
import 'package:koi/pages/login_or_register_page.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // asking if the user is logined in 

        if (snapshot.hasData) {
          return HomePage();
        }

          // is the user not logined in 

        else {
          return LoginOrRegisterPage();

        }
        },
      ),
    );
  }
}