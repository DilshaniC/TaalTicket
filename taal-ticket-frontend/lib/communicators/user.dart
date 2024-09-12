import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(required: true, name: 'userId')
  final String userId;
  @JsonKey(required: true, name: 'name')
  final String username;
  @JsonKey(required: true, name: 'role')
  final String role;
  @JsonKey(required: true, name: 'access_token')
  final String accessToken;

  const User({required this.userId, required this.username, required this.accessToken, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  static Future<User> createUser(String username, String password) async {
    await dotenv.load();
    String host = dotenv.get('HOST', fallback: 'localhost');
    String port = dotenv.get('PORT', fallback: '9090');
    final response = await http.post(
      Uri.parse('http://$host:$port/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
          "user": {
            "name": username,
            "password": password
          }
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  static Future<User> createNewUser(String firstname, String lastname, String email, String password) async {
    await dotenv.load();
    String host = dotenv.get('HOST', fallback: 'localhost');
    String port = dotenv.get('PORT', fallback: '9090');
    String secret = dotenv.get('SECRET', fallback: '12345678');
    Uri url = Uri.parse('http://$host:$port/createUser');
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Object body = jsonEncode(<String, dynamic>{
      "firstName": firstname,
      "lastName": lastname,
      "userName": email,
      "email": email,
      "password": password,
      "roles": ["user"],
      "birthdate": DateTime.now().toIso8601String(),
      "secret": secret
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return createUser(email,password);
    } else {
      throw Exception('Failed to create user.');
    }
  }
}