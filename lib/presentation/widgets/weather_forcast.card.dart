
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/utils/constants/constants.dart';

class WeekForcastCard extends StatelessWidget {
  const WeekForcastCard({
    super.key,
    required this.day,
    required this.iconPath,
    required this.maxTemp,
    required this.minTemp,
  });

  final String day;
  final String iconPath;
  final String maxTemp;
  final String minTemp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          day,
          style: Constants.textStyle
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Lottie.asset(iconPath, width: 60, height: 60),
        Text(
          '$minTemp° ~ $maxTemp°',
          style: Constants.textStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        )
      ]),
    );
  }
}
