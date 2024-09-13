part of 'get_document_file_cubit.dart';

sealed class GetFileState {}

final class GetFileInitial extends GetFileState {}

final class GetFileLoading extends GetFileState {}

final class GetFileCompleted extends GetFileState {
  final Uint8List bytes;
  final File file;
  final int? progressPage;
  GetFileCompleted({
    required this.bytes,
    required this.file,
    this.progressPage,
  });
}

final class GetFileFailure extends GetFileState {
  final String message;
  GetFileFailure(this.message);
}
