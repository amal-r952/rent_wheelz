import 'dart:convert';

import 'package:rent_wheelz/src/models/search_candidate_response_model.dart';

SearchResultResponseModel searchResultResponseModelFromJson(String str) =>
    SearchResultResponseModel.fromJson(json.decode(str));

String searchResultResponseModelToJson(SearchResultResponseModel data) =>
    json.encode(data.toJson());

class SearchResultResponseModel {
  List<SearchCandidateResponseModel>? candidates;
  String? status;

  SearchResultResponseModel({
    this.candidates,
    this.status,
  });

  factory SearchResultResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchResultResponseModel(
        candidates: json["candidates"] == null
            ? []
            : List<SearchCandidateResponseModel>.from(json["candidates"]!
                .map((x) => SearchCandidateResponseModel.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "candidates": candidates == null
            ? []
            : List<dynamic>.from(candidates!.map((x) => x.toJson())),
        "status": status,
      };
}
