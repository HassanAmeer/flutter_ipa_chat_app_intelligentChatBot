import 'package:chatapp/services/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../view/signIn.dart';

class Logout {
  signout(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Are you sure you want to Signout?',
              style: TextStyle(
                  fontSize: 18,
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.white
                      : Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      color: context.watch<ThemeVmC>().isDarkMode
                          ? Colors.grey.shade200
                          : Colors.grey.withOpacity(0.8))),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Signout',
                style: TextStyle(
                    color: context.watch<ThemeVmC>().isDarkMode
                        ? Colors.yellowAccent
                        : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                      (route) => false);
                });
              },
            ),
          ],
        );
      },
    );
  }

  exit(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Are you sure you want to Exit?',
              style: TextStyle(
                  fontSize: 18,
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.white
                      : Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      color: context.watch<ThemeVmC>().isDarkMode
                          ? Colors.grey.shade200
                          : Colors.grey.withOpacity(0.8))),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Exit',
                style: TextStyle(
                    color: context.watch<ThemeVmC>().isDarkMode
                        ? Colors.yellowAccent
                        : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
