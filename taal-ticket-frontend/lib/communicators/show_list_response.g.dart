// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowList _$ShowListFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['allShows'],
  );
  return ShowList(
    allShows: (json['allShows'] as List<dynamic>)
        .map((e) => Show.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ShowListToJson(ShowList instance) => <String, dynamic>{
      'allShows': instance.allShows,
    };
