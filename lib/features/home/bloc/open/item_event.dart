// ignore: file_names
import '../../../../model/item.dart';
import '../cubit/select_order_cubit.dart';
import '../cubit/select_sort_cubit.dart';

abstract class ItemEvent {}

class OpenFolder extends ItemEvent {
  String id;
  int start;
  List<Item> currentList;
  OpenFolder({
    required this.id,
    required this.start,
    required this.currentList,
  });
}

class OpenMainFolderEvent extends ItemEvent {}

class SortItemEvent extends ItemEvent {
  SortType sortType;
  Order order;
  String folderId;
  SortItemEvent(this.folderId, this.order, this.sortType);
}
