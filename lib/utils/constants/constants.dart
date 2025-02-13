import 'package:flutter/material.dart';

class Constants {
  static const textStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black45,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );

  String getBackgroundImage(int condition) {
    if (condition < 10) {
      return 'assets/images/rainy.jpg';
    } else if (condition > 10 && condition < 25) {
      return 'assets/images/cloudy.jpg';
    } else {
      return 'assets/images/sunny.jpg';
    }
  }

  String getWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/images/sunny.json';
      case 'rain':
        return 'assets/images/rainy.json';
      case 'clouds':
        return 'assets/images/cloudy.json';
      default:
        return 'assets/images/other.json';
    }
  }
}
