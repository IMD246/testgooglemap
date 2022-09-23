import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_map/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoogleMap demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> googleController = Completer();
  final geolocator = Geolocator.getCurrentPosition(
    forceAndroidLocationManager: true,
  );
  Position? currentPosition;
  String currentAddress = "";
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static Marker kGooglePlexMarker = const Marker(
    markerId: MarkerId(
      '_kGooglePlex',
    ),
    infoWindow: InfoWindow(title: 'Google Plex'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );
  static Marker kLakeMarker = Marker(
    markerId: const MarkerId(
      '_kGooglePlex',
    ),
    infoWindow: const InfoWindow(title: 'Lake'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: const LatLng(
      37.42796265331129,
      -122.08832357078792,
    ),
  );

  static Polyline kPolyline = const Polyline(
    width: 5,
    polylineId: PolylineId(
      '_kPolyline',
    ),
    points: [
      LatLng(
        37.43296265331129,
        -122.08832357078792,
      ),
      LatLng(
        37.42796265331129,
        -122.08832357078792,
      )
    ],
  );
  Future<Position?> getCurPosition() async {
    Position position;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      return position;
    }
    return null;
  }

  static Polygon kPolygon = const Polygon(
    polygonId: PolygonId(
      'kPolygon',
    ),
    points: [
      LatLng(
        37.43296265331129,
        -122.08832357078792,
      ),
      LatLng(
        37.42796265331129,
        -122.08832357078792,
      ),
      LatLng(
        37.418,
        -122.092,
      ),
      LatLng(
        37.435,
        -122.092,
      ),
    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,
  );
  dynamic getCurrentLocation() async {
    final result = await getCurPosition();
    if (result == null) {
      setState(() {
        currentPosition = Position(
          longitude: -122.085749655962,
          latitude: 37.42796133580664,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      });
    } else {
      currentPosition = result;
      getAddressFromLatLng();
      setState(() {
        kGooglePlexMarker = Marker(
          markerId: const MarkerId(
            '_kGooglePlex',
          ),
          infoWindow: const InfoWindow(title: 'Your Position'),
          icon: BitmapDescriptor.defaultMarker,
          position:
              LatLng(currentPosition!.latitude, currentPosition!.longitude),
        );
      });
      final GoogleMapController controller = await googleController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentPosition!.latitude,
              currentPosition!.longitude,
            ),
            zoom: 12,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = p[0];
      setState(() {
        currentAddress =
            "${place.thoroughfare},${place.subThoroughfare},${place.name},${place.subLocality}";
      });
    } catch (e) {
      log(e.toString());
    }
  }

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Maps",
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: getCurrentLocation,
            child: const Text(
              "Get location",
              style: TextStyle(color: Colors.yellow),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Search ',
                  ),
                  onChanged: (value) {},
                ),
              ),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(searchController.text);
                  _goToPlace(place);
                },
                icon: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: currentPosition != null
                  ? CameraPosition(
                      target: LatLng(currentPosition!.latitude,
                          currentPosition!.longitude),
                      zoom: 14.4746,
                    )
                  : _kGooglePlex,
              markers: {
                kGooglePlexMarker,
              },
              onMapCreated: (GoogleMapController controller) {
                googleController.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await googleController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            lat,
            lng,
          ),
          zoom: 12,
        ),
      ),
    );
  }
}
