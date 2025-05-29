import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  final double waterTemp;
  final double airTemp;
  final double windSpeed;
  final String windDirection;
  final double waveHeight;
  final double barometricPressure;
  final String pressureTrend;

  WeatherData({
    required this.waterTemp,
    required this.airTemp,
    required this.windSpeed,
    required this.windDirection,
    required this.waveHeight,
    required this.barometricPressure,
    required this.pressureTrend,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}

@JsonSerializable()
class TidalInfo {
  final String nextHighTide;
  final String nextLowTide;
  final double tidalRange;

  TidalInfo({
    required this.nextHighTide,
    required this.nextLowTide,
    required this.tidalRange,
  });

  factory TidalInfo.fromJson(Map<String, dynamic> json) =>
      _$TidalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TidalInfoToJson(this);
}