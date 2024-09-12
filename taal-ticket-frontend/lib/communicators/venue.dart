import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'venue.g.dart';

@JsonSerializable()
class Venue {
  @JsonKey(required: true, name: 'location')
  final String location;
  @JsonKey(required: true, name: 'starttime')
  final String starttime;
  @JsonKey(required: true, name: 'endtime')
  final String endtime;

  const Venue({required this.location, required this.starttime, required this.endtime});

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
  Map<String, dynamic> toJson() => _$VenueToJson(this);

}