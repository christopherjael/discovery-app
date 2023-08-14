import 'package:flutter/material.dart';
import 'package:discoveryapp/widgets/splashar.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes Apps',
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              centerTitle: true,
              elevation: 0,
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0)),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
