import 'package:discoveryapp/pages/login_or_register_page.dart';
import 'package:discoveryapp/pages/login_page.dart';
import 'package:discoveryapp/widgets/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Home();
            }else{
              return LoginOrRegisterPage();
            }
          }
        )
    );
  }
}
