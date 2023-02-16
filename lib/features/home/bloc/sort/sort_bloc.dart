import 'package:clouddisk/features/home/bloc/sort/sort_event.dart';
import 'package:clouddisk/features/home/bloc/sort/sort_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc() : super(InitSortState()) {
    on((event, emit) => null);
  }
}
