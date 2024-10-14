import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> savePost(String postId, String userId, String token) async {
  final Map<String, dynamic> data = {
    "user_name": userId,
    "post_id": postId,
    "saved_at": DateTime.now().toString()
  };

  final String jsonData = json.encode(data);

  final response = await http.post(
    Uri.parse('http://localhost:8000/savePost/'),
    headers: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json",
    },
    body: jsonData,
  );

  if (response.statusCode == 200) {
    final message = json.decode(response.body);
    return message;
  } else {
    throw Exception('Failed to load bike info');
  }
}

Future<String> unsavePost(String postId, String userId, String token) async {
  final Map<String, dynamic> data = {
    "user_id": userId,
    "post_id": postId,
    "saved_at": DateTime.now()
  };

  final response = await http.post(
    Uri.parse('http://localhost:8000/unsavePost/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: data,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load bike info');
  }
}

Future<String> getSavedPosts(String userId, String token) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/savedPosts/$userId'),
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
