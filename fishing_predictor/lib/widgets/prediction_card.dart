import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../utils/constants.dart';

class PredictionCard extends StatelessWidget {
  final PredictionResult prediction;

  const PredictionCard({Key? key, required this.prediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreSection(),
            SizedBox(height: 20),
            _buildBestTimesSection(),
            SizedBox(height: 20),
            _buildSpeciesSection(),
            SizedBox(height: 20),
            _buildAnalysisSection(),
            SizedBox(height: 20),
            _buildRecommendationsSection(),
            if (prediction.safetyNotes.isNotEmpty) ...[
              SizedBox(height: 20),
              _buildSafetySection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection() {
    Color scoreColor = AppConstants.getScoreColor(prediction.hotspotScore);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: scoreColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: scoreColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${prediction.hotspotScore}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fishing Hotspot Score',
                  style: AppConstants.headingStyle.copyWith(fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  'Confidence: ${prediction.confidence.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestTimesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, color: AppConstants.primaryBlue),
            SizedBox(width: 8),
            Text('Best Fishing Times', style: AppConstants.subHeadingStyle),
          ],
        ),
        SizedBox(height: 12),
        ...prediction.bestTimes.map((time) => Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 20, color: AppConstants.primaryBlue),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time.time,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkBlue,
                      ),
                    ),
                    Text(
                      time.reason,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildSpeciesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🐟', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text('Target Species', style: AppConstants.subHeadingStyle),
          ],
        ),
        SizedBox(height: 12),
        ...prediction.targetSpecies.map((species) => Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getProbabilityColor(species.probability),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  species.probability.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      species.technique,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: AppConstants.primaryBlue),
            SizedBox(width: 8),
            Text('Conditions Analysis', style: AppConstants.subHeadingStyle),
          ],
        ),
        SizedBox(height: 12),
        _buildAnalysisItem('Pressure', prediction.conditionsAnalysis.pressure, Icons.compress),
        _buildAnalysisItem('Tides', prediction.conditionsAnalysis.tides, Icons.waves),
        _buildAnalysisItem('Temperature', prediction.conditionsAnalysis.temperature, Icons.thermostat),
      ],
    );
  }

  Widget _buildAnalysisItem(String title, String analysis, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppConstants.primaryBlue),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  analysis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.orange),
            SizedBox(width: 8),
            Text('Recommendations', style: AppConstants.subHeadingStyle),
          ],
        ),
        SizedBox(height: 12),
        ...prediction.recommendations.map((rec) => Container(
          margin: EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec,
                  style: AppConstants.bodyStyle,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildSafetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Safety Notes', style: AppConstants.subHeadingStyle.copyWith(color: Colors.red)),
          ],
        ),
        SizedBox(height: 12),
        ...prediction.safetyNotes.map((note) => Container(
          margin: EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.priority_high, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  note,
                  style: AppConstants.bodyStyle,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Color _getProbabilityColor(String probability) {
    switch (probability.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}