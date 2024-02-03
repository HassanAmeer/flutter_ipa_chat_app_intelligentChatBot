import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/theme.dart';

class ContactUsPage extends StatelessWidget {
  final String email = 'email@example.com';

  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us',
            style: TextStyle(
                color: context.watch<ThemeVmC>().isDarkMode
                    ? Colors.white
                    : Colors.black)),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          _launchEmailApp(email);
        },
        child: SizedBox(
          height: 100,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xff0C8CE9),
              ),
              child: const Center(
                child: Text(
                  'Contact via Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            const Text(
              'Welcome to our Chat Bot App! If you have any questions or feedback, feel free to contact us.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              email,
              style: TextStyle(
                  fontSize: 16,
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.yellowAccent
                      : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  _launchEmailApp(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Chat Bot App IPA'},
    );

    try {
      await launch(emailLaunchUri.toString());
    } catch (e) {
      // Handle exceptions, if any
      print('Error launching email: $e');
    }
  }
}
