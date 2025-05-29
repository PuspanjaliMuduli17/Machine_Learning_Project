// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictionResult _$PredictionResultFromJson(Map<String, dynamic> json) =>
    PredictionResult(
      hotspotScore: (json['hotspotScore'] as num).toInt(),
      confidence: json['confidence'] as String,
      bestTimes: (json['bestTimes'] as List<dynamic>)
          .map((e) => BestTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetSpecies: (json['targetSpecies'] as List<dynamic>)
          .map((e) => TargetSpecies.fromJson(e as Map<String, dynamic>))
          .toList(),
      conditionsAnalysis: ConditionsAnalysis.fromJson(
          json['conditionsAnalysis'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      safetyNotes: (json['safetyNotes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PredictionResultToJson(PredictionResult instance) =>
    <String, dynamic>{
      'hotspotScore': instance.hotspotScore,
      'confidence': instance.confidence,
      'bestTimes': instance.bestTimes,
      'targetSpecies': instance.targetSpecies,
      'conditionsAnalysis': instance.conditionsAnalysis,
      'recommendations': instance.recommendations,
      'safetyNotes': instance.safetyNotes,
    };

BestTime _$BestTimeFromJson(Map<String, dynamic> json) => BestTime(
      time: json['time'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$BestTimeToJson(BestTime instance) => <String, dynamic>{
      'time': instance.time,
      'reason': instance.reason,
    };

TargetSpecies _$TargetSpeciesFromJson(Map<String, dynamic> json) =>
    TargetSpecies(
      name: json['name'] as String,
      probability: json['probability'] as String,
      technique: json['technique'] as String,
    );

Map<String, dynamic> _$TargetSpeciesToJson(TargetSpecies instance) =>
    <String, dynamic>{
      'name': instance.name,
      'probability': instance.probability,
      'technique': instance.technique,
    };

ConditionsAnalysis _$ConditionsAnalysisFromJson(Map<String, dynamic> json) =>
    ConditionsAnalysis(
      pressure: json['pressure'] as String,
      tides: json['tides'] as String,
      temperature: json['temperature'] as String,
    );

Map<String, dynamic> _$ConditionsAnalysisToJson(ConditionsAnalysis instance) =>
    <String, dynamic>{
      'pressure': instance.pressure,
      'tides': instance.tides,
      'temperature': instance.temperature,
    };
