import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/item.dart';

class ListFileCubit extends Cubit<List<Item>> {
  ListFileCubit() : super([]);

  void addNewItem(Item item) {
    state.add(item);
    emit(state.toList());
  }

  void removeItem(Item item) {
    state.removeWhere((element) => element.id == item.id);
    emit(state.toList());
  }
}
