import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../utils/constants.dart';

class EnhancedWeatherCard extends StatelessWidget {
  final WeatherData weatherData;
  final TidalInfo tidalInfo;

  const EnhancedWeatherCard({
    Key? key,
    required this.weatherData,
    required this.tidalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppConstants.cardGradient,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildMainConditions(),
            _buildTidalInfo(),
            _buildDetailedMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.wb_sunny, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marine Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Live oceanographic data',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          _buildPressureTrend(),
        ],
      ),
    );
  }

  Widget _buildPressureTrend() {
    IconData icon;
    Color color;
    switch (weatherData.pressureTrend.toLowerCase()) {
      case 'rising':
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case 'falling':
        icon = Icons.trending_down;
        color = Colors.orange;
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.white70;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 4),
          Text(
            weatherData.pressureTrend,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainConditions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildTemperatureCard(),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildWindCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.thermostat, color: Colors.white, size: 20),
          SizedBox(height: 4),
          Text(
            '${weatherData.waterTemp.toInt()}°C',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Water Temp',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.air, color: Colors.white, size: 20),
          SizedBox(height: 4),
          Text(
            '${weatherData.windSpeed.toInt()}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'km/h ${weatherData.windDirection}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTidalInfo() {
    return Container(
      margin: EdgeInsets.all(AppConstants.defaultPadding),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.waves, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Tidal Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTideTime('High Tide', tidalInfo.nextHighTide, Icons.keyboard_arrow_up),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white30,
              ),
              Expanded(
                child: _buildTideTime('Low Tide', tidalInfo.nextLowTide, Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTideTime(String label, String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedMetrics() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildMetric(
              Icons.compress,
              'Pressure',
              '${weatherData.barometricPressure.toInt()} mb',
            ),
          ),
          Expanded(
            child: _buildMetric(
              Icons.waves,
              'Wave Height',
              '${weatherData.waveHeight}m',
            ),
          ),
          Expanded(
            child: _buildMetric(
              Icons.height,
              'Tidal Range',
              '${tidalInfo.tidalRange}m',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
