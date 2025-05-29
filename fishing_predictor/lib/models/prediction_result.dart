import 'package:json_annotation/json_annotation.dart';

part 'prediction_result.g.dart';

@JsonSerializable()
class PredictionResult {
  final int hotspotScore;
  final String confidence;
  final List<BestTime> bestTimes;
  final List<TargetSpecies> targetSpecies;
  final ConditionsAnalysis conditionsAnalysis;
  final List<String> recommendations;
  final List<String> safetyNotes;

  PredictionResult({
    required this.hotspotScore,
    required this.confidence,
    required this.bestTimes,
    required this.targetSpecies,
    required this.conditionsAnalysis,
    required this.recommendations,
    required this.safetyNotes,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      _$PredictionResultFromJson(json);
  Map<String, dynamic> toJson() => _$PredictionResultToJson(this);
}

@JsonSerializable()
class BestTime {
  final String time;
  final String reason;

  BestTime({required this.time, required this.reason});

  factory BestTime.fromJson(Map<String, dynamic> json) =>
      _$BestTimeFromJson(json);
  Map<String, dynamic> toJson() => _$BestTimeToJson(this);
}

@JsonSerializable()
class TargetSpecies {
  final String name;
  final String probability;
  final String technique;

  TargetSpecies({
    required this.name,
    required this.probability,
    required this.technique,
  });

  factory TargetSpecies.fromJson(Map<String, dynamic> json) =>
      _$TargetSpeciesFromJson(json);
  Map<String, dynamic> toJson() => _$TargetSpeciesToJson(this);
}

@JsonSerializable()
class ConditionsAnalysis {
  final String pressure;
  final String tides;
  final String temperature;

  ConditionsAnalysis({
    required this.pressure,
    required this.tides,
    required this.temperature,
  });

  factory ConditionsAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ConditionsAnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionsAnalysisToJson(this);
}