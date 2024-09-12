import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rive_animation/communicators/ticket.dart';
import 'package:rive_animation/communicators/venue.dart';

part 'show.g.dart';

@JsonSerializable()
class Show {
  @JsonKey(required: true, name: '_id')
  final String id;
  @JsonKey(required: true, name: 'name')
  final String showName;
  @JsonKey(required: true, name: 'description')
  final String description;
  @JsonKey(required: true, name: 'image')
  final String image;
  @JsonKey(required: true, name: 'venues')
  final List<Venue> venues;
  @JsonKey(required: true, name: 'tickets')
  final List<Ticket> tickets;
  @JsonKey(required: true, name: 'artists')
  final List<String> artists;

  const Show({required this.id, required this.showName, required this.description, required this.image, required this.venues, required this.tickets, required this.artists});

  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);
  Map<String, dynamic> toJson() => _$ShowToJson(this);

  static Future<String> getAllShowsHelper() async {
    String host = dotenv.get('HOST', fallback: 'localhost');
      String port = dotenv.get('PORT', fallback: '9090');
    var response = await http.get(Uri.parse('http://$host:$port/shows/viewAll'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("Number of books about http: $jsonResponse.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return "Udara";
  }
}