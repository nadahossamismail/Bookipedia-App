part of 'books_operations_cubit.dart';

sealed class BookOperationState {}

final class Initial extends BookOperationState {}

final class BookOperationLoading extends BookOperationState {}

final class LoadingList extends BookOperationState {}

final class BookOperationFailed extends BookOperationState {
  final String? message;

  BookOperationFailed({required this.message});
}

final class BookOperationCompleted extends BookOperationState {}
