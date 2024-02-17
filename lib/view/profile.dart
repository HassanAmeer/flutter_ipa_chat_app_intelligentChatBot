import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../services/storage.dart';
import '../services/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String storageProfilePath = '';
  String imagePath = '';

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

// Function to initialize user information
  void initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Set initial values for name and email in text fields
    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }
    storageProfilePath = await StorageC.getProfileImagePathF() ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeVmC>(builder: (context, vmVal, child) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: Text('Profile',
                style: TextStyle(
                    color: vmVal.isDarkMode ? Colors.white : Colors.black))),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            updateProfile(nameController.text, emailController.text);
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
                    'Update',
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
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  final img = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    imagePath = img.path;
                    setState(() {});
                    await StorageC.setProfileImagePathF(img.path);
                    initializeUser();
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        radius: 52,
                        child: imagePath.isNotEmpty
                            ? Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                width:
                                    MediaQuery.of(context).size.width * 0.3 / 1,
                              )
                            : storageProfilePath.isNotEmpty
                                ? Image.file(
                                    File(storageProfilePath),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width *
                                        0.3 /
                                        1,
                                  )
                                : Image.asset(
                                    'assets/profile2.png',
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: vmVal.isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade100,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    filled: true,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    filled: true,
                    hintText: 'example@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
            ],
          ),
        )),
      );
    });
  }

  // Future<void> updateProfile(String newName, String newEmail) async {
  //   try {
  //     // Get the current user
  //     User? user = FirebaseAuth.instance.currentUser;

  //     // Update the user's display name and email address
  //     await user?.updateDisplayName(newName);
  //     await user?.updateEmail(newEmail);

  //     // Reload the user to get the updated information
  //     await user?.reload();

  //     // Verify if the name and email have been updated
  //     user = FirebaseAuth.instance.currentUser;
  //     print("Name updated to: ${user?.displayName}");
  //     print("Email updated to: ${user?.email}");
  //   } catch (error) {
  //     print("Error updating profile: $error");
  //     // Handle errors here
  //   }
  // }
  Future<void> updateProfile(String newName, String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      await user?.updateDisplayName(newName);
      await user?.updateEmail(newEmail);
      await user?.sendEmailVerification();
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;
      // print("Name updated to: ${user?.displayName}");
      // print("Email updated to: ${user?.email}");
      // print(
      //     "Verification email sent. Please check your email to verify the new address.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Verification email sent. If Alread Verify Then Profile Is Autometicaly Updated.'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        ),
      );
    } catch (error) {
      // print("Error updating profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wait For Verification email.'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        ),
      );
    }
  }
}
