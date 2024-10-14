import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String?>> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString('username');
  final token = prefs.getString('token');

  return {
    'userName': userName,
    'token': token,
  };
}
