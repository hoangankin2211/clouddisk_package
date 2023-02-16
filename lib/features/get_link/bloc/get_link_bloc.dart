import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/get_link_response.dart';
import '../../../utils/dio_service.dart';
import 'get_link_event.dart';
import 'get_link_state.dart';

class GetlinkBloc extends Bloc<GetlinkEvent, GetlinkState> {
  GetlinkBloc() : super(InitGetlinkState(selectedDateTime: DateTime.now())) {
    on<SelectDateTime>(handleSelectDateTime);
    on<ShareLinkEvent>(handleGetlinkEvent);
  }

  void handleSelectDateTime(
      SelectDateTime event, Emitter<GetlinkState> emit) async {
    emit(SelectTimeState(event.selectedDateTime));
  }

  void handleGetlinkEvent(
      ShareLinkEvent event, Emitter<GetlinkState> emit) async {
    try {
      emit(GettingShareLink());
      String files = "";

      for (var element in event.items) {
        if (element != event.items.last) {
          files +=
              "{\"id\":\"${element.id}\",\"count\":${event.downCount},\"name\":\"${element.name}\",\"expire\":${event.selectedDateTime.difference(DateTime.now()).inMilliseconds}},";
        } else {
          files +=
              "{\"id\":\"${element.id}\",\"count\":${event.downCount},\"name\":\"${element.name}\",\"expire\":${event.selectedDateTime.difference(DateTime.now()).inMilliseconds}}";
        }
      }
      Map<String, dynamic> data = {
        "mode": "set",
        "files": "[$files]",
      };
      final response = await DioService.post(
        "/cloud/api/link.php",
        data: data,
      );

      if (response != null) {
        print(response);
        List<GetLinkResponse> data = [];
        List<dynamic> listData = jsonDecode(response)["data"];
        for (var element in listData) {
          data.add(GetLinkResponse.fromJson(element));
        }
        emit(ExposeLinkState(data));
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
