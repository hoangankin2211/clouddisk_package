// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileResponse _$UploadFileResponseFromJson(Map<String, dynamic> json) =>
    UploadFileResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as String,
      authorId: json['authorId'] as String,
      path: json['path'] as String,
      regdate: json['regdate'] as String,
    );

Map<String, dynamic> _$UploadFileResponseToJson(UploadFileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': instance.size,
      'authorId': instance.authorId,
      'path': instance.path,
      'regdate': instance.regdate,
    };
