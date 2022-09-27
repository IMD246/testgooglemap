import 'package:flutter_google_map/models/prediction.dart';

class AutocompletePrediction {
  List<Predictions>? predictions;

  AutocompletePrediction({this.predictions});

  AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(Predictions.fromJson(v));
      });
    }
  }
}