import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY_";
  static String userNameKey = "USERNAMEKEY_";
  static String userEmailKey = "USEREMAILKEY_";
  static String userImageKey = "USERIMAGEKEY_";
  static String userPhoneKey = "USERPHONEKEY_";
  static String adminNameKey = "ADMINKEY";
  static String adminPassKey = "ADMINPASSKEY";
  static String AdminImageKey = "ADMINIMAGEKEY";

  String _getUserKey(String key, String userId) => "$key$userId";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_getUserKey(userNameKey, userId), getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        _getUserKey(userEmailKey, userId), getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        _getUserKey(userImageKey, userId), getUserImage);
  }

  Future<bool> saveUserPhone(String getUserPhone, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        _getUserKey(userPhoneKey, userId), getUserPhone);
  }

  Future<bool> saveAdminName(String getAdminName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminNameKey, getAdminName);
  }

  Future<bool> saveAdminPass(String getAdminPass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminPassKey, getAdminPass);
  }

  Future<bool> saveAdminImage(String getAdminImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(AdminImageKey, getAdminImage);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_getUserKey(userNameKey, userId));
  }

  Future<String?> getUserEmail(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_getUserKey(userEmailKey, userId));
  }

  Future<String?> getUserImage(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_getUserKey(userImageKey, userId));
  }

  Future<String?> getUserPhone(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_getUserKey(userPhoneKey, userId));
  }

  Future<String?> getAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminNameKey);
  }

  Future<String?> getAdminPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminPassKey);
  }

  Future<String?> getAdminImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AdminImageKey);
  }
}
