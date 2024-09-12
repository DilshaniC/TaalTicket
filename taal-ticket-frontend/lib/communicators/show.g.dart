// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Show _$ShowFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      '_id',
      'name',
      'description',
      'image',
      'venues',
      'tickets',
      'artists'
    ],
  );
  return Show(
    id: json['_id'] as String,
    showName: json['name'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    venues: (json['venues'] as List<dynamic>)
        .map((e) => Venue.fromJson(e as Map<String, dynamic>))
        .toList(),
    tickets: (json['tickets'] as List<dynamic>)
        .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
        .toList(),
    artists:
        (json['artists'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ShowToJson(Show instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.showName,
      'description': instance.description,
      'image': instance.image,
      'venues': instance.venues,
      'tickets': instance.tickets,
      'artists': instance.artists,
    };
