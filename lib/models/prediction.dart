import 'package:flutter_google_map/models/terms.dart';

class Predictions {
  String? description;
  String? placeId;
  String? reference;
  List<Terms>? terms;

  Predictions({
    this.description,
    this.placeId,
    this.reference,
    this.terms,
  });

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
    reference = json['reference'];
    if (json['terms'] != null) {
      terms = <Terms>[];
      json['terms'].forEach((v) {
        terms!.add(Terms.fromJson(v));
      });
    }
  }
}
