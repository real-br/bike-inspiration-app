import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> likePost(String postId, String userId, String token) async {
  final Map<String, dynamic> data = {
    "user_name": userId,
    "post_id": postId,
    "liked_at": DateTime.now().toString()
  };

  final String jsonData = json.encode(data);

  final response = await http.post(
    Uri.parse('https://newbikeday.ddns.net/likePost/'),
    headers: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json",
    },
    body: jsonData,
  );

  if (response.statusCode == 200) {
    return "Great";
  } else {
    throw Exception('Failed to load bike info');
  }
}

Future<String> unlikePost(String postId, String userId, String token) async {
  final Map<String, dynamic> data = {
    "user_name": userId,
    "post_id": postId,
    "liked_at": null,
  };

  final String jsonData = json.encode(data);

  final response = await http.post(
    Uri.parse('https://newbikeday.ddns.net/unlikePost/'),
    headers: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json",
    },
    body: jsonData,
  );

  if (response.statusCode == 200) {
    return "Great";
  } else {
    throw Exception('Failed to load bike info');
  }
}

Future<int> getNrLikes(String postId, String token) async {
  final response = await http.get(
    Uri.parse('https://newbikeday.ddns.net/likedPosts/$postId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body) ?? 0;
  } else {
    throw Exception('Failed to load bike info');
  }
}
