import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:typed_data';

Future<String> uploadImageToImgur(File image) async {
  final String clientId = 'ac8044a238fd44e';
  final Uri uploadUrl = Uri.parse('https://api.imgur.com/3/image');

  final File file = File(image.path);
  final bytes = await file.readAsBytes();
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
