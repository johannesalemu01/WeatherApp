import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/utils/Services/location_service.dart';
import 'package:weather/utils/Services/weather_service.dart';

final locationProvider = FutureProvider<Position>((ref) async {
  return await LocationService.getCurrentLocation();
});

final selectedCityProvider = StateProvider<String>((ref) => 'Bahir dar');

final weatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);

  if (selectedCity.isEmpty) {
    final location = await ref.watch(locationProvider.future);
    return await WeatherService()
        .fetchWeatherByLocation(location.latitude, location.longitude);
  } else {
    return await WeatherService().fetchWeatherByCity(selectedCity);
  }
});

final forecastProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);

  if (selectedCity.isEmpty) {
    final location = await ref.watch(locationProvider.future);
    final forecastData = await WeatherService()
        .fetch7DayForecast(location.latitude, location.longitude);

    return forecastData.containsKey('forecast') ? forecastData['forecast'] : {};
  } else {
    final forecastData =
        await WeatherService().fetch7DayForecastByCity(selectedCity);
    return forecastData.containsKey('forecast') ? forecastData['forecast'] : {};
  }
});

final geolocationWeatherProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final location = await ref.watch(locationProvider.future);
  return await WeatherService()
      .fetchWeatherByLocation(location.latitude, location.longitude);
});

final geolocationForecastProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final location = await ref.watch(locationProvider.future);
  final forecastData = await WeatherService()
      .fetch7DayForecast(location.latitude, location.longitude);

  return forecastData.containsKey('forecast') ? forecastData['forecast'] : {};
});
