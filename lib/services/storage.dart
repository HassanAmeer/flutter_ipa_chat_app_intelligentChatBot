import 'package:shared_preferences/shared_preferences.dart';

class StorageC {
  static setProfileImagePathF(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImagePath', imagePath);
  }

  static getProfileImagePathF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImagePath');
  }
}
