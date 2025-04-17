import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng myCurrentLocation = const LatLng(36.9905, -122.0584); // UCSC
  GoogleMapController? _mapController;
  final TextEditingController _destinationController = TextEditingController();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _destinationLocation;

  String _selectedMode = 'walking';
  final Map<String, Color> _travelModeColors = {
    'driving': Colors.red,
    'walking': Colors.green,
    'bicycling': Colors.orange,
  };
  final Map<String, IconData> _travelModeIcons = {
    'driving': Icons.directions_car,
    'walking': Icons.directions_walk,
    'bicycling': Icons.directions_bike,
  };

  String? _apiKey;
  List<dynamic> _predictions = []; // ✅ Updated to dynamic list

  @override
  void initState() {
    super.initState();
    _fetchApiKey();
    _markers.add(
      Marker(
        markerId: const MarkerId('UCSC'),
        position: myCurrentLocation,
        infoWindow: const InfoWindow(title: 'UCSC'),
      ),
    );
    _destinationController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _destinationController.removeListener(_onSearchChanged);
    _destinationController.dispose();
    super.dispose();
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
    }
  }

  void _onSearchChanged() async {
    if (_destinationController.text.isEmpty || _apiKey == null) {
      setState(() => _predictions = []);
      return;
    }

    final results = await fetchAutocomplete(_destinationController.text);
    setState(() => _predictions = results);
  }

  Future<List<dynamic>> fetchAutocomplete(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${myCurrentLocation.latitude},${myCurrentLocation.longitude}&radius=3000&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'OK') {
      return data['predictions'];
    }
    return [];
  }

  Future<LatLng?> fetchPlaceDetails(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['status'] == 'OK') {
      final location = data['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }

    return null;
  }

  Future<void> _selectPrediction(dynamic prediction) async {
    _destinationController.text = prediction['description'];
    setState(() => _predictions.clear());

    final placeId = prediction['place_id'];
    final location = await fetchPlaceDetails(placeId);

    if (location != null) {
      _destinationLocation = location;
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: location,
          infoWindow: InfoWindow(title: prediction['description']),
        ),
      );
      _getDirections();
    }
  }

  Future<void> _getDirections() async {
    if (_destinationLocation == null || _apiKey == null) return;

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${myCurrentLocation.latitude},${myCurrentLocation.longitude}&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}&mode=$_selectedMode&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final points = <LatLng>[];
        final steps = data['routes'][0]['legs'][0]['steps'];
        for (var step in steps) {
          points.add(LatLng(
            step['start_location']['lat'],
            step['start_location']['lng'],
          ));
          points.add(LatLng(
            step['end_location']['lat'],
            step['end_location']['lng'],
          ));
        }

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              width: 6,
              color: _travelModeColors[_selectedMode] ?? Colors.blue,
            ),
          );
        });

        _adjustMapView();
      }
    } else {
      print("Error getting directions: ${response.body}");
    }
  }

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

  void _changeTravelMode(String mode) {
    setState(() {
      _selectedMode = mode;
    });

    if (_destinationLocation != null) {
      _getDirections();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: 'Search destination (e.g. Baskin Engineering)',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _destinationController.clear();
                        setState(() {
                          _predictions.clear();
                          _polylines.clear();
                          _destinationLocation = null;
                        });
                      },
                    ),
                  ),
                ),
                if (_predictions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_predictions[index]['description'] ?? ''),
                          onTap: () => _selectPrediction(_predictions[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
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
          Expanded(
            child: _apiKey == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: myCurrentLocation,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
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

  Widget _buildTravelModeButton(String mode, String label) {
    bool isSelected = _selectedMode == mode;

    return ElevatedButton.icon(
      onPressed: () => _changeTravelMode(mode),
      icon: Icon(
        _travelModeIcons[mode],
        color: isSelected ? Colors.white : _travelModeColors[mode],
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? _travelModeColors[mode] : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(
          color: _travelModeColors[mode] ?? Colors.blue,
          width: 2,
        ),
      ),
    );
  }
}