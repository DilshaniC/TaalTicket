// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Venue _$VenueFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['location', 'starttime', 'endtime'],
  );
  return Venue(
    location: json['location'] as String,
    starttime: json['starttime'] as String,
    endtime: json['endtime'] as String,
  );
}

Map<String, dynamic> _$VenueToJson(Venue instance) => <String, dynamic>{
      'location': instance.location,
      'starttime': instance.starttime,
      'endtime': instance.endtime,
    };
