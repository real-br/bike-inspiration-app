// bike_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:bike_inspiration_app/widgets/bike_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bike_component_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class BikeFeedScreen extends StatefulWidget {
  @override
  _BikeFeedScreenState createState() => _BikeFeedScreenState();
}

class _BikeFeedScreenState extends State<BikeFeedScreen> {
  List<dynamic> _info = [];
  bool _isLoading = true;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  Future<void> _fetchInfo() async {
    try {
      final fetchedInfo = await BikeService.fetchBikeInfo();
      setState(() {
        _info = fetchedInfo;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching bike info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load info')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BikeComponentScreen(
              imagePath: _image!.path,
            ),
          ),
        );
      }
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _info.isEmpty
              ? Center(child: Text('No bikes available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _info.length,
                  itemBuilder: (context, index) {
                    return BikeCard(bikeInfo: _info[index]);
                  },
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickImage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BikeService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<dynamic>> fetchBikeInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/bikesInfo/'),
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
