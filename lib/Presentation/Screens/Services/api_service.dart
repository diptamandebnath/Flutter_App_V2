import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://c8df24a254ea.ngrok-free.app'; // Update this

  static Future<void> logActivity(String userId, String serviceName) async {
    final url = Uri.parse('$baseUrl/activity');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'service': serviceName,
      }),
    );
    if (response.statusCode != 200) {
      print('Failed to log activity: ${response.body}');
    }
  }

  static Future<List<String>> getRecommendations(String userId) async {
    final url = Uri.parse('$baseUrl/recommend/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<String>.from(json['recommended']);
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
