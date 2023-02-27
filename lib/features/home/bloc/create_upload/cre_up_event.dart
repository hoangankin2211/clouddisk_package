part of "cre_up_bloc.dart";

abstract class CreateUploadEvent {}

class CreateFolderEvent extends CreateUploadEvent {
  final String force;
  final String name;
  final String parentId;

  CreateFolderEvent({
    required this.force,
    required this.name,
    required this.parentId,
  });
}

class UploadFileEvent extends CreateUploadEvent {
  final String parentId;
  final List<PlatformFile> file;

  UploadFileEvent({
    required this.parentId,
    required this.file,
  });
}
