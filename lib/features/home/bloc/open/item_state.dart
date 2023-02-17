import '../../../../model/item.dart';

abstract class ItemState {}

class InitState extends ItemState {}

class LoadingItem extends ItemState {}

class LoadListItemState extends ItemState {
  bool inFolderEmpty;
  List<Item> listItems;
  LoadListItemState(this.listItems, this.inFolderEmpty);
}
