// GENERATED CODE - DO NOT MODIFY BY HAND

part of "error.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MDError _$MDErrorFromJson(Map<String, dynamic> json) => MDError(
      title: json["title"] as String,
      status: json["status"] as int,
    );

Map<String, dynamic> _$MDErrorToJson(MDError instance) => <String, dynamic>{
      "title": instance.title,
      "status": instance.status,
    };
