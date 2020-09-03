import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import './login/Login.dart';

void main() {
  runApp(MaterialApp(
      title: "Blog-data-science",
      home: SplashScreen(),
      theme: ThemeData(
          primaryColor: Colors.red,
          buttonColor: Colors.red,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.red)),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      color: Colors.red));
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Simple_splashscreen(
          context: context,
          splashscreenWidget: Splash(),
          gotoWidget: Login(),
          timerInSeconds: 2),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Bem Vindo a Data Science Corporation",
              style: TextStyle(color: Colors.white, fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
