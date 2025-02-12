
import 'package:flutter/material.dart';
import 'package:weather/utils/constants/constants.dart';

class WeatherDetailCard extends StatelessWidget {
  const WeatherDetailCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(height: 8),
            Text(title, style: Constants.textStyle),
            SizedBox(height: 4),
            Text(value, style: Constants.textStyle),
          ],
        ),
      ),
    );
  }
}
