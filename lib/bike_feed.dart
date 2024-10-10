// bike_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:bike_inspiration_app/widgets/bike_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BikeFeedScreen extends StatefulWidget {
  @override
  _BikeFeedScreenState createState() => _BikeFeedScreenState();
}

class _BikeFeedScreenState extends State<BikeFeedScreen> {
  List<dynamic> _info = [];
  bool _isLoading = true;

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
                    return BikeCard(bikeInfo: _info[index]);
                  },
                ),
    );
  }
}

class BikeService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<dynamic>> fetchBikeInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/bikesInfo/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bike info');
    }
  }
}
