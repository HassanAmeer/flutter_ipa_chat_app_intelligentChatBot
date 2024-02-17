import 'package:chatapp/services/logout.dart';
import 'package:chatapp/view/privacypolicy.dart';
// import 'package:chatapp/view/signIn.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme.dart';
import 'contactus.dart';
import 'profile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeVmC>(builder: (context, vmVal, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
                color: vmVal.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 26.0, bottom: 16),
              child: Text('GENERAL',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: vmVal.isDarkMode
                      ? Colors.blueGrey.shade800
                      : Colors.white,
                ),
                child: Column(
                  children: [
                    buildProfileListTile(context, vmVal),
                    const SizedBox(height: 1, child: Divider()),
                    buildDarkModeListTile(context, vmVal),
                    const SizedBox(height: 1, child: Divider()),
                    buildPrivacyPolicyListTile(context, vmVal),
                    const SizedBox(height: 1, child: Divider()),
                    buildContactUsListTile(context, vmVal),
                    const SizedBox(height: 1, child: Divider()),
                    buildSignOutListTile(context, vmVal),
                    const SizedBox(height: 1, child: Divider()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  ListTile buildProfileListTile(BuildContext context, vmVal) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      },
      leading: Image.asset(
        'assets/4th Button.png',
        width: 25,
        height: 25,
      ),
      title: Text(
        'Profile',
        style: TextStyle(
          color: vmVal.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }

  ListTile buildDarkModeListTile(BuildContext context, vmVal) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Image.asset(
        'assets/Light Bulb.png',
        width: 25,
        height: 25,
      ),
      title: Text(
        'Dark Mode',
        style: TextStyle(
          color: vmVal.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: CupertinoSwitch(
        value: vmVal.isDarkMode,
        onChanged: (value) {
          vmVal.toggleTheme();
        },
      ),
    );
  }

  ListTile buildPrivacyPolicyListTile(BuildContext context, vmVal) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrivacyPolicy(),
          ),
        );
      },
      leading: Image.asset(
        'assets/Info Square.png',
        width: 25,
        height: 25,
      ),
      title: Text(
        'Privacy Policy',
        style: TextStyle(
          color: vmVal.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }

  ListTile buildContactUsListTile(BuildContext context, vmVal) {
    return ListTile(
      contentPadding:
          const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ContactUsPage(),
          ),
        );
      },
      leading: Image.asset(
        'assets/Chat Dots.png',
        width: 25,
        height: 25,
      ),
      title: Text(
        'Contact us',
        style: TextStyle(
          color: vmVal.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }

  ListTile buildSignOutListTile(BuildContext context, vmVal) {
    return ListTile(
      contentPadding:
          const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
      onTap: () {
        Logout().signout(context);
      },
      leading: const Icon(
        Icons.logout,
        size: 22,
      ),
      title: Text(
        'Sign Out',
        style: TextStyle(
          color: vmVal.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }
}
