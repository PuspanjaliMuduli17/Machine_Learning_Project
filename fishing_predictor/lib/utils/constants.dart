import 'package:flutter/material.dart';

class AppConstants {
  // API Endpoints
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';
  
  // Colors
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentColor = Color(0xFF00BCD4);
  
  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
  );
  
  // Sizes
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );
  
  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: darkBlue,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );
  
  // Fishing Score Colors
  static Color getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    if (score >= 4) return Colors.yellow[700]!;
    return Colors.red;
  }
  
  // Moon Phases
  static const Map<String, String> moonPhaseEmojis = {
    'new_moon': '🌑',
    'waxing_crescent': '🌒',
    'first_quarter': '🌓',
    'waxing_gibbous': '🌔',
    'full_moon': '🌕',
    'waning_gibbous': '🌖',
    'last_quarter': '🌗',
    'waning_crescent': '🌘',
  };
  
  // Popular Indian Fishing Locations
  static const List<Map<String, dynamic>> popularLocations = [
    {'name': 'Mumbai Coast', 'lat': 19.0760, 'lng': 72.8777},
    {'name': 'Goa Beaches', 'lat': 15.2993, 'lng': 74.1240},
    {'name': 'Kerala Backwaters', 'lat': 9.4981, 'lng': 76.3388},
    {'name': 'Chennai Marina', 'lat': 13.0827, 'lng': 80.2707},
    {'name': 'Vizag Coast', 'lat': 17.6868, 'lng': 83.2185},
  ];
}

class AppStrings {
  static const String appName = 'Fishing Hotspot Predictor';
  static const String findBestSpots = 'Find the Best Fishing Spots';
  static const String aiPoweredPredictions = 'Get AI-powered predictions based on weather, tides, and marine conditions';
  static const String useCurrentLocation = 'Use Current Location';
  static const String chooseOnMap = 'Choose Location on Map';
  static const String gettingLocation = 'Getting Location...';
  static const String locationError = 'Unable to get current location. Please enable location services.';
  static const String weatherError = 'Unable to fetch weather data. Please try again.';
  static const String predictionError = 'Unable to get fishing predictions. Please try again.';
  static const String noInternetError = 'No internet connection. Please check your network.';
}