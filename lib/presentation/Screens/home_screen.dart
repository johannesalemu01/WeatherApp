import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/presentation/Providers/weather_provider.dart';
import 'package:weather/presentation/Screens/location_selection_screen.dart';
import 'package:weather/presentation/widgets/weather_detail_card.dart';
import 'package:weather/presentation/widgets/weather_forcast.card.dart';
import 'package:weather/utils/Services/location_service.dart';
import 'package:weather/utils/constants/constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    final forecastWeather = ref.watch(forecastProvider);
    String selectedCity = ref.watch(selectedCityProvider);

    void openLocationSelection() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationSelectionScreen()),
      );

      if (result != null) {
        ref.read(selectedCityProvider.notifier).state = result;
      }
    }

    void showLocationServiceDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Services Disabled"),
            content: Text("Please enable location services to proceed."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.of(context).pop();
                },
                child: Text("Enable"),
              ),
            ],
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rainy.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 2, 61, 88),
          centerTitle: true,
          title: GestureDetector(
            onTap: openLocationSelection,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(selectedCity,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                  onPressed: () async {
                    try {
                      bool serviceEnabled =
                          await Geolocator.isLocationServiceEnabled();

                      if (!serviceEnabled) {
                        showLocationServiceDialog();
                        return;
                      }

                      LocationPermission permission =
                          await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied) {
                          return;
                        }
                      }

                      if (permission == LocationPermission.deniedForever) {
                        return;
                      }

                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      String cityName =
                          await LocationService.getCityName(position);

                      ref.read(selectedCityProvider.notifier).state = cityName;
                    } catch (e) {
                      throw Center(
                          child: Text('error while accessing location'));
                    }
                  },
                  icon: Icon(
                    Icons.location_on,
                    size: 28,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: currentWeather.when(
          data: (weatherData) => forecastWeather.when(
            data: (forecastData) => WeatherDisplay(weatherData, forecastData),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stackTrace) {
              return Center(
                child: Text(
                  "Error: $err",
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}

class WeatherDisplay extends ConsumerStatefulWidget {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic> forecastData;

  const WeatherDisplay(this.weatherData, this.forecastData, {super.key});
  @override
  ConsumerState<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends ConsumerState<WeatherDisplay> {
  void openLocationSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationSelectionScreen()),
    );

    if (result != null) {
      ref.read(selectedCityProvider.notifier).state = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = widget.weatherData['current']['temp_c'].round();
    final precipitation = widget.weatherData['current']['precip_mm'].round();
    final windSpeed = widget.weatherData['current']['wind_kph'].round();
    final humidity = widget.weatherData['current']['humidity'];
    final pressure = widget.weatherData['current']['pressure_mb'];
    final visibility =
        widget.weatherData['current']['vis_km'].toStringAsFixed(1);
    final String condition = widget.weatherData['current']['condition']['text'];
    final currentDate = DateFormat('EEE, MMM d').format(DateTime.now());
    final currentTime = DateFormat('h:mm a').format(DateTime.now());
    final uv = widget.weatherData['current']['uv'].round();

    final String firstWord = condition.split(' ')[0];
    final String secondWord = condition.split(' ')[1];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Card(
              color: Colors.black.withOpacity(0.5),
              elevation: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(currentDate, style: Constants.textStyle),
                        Text(currentTime, style: Constants.textStyle),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("$temp°C",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 8),
                        Spacer(),
                        Text("precipitation: $precipitation ",
                            style: Constants.textStyle),
                      ],
                    ),
                    Column(
                      children: [
                        Lottie.asset(Constants().getWeatherAnimation(condition),
                            height: 70),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$firstWord \n $secondWord',
                          style: Constants.textStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  WeatherDetailCard(
                      title: "Humidity",
                      value: "$humidity%",
                      icon: Icons.water_drop),
                  WeatherDetailCard(
                      title: "Pressure",
                      value: "$pressure hPa",
                      icon: Icons.compress),
                  WeatherDetailCard(
                      title: "Visibility",
                      value: "$visibility km",
                      icon: Icons.remove_red_eye),
                  WeatherDetailCard(
                      title: "Wind Speed",
                      value: "$windSpeed m/s",
                      icon: Icons.wind_power),
                  WeatherDetailCard(
                      title: "UV", value: "$uv", icon: Icons.height),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.black.withOpacity(0.5),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("24-Hour Forecast",
                        style: Constants.textStyle.copyWith(fontSize: 18)),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: () {
                          var forecastDayData =
                              widget.forecastData['forecastday'] as List?;

                          if (forecastDayData == null ||
                              forecastDayData.isEmpty) {
                            return [
                              Center(child: Text('No forecast data available'))
                            ];
                          }

                          var hourlyData = forecastDayData[0]['hour'] as List?;

                          if (hourlyData == null || hourlyData.isEmpty) {
                            return [
                              Center(
                                  child: Text('No hourly forecast available'))
                            ];
                          }

                          var first24Hours = hourlyData.take(24).toList();

                          return first24Hours.map<Widget>((hourData) {
                            String time = DateFormat('h a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  hourData['time_epoch'] * 1000),
                            );
                            String temperature = "${hourData['temp_c']}°C";
                            String iconUrl =
                                "https:${hourData['condition']['icon']}";

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Column(
                                children: [
                                  Text(time,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 190, 188, 188))),
                                  CachedNetworkImage(
                                    imageUrl: iconUrl,
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(temperature,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 190, 188, 188))),
                                ],
                              ),
                            );
                          }).toList();
                        }(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Card(
                color: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Column(
                    children: () {
                      var forecastDayData =
                          widget.forecastData['forecastday'] as List?;

                      if (forecastDayData == null || forecastDayData.isEmpty) {
                        return [
                          Center(child: Text('No forecast data available'))
                        ];
                      }

                      return forecastDayData.map<Widget>((day) {
                        String days = DateFormat('EEEE').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                day['date_epoch'] * 1000));
                        String maxTemp = day['day']['maxtemp_c'].toString();
                        String minTemp = day['day']['mintemp_c'].toString();
                        String iconPath = Constants().getWeatherAnimation(
                            day['day']['condition']['text'].toLowerCase());

                        return WeekForcastCard(
                            day: days,
                            iconPath: iconPath,
                            maxTemp: maxTemp,
                            minTemp: minTemp);
                      }).toList();
                    }(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
