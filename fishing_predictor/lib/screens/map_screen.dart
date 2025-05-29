import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';
import '../widgets/loading_widget.dart';
import 'prediction_result_screen.dart';

class MapScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapScreen({Key? key, this.initialLat, this.initialLng}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  bool _isLoading = false;
  String _locationName = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedLocation = LatLng(widget.initialLat!, widget.initialLng!);
      _addMarker(_selectedLocation!);
      _getLocationName(_selectedLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Fishing Location'),
        backgroundColor: AppConstants.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _getPrediction,
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? LatLng(19.0760, 72.8777), // Default to Mumbai
              zoom: 10,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            onTap: _onMapTapped,
            mapType: MapType.hybrid,
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppConstants.primaryBlue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selected Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _locationName.isEmpty ? 'Getting location...' : _locationName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
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
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _getPrediction,
                          icon: _isLoading 
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(Icons.psychology),
                          label: Text(_isLoading ? 'Getting Prediction...' : 'Get Fishing Prediction'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: LoadingWidget(message: 'Analyzing fishing conditions...'),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "popular",
            onPressed: _showPopularLocations,
            backgroundColor: Colors.white,
            child: Icon(Icons.star, color: AppConstants.primaryBlue),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "location",
            onPressed: _getCurrentLocation,
            backgroundColor: AppConstants.primaryBlue,
            child: Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _locationName = '';
    });
    _addMarker(location);
    _getLocationName(location);
  }

  void _addMarker(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: location,
          infoWindow: InfoWindow(title: 'Fishing Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  void _getLocationName(LatLng location) async {
    String name = await LocationService.getLocationName(location.latitude, location.longitude);
    setState(() {
      _locationName = name;
    });
  }

  void _getCurrentLocation() async {
    var position = await LocationService.getCurrentLocation();
    if (position != null) {
      LatLng location = LatLng(position.latitude, position.longitude);
      _controller?.animateCamera(CameraUpdate.newLatLng(location));
      _onMapTapped(location);
    }
  }

  void _showPopularLocations() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Popular Fishing Locations',
              style: AppConstants.headingStyle,
            ),
            SizedBox(height: 16),
            ...AppConstants.popularLocations.map((location) => ListTile(
              leading: Icon(Icons.location_on, color: AppConstants.primaryBlue),
              title: Text(location['name']),
              onTap: () {
                Navigator.pop(context);
                LatLng loc = LatLng(location['lat'], location['lng']);
                _controller?.animateCamera(CameraUpdate.newLatLng(loc));
                _onMapTapped(loc);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

void _getPrediction() async {
    if (_selectedLocation == null) return;

    setState(() => _isLoading = true);

    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PredictionResultScreen(
            location: _selectedLocation!,
            locationName: _locationName,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting prediction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}