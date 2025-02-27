// To parse this JSON data, do
//
//     final searchCandidateResponseModel = searchCandidateResponseModelFromJson(jsonString);

import 'dart:convert';

SearchCandidateResponseModel searchCandidateResponseModelFromJson(String str) =>
    SearchCandidateResponseModel.fromJson(json.decode(str));

String searchCandidateResponseModelToJson(SearchCandidateResponseModel data) =>
    json.encode(data.toJson());

class SearchCandidateResponseModel {
  String? formattedAddress;
  Geometry? geometry;
  String? name;

  SearchCandidateResponseModel({
    this.formattedAddress,
    this.geometry,
    this.name,
  });

  factory SearchCandidateResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchCandidateResponseModel(
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "name": name,
      };
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        viewport: json["viewport"] == null
            ? null
            : Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "viewport": viewport?.toJson(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null
            ? null
            : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}
