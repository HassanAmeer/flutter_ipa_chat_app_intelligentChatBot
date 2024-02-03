import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/model/ChatModel.dart';
import 'package:chatapp/view/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/scheduler.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'services/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatModelAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create an instance of the ThemeController
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<ThemeVmC>(create: (_) => ThemeVmC())],
      child: Consumer<ThemeVmC>(builder: (context, vmVal, child) {
        return MaterialApp(
          title: 'IPA',
          debugShowCheckedModeBanner: false,
          theme: vmVal.themeData,
          themeMode: vmVal.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      }),
    );
  }
}

// class My-basic-Priority{
// (build-${[perfect][professional]}).mobile-app-with-stunning-UI}

  

