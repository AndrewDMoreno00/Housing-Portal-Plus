/*
import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myCurrentLocation = const LatLng(36.9905, -122.0584);
  String? _apiKey;
  // ignore: unused_field
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _fetchApiKey();
  }

  Future<void> _fetchApiKey() async {
    try {
      // Fetch the API key from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('api_keys')
          .doc('Google Map platform')
          .get();

      // Extract the API key 
      setState(() {
        _apiKey = snapshot.get('map_api');
      });
    } catch (e) {
      print('Error fetching API key: $e');
      // Handle error - maybe show a snackbar or dialog
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load map API key'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only render GoogleMap if API key is loaded
    return Scaffold(
      body: _apiKey == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: myCurrentLocation,
                zoom: 15
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng myCurrentLocation = const LatLng(36.9905, -122.0584); // UCSC coordinates
  String? _apiKey;
  GoogleMapController? _mapController;
  final TextEditingController _destinationController = TextEditingController();
  
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _destinationLocation;
  
  // Travel mode selection
  String _selectedMode = 'walking';
  // ignore: unused_field
  final List<String> _travelModes = ['driving', 'walking', 'bicycling'];
  
  // Map to store colors for different travel modes
  final Map<String, Color> _travelModeColors = {
    'driving': Colors.red,
    'walking': Colors.green,
    'bicycling': Colors.orange,
  };
  
  // Map to store icons for different travel modes
  final Map<String, IconData> _travelModeIcons = {
    'driving': Icons.directions_car,
    'walking': Icons.directions_walk,
    'bicycling': Icons.directions_bike,
  };

  @override
  void initState() {
    super.initState();
    _fetchApiKey();
    
    // Add UCSC marker by default
    _markers.add(
      Marker(
        markerId: const MarkerId('UCSC'),
        position: myCurrentLocation,
        infoWindow: const InfoWindow(title: 'UCSC')
      ),
    );
  }

  Future<void> _fetchApiKey() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('api_keys')
          .doc('Google Map platform')
          .get();

      setState(() {
        _apiKey = snapshot.get('map_api');
      });
    } catch (e) {
      print('Error fetching API key: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load map API key'))
        );
      }
    }
  }
  
  // Function to search for a destination location
  Future<void> _searchDestination(String destination) async {
    try {
      List<Location> locations = await locationFromAddress(destination);
      if (locations.isNotEmpty) {
        setState(() {
          _destinationLocation = LatLng(
            locations.first.latitude, 
            locations.first.longitude
          );
          
          // Add destination marker
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: _destinationLocation!,
              infoWindow: InfoWindow(title: destination)
            ),
          );
        });
        
        // Draw a simple direct line for now instead of using PolylinePoints
        _drawDirectLine();
        
        // Adjust the camera to show both points
        _adjustMapView();
      }
    } catch (e) {
      print('Error searching for location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find the specified location'))
        );
      }
    }
  }
  
  // Simplified function to draw a direct line between points
  void _drawDirectLine() {
    if (_destinationLocation == null) return;
    
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: _travelModeColors[_selectedMode] ?? Colors.blue,
          points: [myCurrentLocation, _destinationLocation!],
          width: 5,
        ),
      );
    });
  }
  
  // Function to adjust map view to show both UCSC and destination
  void _adjustMapView() {
    if (_mapController == null || _destinationLocation == null) return;
    
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        myCurrentLocation.latitude < _destinationLocation!.latitude 
            ? myCurrentLocation.latitude 
            : _destinationLocation!.latitude,
        myCurrentLocation.longitude < _destinationLocation!.longitude 
            ? myCurrentLocation.longitude 
            : _destinationLocation!.longitude,
      ),
      northeast: LatLng(
        myCurrentLocation.latitude > _destinationLocation!.latitude 
            ? myCurrentLocation.latitude 
            : _destinationLocation!.latitude,
        myCurrentLocation.longitude > _destinationLocation!.longitude 
            ? myCurrentLocation.longitude 
            : _destinationLocation!.longitude,
      ),
    );
    
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  // Change travel mode and redraw line
  void _changeTravelMode(String mode) {
    setState(() {
      _selectedMode = mode;
    });
    
    if (_destinationLocation != null) {
      _drawDirectLine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCSC Transit Guide'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search bar for destination
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      hintText: 'Enter destination',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _destinationController.clear(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_destinationController.text.isNotEmpty) {
                      _searchDestination(_destinationController.text);
                    }
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          
          // Travel mode selection
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTravelModeButton('driving', 'Driving'),
                const SizedBox(width: 8),
                _buildTravelModeButton('walking', 'Walking'),
                const SizedBox(width: 8),
                _buildTravelModeButton('bicycling', 'Biking'),
              ],
            ),
          ),
          
          // Map view
          Expanded(
            child: _apiKey == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: myCurrentLocation,
                      zoom: 15
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.my_location, color: Colors.white),
              onPressed: () {
                // Reset to UCSC view
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: myCurrentLocation, zoom: 15),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build travel mode selection buttons
  Widget _buildTravelModeButton(String mode, String label) {
    bool isSelected = _selectedMode == mode;
    
    return ElevatedButton.icon(
      onPressed: () => _changeTravelMode(mode),
      icon: Icon(
        _travelModeIcons[mode] ?? Icons.directions,
        color: isSelected ? Colors.white : _travelModeColors[mode],
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? _travelModeColors[mode] : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        side: BorderSide(
          color: _travelModeColors[mode] ?? Colors.blue,
          width: 2,
        ),
      ),
    );
  }
}