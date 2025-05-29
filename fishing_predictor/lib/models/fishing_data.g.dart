// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fishing_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FishingData _$FishingDataFromJson(Map<String, dynamic> json) => FishingData(
      location: LocationData.fromJson(json['location'] as Map<String, dynamic>),
      currentConditions: WeatherData.fromJson(
          json['currentConditions'] as Map<String, dynamic>),
      tidalInfo: TidalInfo.fromJson(json['tidalInfo'] as Map<String, dynamic>),
      forecast6hr:
          ForecastData.fromJson(json['forecast6hr'] as Map<String, dynamic>),
      moonPhase: json['moonPhase'] as String,
      season: json['season'] as String,
    );

Map<String, dynamic> _$FishingDataToJson(FishingData instance) =>
    <String, dynamic>{
      'location': instance.location,
      'currentConditions': instance.currentConditions,
      'tidalInfo': instance.tidalInfo,
      'forecast6hr': instance.forecast6hr,
      'moonPhase': instance.moonPhase,
      'season': instance.season,
    };

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
    };

ForecastData _$ForecastDataFromJson(Map<String, dynamic> json) => ForecastData(
      tempChange: (json['tempChange'] as num).toDouble(),
      pressureChange: (json['pressureChange'] as num).toDouble(),
      windChange: json['windChange'] as String,
    );

Map<String, dynamic> _$ForecastDataToJson(ForecastData instance) =>
    <String, dynamic>{
      'tempChange': instance.tempChange,
      'pressureChange': instance.pressureChange,
      'windChange': instance.windChange,
    };
