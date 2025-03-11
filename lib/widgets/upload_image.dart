import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> uploadImageToImgur(File image) async {
  // First check if image contains a bike
  bool hasBike = await containsBike(image);
  if (!hasBike) {
    throw Exception('No bike detected in the image');
  }

  final String clientId = 'ac8044a238fd44e';
  final Uri uploadUrl = Uri.parse('https://api.imgur.com/3/image');

  final bytes = await image.readAsBytes();
  String base64Image = base64Encode(bytes);

  // Upload the image to Imgur
  final response = await http.post(
    uploadUrl,
    headers: {
      'Authorization': 'Client-ID $clientId',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'image': base64Image,
    },
  );

  // Check the response
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData['data']['link'];
  } else {
    throw Exception('Failed to upload image to Imgur: ${response.body}');
  }
}

Future<bool> containsBike(File imageFile) async {
  try {
    // Convert image to base64
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Make request to your backend
    final response = await http.post(
      Uri.parse('https://newbikeday.ddns.net/detect-bike/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'image': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['has_bike'] ?? false;
    } else {
      print('Error from bike detection API: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error during bike detection: $e');
    return false;
  }
}
