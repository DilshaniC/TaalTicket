import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rive_animation/communicators/show.dart';

part 'show_list_response.g.dart';

@JsonSerializable()
class ShowList {
  @JsonKey(required: true, name: 'allShows')
  final List<Show> allShows;

  const ShowList({required this.allShows});

  factory ShowList.fromJson(Map<String, dynamic> json) => _$ShowListFromJson(json);
  Map<String, dynamic> toJson() => _$ShowListToJson(this);

  static Future<ShowList?> getAllShowsHelper() async {
    String host = dotenv.get('HOST', fallback: 'localhost');
    String port = dotenv.get('PORT', fallback: '9090');
    var response = await http.get(Uri.parse('http://$host:$port/shows/viewAll'));
    if (response.statusCode >= 200 || response.statusCode < 300) {
      return ShowList.fromJson((jsonDecode(response.body)) as Map<String, dynamic>);
      // var jsonResponse = jsonDecode(response.body);
      // // var itemCount = jsonResponse['totalItems'];
      // print("Number of books about http: $jsonResponse.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return null;
    }
  }

}