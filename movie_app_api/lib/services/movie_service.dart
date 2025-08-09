import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const Map<String, String> _headers = {
    'Authorization': "Bearer YOUR_TOKEN",
    'accept': 'application/json',
  };

  Future<List<dynamic>> _fetchMovies(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json is Map<String, dynamic> && json.containsKey('results')) {
          return json['results'] as List;
        } else {
          throw FormatException('Invalid JSON format');
        }
      } else {
        throw HttpException('Failed to load data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception("No Internet connection");
    } on FormatException catch (e) {
      throw Exception("Data format error: ${e.message}");
    } on HttpException catch (e) {
      throw Exception("HTTP error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<List<dynamic>> popularMovies(int page) async {
    return await _fetchMovies('/movie/popular?language=en-US&page=$page');
  }

  Future<List<dynamic>> topRatedMovies(int page) async {
    return await _fetchMovies('/movie/top_rated?language=en-US&page=$page');
  }

  Future<List<dynamic>> upcomingMovies(int page) async {
    return await _fetchMovies('/movie/upcoming?language=en-US&page=$page');
  }

  Future<List<dynamic>> similarMovies(int movieId, int page) async {
    return await _fetchMovies(
      '/movie/$movieId/similar?language=en-US&page=$page',
    );
  }
}
