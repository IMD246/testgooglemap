import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_google_map/.env';

import 'models/autocomplete_prediction.dart';

class LocationService {
  Future<AutocompletePrediction> getListPlaces(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyC3RIWEADPnupSki2a9jY1akmj4lkb_6XE&components=country:vn";

    var response = await http.post(Uri.parse(url));

    var json = jsonDecode(response.body);
    
    log("predictions : ${json["predictions"]}");

    return AutocompletePrediction.fromJson(json);
  }

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$googleAPIKey';

    var response = await http.post(Uri.parse(url));

    var json = jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    log("place id : $placeId");

    return placeId;
  }
   Future<Map<String, dynamic>> getPlaceByTextString(String text) async {
    final placeID =await getPlaceId(text)
;    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$googleAPIKey';
    var response = await http.post(Uri.parse(url));

    var json = jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    log("place : $results");

    return results;
  }
  Future<Map<String, dynamic>> getPlaceByID(String placeID) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$googleAPIKey';
    var response = await http.post(Uri.parse(url));

    var json = jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    log("place : $results");

    return results;
  }
}
