import '../../../model/item.dart';

abstract class GetlinkEvent {}

class SelectDateTime extends GetlinkEvent {
  final DateTime selectedDateTime;

  SelectDateTime(this.selectedDateTime);
}

class ShareLinkEvent extends GetlinkEvent {
  final int downCount;
  final DateTime selectedDateTime;
  List<Item> items;
  ShareLinkEvent(
      {required this.items,
      required this.selectedDateTime,
      this.downCount = 100});
}
