import 'package:json_annotation/json_annotation.dart';

part 'create_folder_response.g.dart';

abstract class ICreateUploadResopnse {
  final String id;
  final String name;

  ICreateUploadResopnse({required this.id, required this.name});
}

@JsonSerializable()
class CreateFolderResponse extends ICreateUploadResopnse {
  final String lastmod;
  final String author;
  final String pid;

  CreateFolderResponse({
    required this.lastmod,
    required this.author,
    required this.pid,
    required super.id,
    required super.name,
  });

  factory CreateFolderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFolderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFolderResponseToJson(this);
}
