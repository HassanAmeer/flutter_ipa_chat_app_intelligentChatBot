import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ThemeVmC with ChangeNotifier {
//////////////////// manage all themes
  bool isDarkMode = false;
  ThemeData _themeData = ThemeData(
      primarySwatch: MaterialColors.blue,
      scaffoldBackgroundColor: const Color(0xffF6F9FF),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Color.fromARGB(255, 233, 238, 246)),
      iconTheme: IconThemeData(color: Colors.black));
  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = isDarkMode
        ?
        ///// light mode
        ThemeData(
            primarySwatch: MaterialColors.blue,
            scaffoldBackgroundColor: const Color(0xffF6F9FF),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            textTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.black),
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),
            inputDecorationTheme:
                // InputDecorationTheme(fillColor: const Color(0xffF4F6F9)),
                InputDecorationTheme(
                    fillColor: Color.fromARGB(255, 233, 238, 246)),
            iconTheme: IconThemeData(color: Colors.black))
        //// dark mode
        : ThemeData(
            primarySwatch: MaterialColors.blue,
            scaffoldBackgroundColor: const Color.fromARGB(255, 28, 36, 40),
            textTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
            ),
            listTileTheme: ListTileThemeData(iconColor: Colors.white),
            dialogBackgroundColor: Colors.blueGrey.shade400,
            dividerColor: Colors.grey[800],
            iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                    iconColor: MaterialStateProperty.all(Colors.white))),
            iconTheme: IconThemeData(color: Colors.white),
            inputDecorationTheme:
                InputDecorationTheme(fillColor: Colors.blueGrey.shade900),
            appBarTheme:
                AppBarTheme(backgroundColor: Colors.blueGrey.shade900));
    // debugPrint(' 🎨 after dark theme');
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
