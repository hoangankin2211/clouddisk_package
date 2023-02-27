
import 'package:json_annotation/json_annotation.dart';

import '../../../../api/create_folder_api/response/create_folder_response.dart';

part "upload_file_response.g.dart";

@JsonSerializable()
class UploadFileResponse extends ICreateUploadResopnse {
  final String size;
  final String authorId;
  final String path;
  final String regdate;

  UploadFileResponse({
    required super.id,
    required super.name,
    required this.size,
    required this.authorId,
    required this.path,
    required this.regdate,
  });

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadFileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFileResponseToJson(this);
}
