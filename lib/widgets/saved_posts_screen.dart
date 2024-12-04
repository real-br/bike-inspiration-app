// bike_feed_screen.dart
import 'package:bike_inspiration_app/widgets/saved_bike_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPostsScreen extends StatefulWidget {
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  List<dynamic> _info = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedPosts();
  }

  Future<void> _fetchSavedPosts() async {
    try {
      final fetchedInfo = await SavedPostsService.fetchSavedPosts();

      // Compare new data to avoid unnecessary rebuilds
      if (mounted) {
        setState(() {
          _info = fetchedInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching bike info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Ride Inspired", style: TextStyle(fontFamily: "BlippoBlack")),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _info.isEmpty
              ? Center(child: Text('No bikes available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _info.length,
                  itemBuilder: (context, index) {
                    print(_info[index]['id']?.toString());
                    return SavedBikeCard(
                      bikeInfo: _info[index],
                      onDelete: () async {
                        await _fetchSavedPosts(); // Refresh the posts after unsaving
                      },
                    );
                  },
                ),
    );
  }
}

class SavedPostsService {
  static const String baseUrl = 'https://newbikeday.ddns.net';

  static Future<List<dynamic>> fetchSavedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');

    final response = await http.get(
      Uri.parse('$baseUrl/savedPosts/$username'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bike info');
    }
  }
}
