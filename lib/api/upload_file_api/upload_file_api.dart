import 'package:clouddisk/constant/root_path.dart';
import 'package:dio/dio.dart';

class UploadFileApi {
  static const String apiPath = "/cgi-bin/cloudUpload.cgi";

  static Future<FormData> params({
    required String fkey,
    required String file,
    required String parentId,
    required String name,
  }) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "fkey": fkey,
      "file": await MultipartFile.fromFile(file),
      "cookie": RootPath.session,
      "parentId": parentId,
    });

    return formData;
  }
}
