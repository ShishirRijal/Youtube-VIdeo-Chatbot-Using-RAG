import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  // Index a YouTube video
  static Future<Map<String, dynamic>> indexYoutubeVideo(String videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/index-youtube'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'video_id': videoId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Failed to index video',
        );
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Query the RAG system
  static Future<String> queryRag(String question) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'] ?? 'No answer provided';
      } else {
        throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Failed to get answer',
        );
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Extract video ID from various YouTube URL formats
  static String extractVideoId(String input) {
    // Clean the input by trimming whitespace
    input = input.trim();

    // If it's already just an ID (11 characters), return it
    if (RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(input)) {
      return input;
    }

    // Try to extract from various YouTube URL formats
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(input);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    }
    // If no match found, return an empty string
    return '';
  }
}
