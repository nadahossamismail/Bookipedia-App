part of 'file_chat_cubit.dart';

sealed class FileChatState {}

final class FileChatInitial extends FileChatState {}

final class FileChatLoading extends FileChatState {}

final class FileChatLoadingMoreMessages extends FileChatState {}

final class FileChatCompleted extends FileChatState {}

final class FileChatFailure extends FileChatState {
  final String message;

  FileChatFailure({required this.message});
}
