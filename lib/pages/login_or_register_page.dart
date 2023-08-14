import 'package:discoveryapp/pages/login_page.dart';
import 'package:discoveryapp/pages/register_page.dart';
import 'package:flutter/material.dart';


class LoginOrRegisterPage extends StatefulWidget {
  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        onTap: togglePages,
      );
    }else{
      return RegisterPage(
          onTap: togglePages
      );
    }
  }
}
