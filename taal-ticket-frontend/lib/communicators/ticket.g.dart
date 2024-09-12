// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['packageName', 'price'],
  );
  return Ticket(
    packageName: json['packageName'] as String,
    price: (json['price'] as num).toInt(),
  );
}

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'packageName': instance.packageName,
      'price': instance.price,
    };
