import 'package:flutter_bloc/flutter_bloc.dart';

enum SortType {
  size("size"),
  fileName("name"),
  date("date");

  final String id;
  const SortType(this.id);
}

class SelectSortCubit extends Cubit<SortType> {
  SelectSortCubit(super.initialState);

  void onSelected(SortType type) {
    emit(type);
  }
}
