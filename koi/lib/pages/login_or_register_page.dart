import 'package:flutter/material.dart';
import 'package:koi/pages/login.dart';
import 'package:koi/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //show login at first 
  bool showLoginPage = true;

  //toggle betwwen login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }



  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    }else{

    
    return RegisterPage(
      onTap: togglePages,

    );
      
    
  }
}
}