import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_data.dart';

class WeatherService {
  static final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<WeatherData?> getWeatherData(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lng&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        return WeatherData(
          waterTemp: (data['main']['temp'] as num).toDouble(),
          airTemp: (data['main']['temp'] as num).toDouble(),
          windSpeed: (data['wind']['speed'] as num).toDouble(),
          windDirection: _getWindDirection(data['wind']['deg']),
          waveHeight: 1.0, // Placeholder - would need marine API
          barometricPressure: (data['main']['pressure'] as num).toDouble(),
          pressureTrend: 'stable', // Would need historical data
        );
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
    return null;
  }

  static Future<TidalInfo?> getTidalInfo(double lat, double lng) async {
    // This is a placeholder - you'd need to implement WorldTides API
    // For now, returning mock data
    return TidalInfo(
      nextHighTide: '14:30',
      nextLowTide: '20:45',
      tidalRange: 2.1,
    );
  }

  static String _getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[(degrees / 45).round() % 8];
  }
}