import '../../../model/get_link_response.dart';

abstract class GetlinkState {}

class InitGetlinkState extends GetlinkState {
  int downCount;
  DateTime selectedDateTime;
  InitGetlinkState({this.downCount = 100, required this.selectedDateTime});
}

class GettingShareLink extends GetlinkState {}

class ExposeLinkState extends GetlinkState {
  List<GetLinkResponse> linkResponse;

  ExposeLinkState(this.linkResponse);
}

class SelectTimeState extends GetlinkState {
  DateTime selectedDateTime;
  SelectTimeState(this.selectedDateTime);
}
