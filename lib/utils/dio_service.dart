import '../constant/api_info.dart';
import 'package:dio/dio.dart';

class DioService {
  static final Dio dio =
      Dio(BaseOptions(baseUrl: Api.baseUrl, headers: Api.header));

  static Future post(String path,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      final response = await DioService.dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await DioService.dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
