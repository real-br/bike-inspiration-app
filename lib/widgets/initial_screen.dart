import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final isValid = await _validateToken(token);

    if (isValid) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      await prefs.remove('token');
      Navigator.pushReplacementNamed(context, '/login');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _validateToken(String token) async {
    try {
      final url = Uri.parse('http://localhost:8000/auth/validate-token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['valid'];
      } else {
        return false;
      }
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : Container(),
      ),
    );
  }
}
