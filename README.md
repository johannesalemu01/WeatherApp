# Weather App 🌦️

A simple Flutter weather app that provides real-time weather updates based on the user's location. The app also allows users to search for weather conditions in different cities. and to access the the weather data based on their location.

## ✨ Features

🌍 Geolocation Support – detects the user’s location for weather updates.
🔍 Search Functionality – Users can search for weather in different cities.
📦 State Management – Uses Riverpod for efficient state management.
💾 Local Storage – Uses Hive for storing cached weather data.
🌐 Network Requests – Uses Dio for making API calls efficiently.
🖼️ Image Caching – Uses cached_network_image for optimized image loading.
🎭 Animations – Uses Lottie for smooth animations based on weather conditions.

## Permissions Required

When the app prompts for location access, grant permission to allow it to fetch weather data based on your current location.

The app uses Geolocator to fetch the device’s coordinates.

### How to Run the App Locally

1. Clone the repository
   git clone https://github.com/johannesalemu01/WeatherApp
   cd weather

   2.install dependecies
   on the terminal write flutter pub get

2. Run the app
   flutter run
