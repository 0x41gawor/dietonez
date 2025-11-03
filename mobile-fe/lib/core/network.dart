import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://192.46.236.119:8080/api/v1';

  Future<T> getJson<T>(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final res = await http.get(uri);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as T;
    }
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }

  Future<void> send(
      String path, {
        required String method,
        Map<String, String>? query,
        Map<String, dynamic>? body,
      }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);

    final res = await http.Request(method, uri)
      ..headers['Content-Type'] = 'application/json'
      ..body = body != null ? jsonEncode(body) : '';

    final streamed = await res.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
