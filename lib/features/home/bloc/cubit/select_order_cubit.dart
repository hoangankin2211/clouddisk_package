import 'package:flutter_bloc/flutter_bloc.dart';

enum Order {
  ascending("asc"),
  descending("desc");

  final String id;
  const Order(this.id);
}

class SelectOrderCubit extends Cubit<Order> {
  SelectOrderCubit(super.initialState);

  void onSelected(Order type) {
    emit(type);
  }
}
