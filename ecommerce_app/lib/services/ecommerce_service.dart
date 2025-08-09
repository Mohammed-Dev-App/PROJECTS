import 'dart:convert';

import 'package:http/http.dart' as http;

class EcommerceService {
  final String _Base_URL = "https://fakestoreapi.com";
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("${_Base_URL}/products"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Faild to Load");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse("${_Base_URL}/users"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Faild to Load");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
