import '../../../model/get_link_response.dart';

abstract class GetlinkState {}

class InitGetlinkState extends GetlinkState {
  int downCount;
  DateTime selectedDateTime;
  InitGetlinkState({this.downCount = 100, required this.selectedDateTime});
}

class GettingShareLink extends GetlinkState {}

class ExposeLinkState extends GetlinkState {
  final List<GetLinkResponse> linkResponse;
  final int downCount;
  final DateTime selectedDateTime;
  ExposeLinkState({
    required this.linkResponse,
    required this.downCount,
    required this.selectedDateTime,
  });
}

class SelectTimeState extends GetlinkState {
  DateTime selectedDateTime;
  SelectTimeState(this.selectedDateTime);
}
