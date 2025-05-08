import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'username';
  static const String _userRoleKey = 'role';

  static Future<void> saveUserInfo(String userId, String username, String role) async {
    try {
      print('Saving user info to storage - ID: $userId, Username: $username, Role: $role');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userId);
      await prefs.setString(_userNameKey, username);
      await prefs.setString(_userRoleKey, role);

      // Verify the data was saved
      final savedId = prefs.getString(_userIdKey);
      final savedUsername = prefs.getString(_userNameKey);
      final savedRole = prefs.getString(_userRoleKey);
      print('Verifying saved user info - ID: $savedId, Username: $savedUsername, Role: $savedRole');
    } catch (e) {
      print('Error saving user info: $e');
    }
  }

  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_userIdKey);
      print('Retrieved User ID: $id');
      return id;
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  static Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString(_userNameKey);
      print('Retrieved Username: $username');
      return username;
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString(_userRoleKey);
      print('Retrieved User Role: $role');
      return role;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  static Future<void> clearUserInfo() async {
    try {
      print('Clearing user info from storage');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_userRoleKey);
      print('User info cleared');
    } catch (e) {
      print('Error clearing user info: $e');
    }
  }
}
