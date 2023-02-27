// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_folder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFolderResponse _$CreateFolderResponseFromJson(
        Map<String, dynamic> json) =>
    CreateFolderResponse(
      lastmod: json['lastmod'] as String,
      author: json['author'] as String,
      pid: json['pid'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateFolderResponseToJson(
        CreateFolderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastmod': instance.lastmod,
      'author': instance.author,
      'pid': instance.pid,
    };
