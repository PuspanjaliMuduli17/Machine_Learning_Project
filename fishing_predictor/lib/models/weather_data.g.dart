// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      waterTemp: (json['waterTemp'] as num).toDouble(),
      airTemp: (json['airTemp'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      waveHeight: (json['waveHeight'] as num).toDouble(),
      barometricPressure: (json['barometricPressure'] as num).toDouble(),
      pressureTrend: json['pressureTrend'] as String,
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'waterTemp': instance.waterTemp,
      'airTemp': instance.airTemp,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'waveHeight': instance.waveHeight,
      'barometricPressure': instance.barometricPressure,
      'pressureTrend': instance.pressureTrend,
    };

TidalInfo _$TidalInfoFromJson(Map<String, dynamic> json) => TidalInfo(
      nextHighTide: json['nextHighTide'] as String,
      nextLowTide: json['nextLowTide'] as String,
      tidalRange: (json['tidalRange'] as num).toDouble(),
    );

Map<String, dynamic> _$TidalInfoToJson(TidalInfo instance) => <String, dynamic>{
      'nextHighTide': instance.nextHighTide,
      'nextLowTide': instance.nextLowTide,
      'tidalRange': instance.tidalRange,
    };
