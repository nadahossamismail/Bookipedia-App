import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/Api_requests/file_chat_request.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/models/file_chat/file_chat_request_body.dart';
import 'package:bookipedia/data_layer/models/file_chat/file_chat_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'file_chat_state.dart';

class FileChatCubit extends Cubit<FileChatState> {
  FileChatCubit() : super(FileChatInitial());
  static FileChatCubit get(context) => BlocProvider.of(context);

  List<Datum> messages = [];
  bool isAnimatingResponse = true;
  void getMoreMessages(
      {required File file,
      required String createdAt,
      required FileChatRequestBody fileChatRequestBody}) async {
    FileChatResponse response;

    emit(FileChatLoadingMoreMessages());

    response = await FileChatRequest(fileChatRequestBody: fileChatRequestBody)
        .getMoreMessages(createdAt: createdAt, file: file);

    if (response.message == AppStrings.success) {
      messages.addAll(response.data);
      emit(FileChatCompleted());
    } else {
      emit(FileChatFailure(message: response.message));
    }
  }

  void sendRequest(
      {required FileChatRequestBody fileChatRequestBody,
      required File file}) async {
    FileChatResponse response;

    emit(FileChatLoading());

    response = await FileChatRequest(fileChatRequestBody: fileChatRequestBody)
        .send(file: file);

    if (response.message == AppStrings.success) {
      messages = response.data;

      emit(FileChatCompleted());
    } else {
      emit(FileChatFailure(message: response.message));
    }
  }
}
