import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/fishing_data.dart';
import '../models/prediction_result.dart';

class EnhancedPredictionService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

  static Future<PredictionResult?> getFishingPrediction(FishingData fishingData) async {
    try {
      final prompt = _buildEnhancedPrompt(fishingData);
      
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        
        // Parse the JSON response from Gemini
        final jsonStart = text.indexOf('{');
        final jsonEnd = text.lastIndexOf('}') + 1;
        
        if (jsonStart != -1 && jsonEnd > jsonStart) {
          final jsonStr = text.substring(jsonStart, jsonEnd);
          final predictionJson = json.decode(jsonStr);
          return PredictionResult.fromJson(predictionJson);
        }
      }
      
      // Fallback to mock data if API fails
      return _getMockPrediction(fishingData);
    } catch (e) {
      print('Error getting prediction: $e');
      return _getMockPrediction(fishingData);
    }
  }

  static String _buildEnhancedPrompt(FishingData fishingData) {
    return '''
You are Dr. Marina Pescador, a world-renowned marine biologist with 30+ years of experience studying fish behavior in Indian coastal waters. You combine traditional fishing wisdom with cutting-edge marine science.

CRITICAL ANALYSIS FACTORS for Indian Waters:
1. BAROMETRIC PRESSURE: Fish are 3x more active when pressure drops 2+ mb in 6 hours
2. TIDAL CYCLES: Prime feeding occurs 2 hours before/after high tide
3. WATER TEMPERATURE: 24-28°C optimal for most Indian species
4. MOON PHASES: Full/New moon = higher activity (gravitational feeding triggers)
5. WIND PATTERNS: 5-15 km/h creates ideal oxygenation without spooking fish
6. SEASONAL PATTERNS: Monsoon affects nutrient distribution and fish migration
7. TIME OF DAY: Dawn (5:30-7:30) and dusk (18:00-20:00) are peak feeding times

ANALYZE THESE CONDITIONS:
Location: ${fishingData.location.name} (${fishingData.location.lat}, ${fishingData.location.lng})
Water Temperature: ${fishingData.currentConditions.waterTemp}°C
Air Temperature: ${fishingData.currentConditions.airTemp}°C
Barometric Pressure: ${fishingData.currentConditions.barometricPressure} mb (${fishingData.currentConditions.pressureTrend})
Wind: ${fishingData.currentConditions.windSpeed} km/h ${fishingData.currentConditions.windDirection}
Wave Height: ${fishingData.currentConditions.waveHeight}m
Next High Tide: ${fishingData.tidalInfo.nextHighTide}
Next Low Tide: ${fishingData.tidalInfo.nextLowTide}
Tidal Range: ${fishingData.tidalInfo.tidalRange}m
Moon Phase: ${fishingData.moonPhase}
Season: ${fishingData.season}
6hr Forecast: Temp change ${fishingData.forecast6hr.tempChange}°C, Pressure change ${fishingData.forecast6hr.pressureChange}mb

PROVIDE ONLY VALID JSON (no markdown, no explanation):
{
  "hotspot_score": [1-10 integer based on optimal conditions],
  "confidence": "[low/medium/high] - based on data reliability",
  "best_times": [
    {"time": "HH:MM-HH:MM format", "reason": "specific scientific reason"},
    {"time": "HH:MM-HH:MM format", "reason": "specific scientific reason"}
  ],
  "target_species": [
    {"name": "Indian species name", "probability": "[low/medium/high]", "technique": "specific method"},
    {"name": "Indian species name", "probability": "[low/medium/high]", "technique": "specific method"}
  ],
  "conditions_analysis": {
    "pressure": "[excellent/good/fair/poor] - detailed scientific analysis",
    "tides": "[excellent/good/fair/poor] - detailed tidal analysis", 
    "temperature": "[excellent/good/fair/poor] - thermal analysis for fish activity"
  },
  "recommendations": [
    "Specific bait/lure recommendations for conditions",
    "Depth and location strategy",
    "Timing optimization advice"
  ],
  "safety_notes": [
    "Weather-specific safety concerns",
    "Water condition warnings if applicable"
  ]
}
''';
  }

  static PredictionResult _getMockPrediction(FishingData fishingData) {
    // Generate realistic mock data based on conditions
    int score = _calculateMockScore(fishingData);
    
    return PredictionResult(
      hotspotScore: score,
      confidence: score >= 7 ? 'high' : score >= 5 ? 'medium' : 'low',
      bestTimes: [
        BestTime(time: '05:30-07:30', reason: 'Dawn feeding period with optimal light conditions'),
        BestTime(time: '18:00-20:00', reason: 'Evening activity peak as temperature cools'),
      ],
      targetSpecies: [
        TargetSpecies(name: 'Pomfret', probability: 'high', technique: 'Bottom fishing with prawns'),
        TargetSpecies(name: 'Mackerel', probability: 'medium', technique: 'Surface trolling with small lures'),
        TargetSpecies(name: 'Kingfish', probability: 'medium', technique: 'Deep sea fishing with live bait'),
      ],
      conditionsAnalysis: ConditionsAnalysis(
        pressure: _analyzePressure(fishingData.currentConditions.barometricPressure),
        tides: _analyzeTides(fishingData.tidalInfo.tidalRange),
        temperature: _analyzeTemperature(fishingData.currentConditions.waterTemp),
      ),
      recommendations: [
        'Use fresh prawns or small fish as bait for better results',
        'Fish near underwater structures or drop-offs',
        'Early morning hours show highest fish activity',
        'Consider using circle hooks for better catch rates',
      ],
      safetyNotes: [
        'Check local weather updates before heading out',
        'Inform someone about your fishing plans and expected return',
        'Carry safety equipment including life jackets',
      ],
    );
  }

  static int _calculateMockScore(FishingData fishingData) {
    int score = 5; // Base score
    
    // Temperature analysis (optimal 24-28°C)
    double temp = fishingData.currentConditions.waterTemp;
    if (temp >= 24 && temp <= 28) score += 2;
    else if (temp >= 20 && temp <= 32) score += 1;
    
    // Pressure analysis
    double pressure = fishingData.currentConditions.barometricPressure;
    if (pressure >= 1010 && pressure <= 1020) score += 1;
    if (fishingData.currentConditions.pressureTrend == 'falling') score += 1;
    
    // Wind analysis (5-15 km/h optimal)
    double wind = fishingData.currentConditions.windSpeed;
    if (wind >= 5 && wind <= 15) score += 1;
    else if (wind > 20) score -= 2;
    
    // Tidal range analysis
    if (fishingData.tidalInfo.tidalRange > 1.5) score += 1;
    
    return score.clamp(1, 10);
  }

  static String _analyzePressure(double pressure) {
    if (pressure >= 1015 && pressure <= 1020) {
      return 'excellent - stable high pressure promotes active feeding';
    } else if (pressure >= 1010 && pressure <= 1025) {
      return 'good - favorable pressure range for fishing';
    } else if (pressure < 1010) {
      return 'fair - low pressure may reduce fish activity';
    } else {
      return 'poor - very high pressure typically slows fish feeding';
    }
  }

  static String _analyzeTides(double tidalRange) {
    if (tidalRange >= 2.0) {
      return 'excellent - strong tidal movement increases fish activity';
    } else if (tidalRange >= 1.5) {
      return 'good - moderate tidal flow attracts feeding fish';
    } else if (tidalRange >= 1.0) {
      return 'fair - gentle tidal movement, some fish activity expected';
    } else {
      return 'poor - minimal tidal movement may limit fish feeding';
    }
  }

  static String _analyzeTemperature(double temp) {
    if (temp >= 24 && temp <= 28) {
      return 'excellent - optimal temperature range for most species';
    } else if (temp >= 20 && temp <= 32) {
      return 'good - suitable temperature for fishing';
    } else if (temp >= 18 && temp <= 35) {
      return 'fair - acceptable temperature, some species may be less active';
    } else {
      return 'poor - temperature outside optimal range for most fish';
    }
  }
}