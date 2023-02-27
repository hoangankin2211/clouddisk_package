import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/item.dart';

class NavigatePageCubit extends Cubit<NavigateState> {
  NavigatePageCubit() : super(InitNavigateState());

  void push(Item item) {
    emit(PushState(item: item));
  }

  void pop() {
    emit(PopState());
  }

  void pushAndRemoveUntil(Item item) {
    emit(PushAndRemoveUntilState(item: item));
  }

  void popUntil(String id) {
    emit(PopUntil(item: id));
  }
}

abstract class NavigateState {
  NavigateState();
}

class InitNavigateState extends NavigateState {
  InitNavigateState();
}

class PushState extends NavigateState {
  final Item item;

  PushState({required this.item});
}

class PushAndRemoveUntilState extends NavigateState {
  final Item item;

  PushAndRemoveUntilState({required this.item});
}

class PopState extends NavigateState {
  PopState();
}

class PopUntil extends NavigateState {
  final String item;
  PopUntil({required this.item});
}
