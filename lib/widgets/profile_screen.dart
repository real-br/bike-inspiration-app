import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bike_inspiration_app/widgets/saved_bike_card.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _accountInfo = {};
  List<dynamic> _info = [];

  Future<void> _fetchUserProfile() async {
    try {
      final fetchedInfo = await UserService.fetchUserProfile();
      setState(() {
        _accountInfo = fetchedInfo;
        _info = fetchedInfo["created_posts"];
      });
    } catch (e) {
      print('Error fetching bike info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load info')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Widget _buildStaticField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value.isNotEmpty ? value : 'Not available',
            style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _deleteAccount() async {
    final username = _accountInfo['username'];
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('https://newbikeday.ddns.net/deleteAccount/$username'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) ?? 0;
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Ride Inspired", style: TextStyle(fontFamily: "BlippoBlack")),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaticField("Username", _accountInfo['username'] ?? ''),
            _buildStaticField("Email", _accountInfo['email'] ?? ''),
            _buildStaticField("First Name", _accountInfo['first_name'] ?? ''),
            _buildStaticField("Last Name", _accountInfo['last_name'] ?? ''),
          ],
        ),
      ),
    );
  }
}

class UserService {
  static const String baseUrl = 'https://newbikeday.ddns.net';

  static Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString("username");

    final response = await http.get(
      Uri.parse('$baseUrl/accountInfo/$username'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
