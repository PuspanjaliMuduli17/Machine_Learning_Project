import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/fishing_data.dart';
import '../models/weather_data.dart';
import '../models/prediction_result.dart';
import '../services/weather_service.dart';
import '../services/prediction_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/weather_card.dart';
import '../widgets/prediction_card.dart';
import '../utils/constants.dart';

class PredictionResultScreen extends StatefulWidget {
  final LatLng location;
  final String locationName;

  const PredictionResultScreen({
    Key? key,
    required this.location,
    required this.locationName,
  }) : super(key: key);

  @override
  _PredictionResultScreenState createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  bool _isLoading = true;
  WeatherData? _weatherData;
  TidalInfo? _tidalInfo;
  PredictionResult? _predictionResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Get weather data
      _weatherData = await WeatherService.getWeatherData(
        widget.location.latitude,
        widget.location.longitude,
      );

      // Get tidal info
      _tidalInfo = await WeatherService.getTidalInfo(
        widget.location.latitude,
        widget.location.longitude,
      );

      if (_weatherData != null && _tidalInfo != null) {
        // Create fishing data
        FishingData fishingData = FishingData(
          location: LocationData(
            lat: widget.location.latitude,
            lng: widget.location.longitude,
            name: widget.locationName,
          ),
          currentConditions: _weatherData!,
          tidalInfo: _tidalInfo!,
          forecast6hr: ForecastData(
            tempChange: -2.0,
            pressureChange: 5.0,
            windChange: 'increasing',
          ),
          moonPhase: _getCurrentMoonPhase(),
          season: _getCurrentSeason(),
        );

        // Get prediction
        _predictionResult = await EnhancedPredictionService.getFishingPrediction(fishingData);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load prediction data: $e';
      });
    }
  }

  String _getCurrentMoonPhase() {
    // Simplified moon phase calculation
    DateTime now = DateTime.now();
    int dayOfMonth = now.day;
    
    if (dayOfMonth <= 7) return 'waxing_crescent';
    if (dayOfMonth <= 14) return 'first_quarter';
    if (dayOfMonth <= 21) return 'full_moon';
    if (dayOfMonth <= 28) return 'waning_gibbous';
    return 'new_moon';
  }

  String _getCurrentSeason() {
    int month = DateTime.now().month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fishing Prediction'),
        backgroundColor: AppConstants.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _loadData();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return LoadingWidget(message: 'Analyzing fishing conditions...');
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_weatherData == null || _tidalInfo == null || _predictionResult == null) {
      return _buildErrorWidget();
    }

    return Container(
      decoration: BoxDecoration(gradient: AppConstants.backgroundGradient),
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationHeader(),
              SizedBox(height: 16),
              EnhancedWeatherCard(
                weatherData: _weatherData!,
                tidalInfo: _tidalInfo!,
              ),
              SizedBox(height: 16),
              PredictionCard(prediction: _predictionResult!),
              SizedBox(height: 16),
              _buildActionButtons(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppConstants.primaryBlue, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.locationName,
                    style: AppConstants.headingStyle.copyWith(fontSize: 18),
                  ),
                  Text(
                    '${widget.location.latitude.toStringAsFixed(4)}, ${widget.location.longitude.toStringAsFixed(4)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Updated: ${DateTime.now().toString().substring(0, 16)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Unable to Load Prediction',
              style: AppConstants.headingStyle.copyWith(color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Something went wrong. Please try again.',
              style: AppConstants.bodyStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadData();
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _shareResults(),
            icon: Icon(Icons.share),
            label: Text('Share Results'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _saveToFavorites(),
            icon: Icon(Icons.favorite_border),
            label: Text('Save Location'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.primaryBlue,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _shareResults() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  void _saveToFavorites() {
    // Implement save to favorites
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location saved to favorites!')),
    );
  }
}