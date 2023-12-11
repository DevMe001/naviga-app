import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class YourMapView extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _YourMapViewState createState() => _YourMapViewState();
}

class _YourMapViewState extends State<YourMapView> {
  final TextEditingController addressController = TextEditingController();
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geocoding Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Enter Address'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call the utility function when the button is pressed
                geocodeAddress();
              },
              child: const Text('Geocode Address'),
            ),
            const SizedBox(height: 16.0),
            Text(result),
          ],
        ),
      ),
    );
  }

  Future<void> geocodeAddress() async {
    String address = addressController.text;

    try {
      // Initialize the geocoding package with your API key
      Geocoding.init("YOUR_API_KEY");

      List<Location> locations = await locationFromAddress(address);
      setState(() {
        result =
            'Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}';
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: YourMapView(),
  ));
}
