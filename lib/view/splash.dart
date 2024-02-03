import 'dart:async';

import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/view/mainWrapper.dart';
import 'package:chatapp/view/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    user == null ? const SignIn() : const MainWrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/Logo.png', width: 500, height: 500),
          const Text('Intelligence Personal Advisor'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04 / 1),
          const CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            backgroundColor: MaterialColors.blue,
          )
        ],
      ),
    );
  }
}
