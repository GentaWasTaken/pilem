import 'dart:convert';

import 'package:http/http.dart' as http;
class ApiServices {
  static const String baseUrl = "https://api.themoviedb.org/3",
                      apiKey = "d950d1ce9bdadcaa1eac8cb987de02c0";
  static final ApiServices _instance = ApiServices._internal();

  factory ApiServices() => _instance;

  ApiServices._internal();


  Future<List<Map<String, dynamic>>> getAllMovie() async {
    final res = await this.get("/movie/now_playing?api_key=$apiKey");
    final data = jsonDecode(res!.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
  Future<List<Map<String, dynamic>>> getTrendingMovie() async {
    final res = await this.get("/movie/week?api_key=$apiKey");
    final data = jsonDecode(res!.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
  Future<List<Map<String, dynamic>>> getPopularMovie() async {
    final res = await this.get("/movie/popular?api_key=$apiKey");
    final data = jsonDecode(res!.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
  Future<List<Map<String, dynamic>>> searchMovie(String _query) async {
    final res = await this.get("/search/movie?query=$_query&api_key=$apiKey");
    final data = jsonDecode(res!.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<http.Response?> get(String m_url) async {
    var url = Uri.parse("$baseUrl$m_url");
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      ).timeout(const Duration(seconds: 10));
      print(" RES: ${response.body} CODE: ${response.statusCode }");
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }
  Future<http.Response?> patch(String m_url, Map<String, String>body) async {
    var url = Uri.parse("$baseUrl$m_url");
    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }
  Future<http.Response?> post(String m_url, Map<String, String>body) async {
    var url = Uri.parse("$baseUrl$m_url");
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }
}