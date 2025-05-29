import 'package:json_annotation/json_annotation.dart';
import 'weather_data.dart';

part 'fishing_data.g.dart';

@JsonSerializable()
class FishingData {
  final LocationData location;
  final WeatherData currentConditions;
  final TidalInfo tidalInfo;
  final ForecastData forecast6hr;
  final String moonPhase;
  final String season;

  FishingData({
    required this.location,
    required this.currentConditions,
    required this.tidalInfo,
    required this.forecast6hr,
    required this.moonPhase,
    required this.season,
  });

  factory FishingData.fromJson(Map<String, dynamic> json) =>
      _$FishingDataFromJson(json);
  Map<String, dynamic> toJson() => _$FishingDataToJson(this);
}

@JsonSerializable()
class LocationData {
  final double lat;
  final double lng;
  final String name;

  LocationData({
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}

@JsonSerializable()
class ForecastData {
  final double tempChange;
  final double pressureChange;
  final String windChange;

  ForecastData({
    required this.tempChange,
    required this.pressureChange,
    required this.windChange,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) =>
      _$ForecastDataFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastDataToJson(this);
}