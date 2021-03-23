//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalAdmin/constants/resources.dart';
import 'package:hospitalAdmin/globals/user_details.dart';
import 'package:hospitalAdmin/screens/login_screen.dart';
import 'package:hospitalAdmin/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToNext();
  }

  goToNext() {
    Future.delayed(Duration(seconds: 3)).whenComplete(() =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LogInScreen()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Image.asset(logoJPEG),
      ),
    );
  }
}
