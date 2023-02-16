import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant/api_info.dart';
import '../../../../model/item.dart';
import '../../../../utils/dio_service.dart';
import '../../../../utils/shared_preferences.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(InitState()) {
    on<OpenFolder>(openNormalFolderHandle);
    on<OpenMainFolderEvent>(openMainFolderHandle);
    on<SortItemEvent>(sortItemEventHandle);
  }

  void openMainFolderHandle(
      OpenMainFolderEvent event, Emitter<ItemState> emit) async {
    try {
      emit(LoadingItem());
      final response = await DioService.get(
        ApiPath.apiMainFolder,
        queryParameters: ApiParam.mainFolderParam,
      );

      if (response != null) {
        List<Item> mainFolders = [];
        print(jsonDecode(response));
        List<dynamic> data = jsonDecode(response);
        for (var element in data) {
          Map<String, dynamic> extractData = element;
          mainFolders.add(Item.fromJson(extractData));
        }
        emit(LoadListItemState(mainFolders, true));
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  void openNormalFolderHandle(OpenFolder event, Emitter<ItemState> emit) async {
    try {
      final Map<String, dynamic> params = {};
      String? sortType =
          SharedPreferencesUtils.sharedPreferences!.getString("SortType");
      String? order =
          SharedPreferencesUtils.sharedPreferences!.getString("Order");
      ApiParam.childFolderParam
          .forEach((key, value) => params.addAll({key: value}));
      params.addAll({"start": event.start});
      params.addAll({"id": event.id});
      params
          .addAll({"sort": "[{\"sort\":\"$sortType\",\"order\":\"$order\"}]"});
      final response =
          await DioService.get(ApiPath.apiMainFolder, queryParameters: params);
      if (response != null) {
        List<Item> listFolder = [];

        List<dynamic> data = jsonDecode(response)["files"];
        if (data.isEmpty) {
          print(data);
          return emit(LoadListItemState(List.of(event.currentList), true));
        }
        for (var element in data) {
          Map<String, dynamic> extractData = element;
          listFolder.add(Item.fromJson(extractData));
        }
        emit(LoadListItemState(
            List.of(event.currentList)..addAll(listFolder), false));
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  void sortItemEventHandle(SortItemEvent event, Emitter<ItemState> emit) async {
    try {
      emit(LoadingItem());
      final Map<String, dynamic> params = {};
      ApiParam.childFolderParam
          .forEach((key, value) => params.addAll({key: value}));
      params.addAll({"id": event.folderId});
      params.addAll({
        "sort":
            "[{\"sort\":\"${event.sortType.id}\",\"order\":\"${event.order.id}\"}]"
      });

      final response = await DioService.get(
        ApiPath.apiMainFolder,
        queryParameters: params,
      );

      if (response != null) {
        List<Item> listFolder = [];
        print(jsonDecode(response));
        List<dynamic> data = jsonDecode(response)["files"];
        for (var element in data) {
          Map<String, dynamic> extractData = element;
          listFolder.add(Item.fromJson(extractData));
        }
        emit(LoadListItemState(listFolder, data.isEmpty));
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
