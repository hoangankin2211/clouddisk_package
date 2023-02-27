import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/create_folder_api/create_folder_api.dart';
import '../../../../api/create_folder_api/response/create_folder_response.dart';
import '../../../../api/upload_file_api/response/upload_file_response.dart';
import '../../../../api/upload_file_api/upload_file_api.dart';
import '../../../../utils/dio_service.dart';

part 'cre_up_event.dart';
part 'cre_up_state.dart';

class CreateUploadBloc extends Bloc<CreateUploadEvent, CreateUploadState> {
  CreateUploadBloc() : super(CreateUploadState.init()) {
    on<CreateFolderEvent>(handleCreateFolderEvent);
    on<UploadFileEvent>(handleUploadFileEvent);
  }

  void handleCreateFolderEvent(
      CreateFolderEvent event, Emitter<CreateUploadState> emit) async {
    try {
      emit(CreateUploadState.handling());
      final data = await DioService.post(
        CreateApiFolder.apiPath,
        queryParameters: CreateApiFolder.params(
          force: event.force,
          parentId: event.parentId,
          name: event.name,
        ),
      );

      final jsonResponse = jsonDecode(data) as Map<String, dynamic>;
      print(jsonResponse);
      if (jsonResponse["success"]) {
        final ICreateUploadResopnse response =
            CreateFolderResponse.fromJson(jsonResponse["data"]);

        return emit(CreateUploadState.success(response: [response]));
      }
      return emit(CreateUploadState.fail());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  String _getRandomString(int length) {
    var random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  void handleUploadFileEvent(
      UploadFileEvent event, Emitter<CreateUploadState> emit) async {
    try {
      emit(CreateUploadState.handling());

      List<ICreateUploadResopnse> responses = [];
      for (var file in event.file) {
        if (file.path != null) {
          FormData body = await UploadFileApi.params(
            parentId: event.parentId,
            name: file.name,
            file: file.path!,
            fkey: _getRandomString(20),
          );

          final data = await DioService.post(UploadFileApi.apiPath, data: body);

          print("$data");

          final jsonResponse = jsonDecode(data) as Map<String, dynamic>;
          if (jsonResponse["success"]) {
            final ICreateUploadResopnse response =
                UploadFileResponse.fromJson(jsonResponse["data"]);
            responses.add(response);
          } else {
            return emit(CreateUploadState.fail());
          }
        }
      }
      return emit(CreateUploadState.success(response: responses));
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
