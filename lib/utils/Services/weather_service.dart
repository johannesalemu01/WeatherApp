import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String apiKey1 = "32eeca170b1989347e13b387f56a7ce7";
  final String apiKey = "3049f4e988704063ae7104603251202";
  late final Box weatherBox;

  WeatherService() {
    _openBox().then((_) {});
  }

  Future<void> _openBox() async {
    weatherBox = await Hive.openBox('weatherCache');
  }

  Future<Map<String, dynamic>> fetchWeatherByLocation(
      double lat, double lon) async {
    final String url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon";

    try {
      Response response = await _dio.get(url);
      weatherBox.put('weatherData', response.data);
      return response.data;
    } catch (e) {
      if (weatherBox.containsKey('weatherData')) {
        return weatherBox.get('weatherData');
      }
      throw Exception("Failed to load weather data");
    }
  }

  Future<Map<String, dynamic>> fetchWeatherByCity(String city) async {
    final String url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city";

    try {
      Response response = await _dio.get(url);
      weatherBox.put('weatherData', response.data);
      return response.data;
    } catch (e) {
      if (weatherBox.containsKey('weatherData')) {
        return weatherBox.get('weatherData');
      }
      throw Exception("Failed to load weather data");
    }
  }

  Future<Map<String, dynamic>> fetch7DayForecast(double lat, double lon) async {
    final String url =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=7";

    debugPrint("Fetching Weather: $url");

    try {
      Response response = await _dio.get(url);
      debugPrint("API Response: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Failed to load forecast data: $e");
      throw Exception("Failed to load forecast data");
    }
  }

  Future<Map<String, dynamic>> fetch7DayForecastByCity(String city) async {
    final String url =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7";

    try {
      Response response = await _dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint("Failed to get forecast for $city: $e");
      return {};
    }
  }
}
