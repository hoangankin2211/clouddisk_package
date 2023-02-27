part of "cre_up_bloc.dart";

enum CreateUploadStatus {
  init,
  handling,
  success,
  fail,
}

class CreateUploadState {
  final CreateUploadStatus status;
  final List<ICreateUploadResopnse> response;

  CreateUploadState._(this.status, {this.response = const []});

  CreateUploadState.init() : this._(CreateUploadStatus.init);
  CreateUploadState.handling() : this._(CreateUploadStatus.handling);

  CreateUploadState.success({required List<ICreateUploadResopnse> response})
      : this._(CreateUploadStatus.success, response: response);
  CreateUploadState.fail() : this._(CreateUploadStatus.fail);
}
