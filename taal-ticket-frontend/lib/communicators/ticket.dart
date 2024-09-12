import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  @JsonKey(required: true, name: 'packageName')
  final String packageName;
  @JsonKey(required: true, name: 'price')
  final int price;

  const Ticket({required this.packageName, required this.price});

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
  Map<String, dynamic> toJson() => _$TicketToJson(this);
}