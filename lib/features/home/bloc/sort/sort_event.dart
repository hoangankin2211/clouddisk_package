import '../../../../model/item.dart';

abstract class SortEvent {
  List<Item> items;
  SortEvent(this.items);
}

class SortByNameEvent extends SortEvent {
  SortByNameEvent(super.items);
}

class SortBySizeEvent extends SortEvent {
  SortBySizeEvent(super.items);
}

class SortByTypeEvent extends SortEvent {
  SortByTypeEvent(super.items);
}

class SortAscending extends SortEvent {
  SortAscending(super.items);
}

class SortDescending extends SortEvent {
  SortDescending(super.items);
}
