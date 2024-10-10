import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // For JSON encoding
import 'bike_component_screen.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage(_image!);
      }
    });
  }

  // Function to upload the image
  Future<void> _uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('http://localhost:8000/upload/'));

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final imagePath = json.decode(responseBody.body)["filename"];
        final int imageId = json.decode(responseBody.body)["image_id"];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BikeComponentScreen(
              imagePath: imagePath,
              imageId: imageId,
            ),
          ),
        );
      } else {
        print('Upload failed with status code: ${response.statusCode}');
        _showErrorMessage('Image upload failed.');
      }
    } catch (e) {
      print('Error during upload: $e');
      _showErrorMessage('An error occurred during the image upload.');
    }
  }

  // Utility functions to display messages
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          iconSize: 140,
          icon: Icon(
            Icons.add,
            color: Colors.green,
          ),
          onPressed: _pickImage,
        ),
      ),
    );
  }
}
