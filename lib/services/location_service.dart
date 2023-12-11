import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:naviga/services/apikeys.dart';

Future<void> determinePosition(double latitude, double longitude) async {
  final apiUrl =
      'https://api.opencagedata.com/geocode/v1/json?key=$apiGeoKey&q=$latitude,$longitude';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    // Parse the response
    final decodedBody = json.decode(response.body);
    return decodedBody;
  } else {
    print('Failed to fetch geocoding data: ${response.statusCode}');
  }
}

void main() {
  // Example usage with specific latitude and longitude
  determinePosition(15.800029, 121.468227);
}
