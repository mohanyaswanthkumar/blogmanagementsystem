import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/blog.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://127.0.0.1/blogapp';

  // Login
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Login successful (assumes API returns a success flag or token)
        return true;
      }
    } catch (e) {
      print('Error during login: $e');
    }

    // Login failed
    return false;
  }

  // Signup
  static Future<Map<String, dynamic>?> signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      body: json.encode({'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token'); // Clear the JWT token
  }

  // Fetch all blogs
  static Future<List<Blog>> fetchBlogs() async {
    final response = await http.get(Uri.parse('$_baseUrl/blogs'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Blog.fromJson(item)).toList();
    }
    return [];
  }

  // Fetch blogs for the logged-in user
  static Future<List<Blog>> fetchMyBlogs() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/myblogs'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Blog.fromJson(item)).toList();
    }
    return [];
  }

  // Create a new blog
  static Future<bool> createBlog(String title, String content, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/myblogs'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['content'] = content;

    // Attach the image
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  // Update a blog
  static Future<bool> updateBlog(int blogId, String title, String content, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/myblogs/$blogId'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['content'] = content;

    // Attach the new image if provided
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Delete a blog
  static Future<bool> deleteBlog(int blogId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/myblogs/$blogId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return true;
    }
    return false;
  }

  // Fetch user profile
  static Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Retrieve token from SharedPreferences

      if (token == null) {
        throw Exception("No token found");
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode == 200) {
        // Decode and return the profile data
        return json.decode(response.body);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    return null; // Return null if an error occurs
  }
}
