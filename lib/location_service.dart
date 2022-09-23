import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_google_map/.env';

class LocationService {
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$googleAPIKey';

    var response = await http.post(Uri.parse(url));

    var json = jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    log("place id : $placeId");

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleAPIKey';
    var response = await http.post(Uri.parse(url));

    var json = jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    log("place : $results");

    return results;
  }
}
