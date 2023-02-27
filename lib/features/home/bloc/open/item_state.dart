import '../../../../model/item.dart';

abstract class ItemState {
  final String currentFolder;

  ItemState(this.currentFolder);
}

class InitState extends ItemState {
  InitState(super.currentFolder);
}

class LoadingItem extends ItemState {
  LoadingItem(super.currentFolder);
}

class LoadListItemState extends ItemState {
  bool inFolderEmpty;
  List<Item> listItems;
  LoadListItemState(this.listItems, this.inFolderEmpty, super.currentFolder);
}
