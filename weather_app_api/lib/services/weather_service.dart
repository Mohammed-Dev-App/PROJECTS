import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  String api_key = ""; //WRITE YOUR_API_KEY

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$api_key&units=metric",
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Faild to load data");
    }
  }

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double lat = position.latitude, lon = position.longitude;
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$api_key&units=metric",
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Faild to load data");
    }
  }
}
