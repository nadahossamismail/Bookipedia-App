import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/models/file_chat/file_chat_request_body.dart';

import 'package:bookipedia/data_layer/models/file_chat/file_chat_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class FileChatRequest {
  final FileChatRequestBody fileChatRequestBody;
  final dio = DioFactory.getDio();
  FileChatRequest({required this.fileChatRequestBody});

  Future<FileChatResponse> getMoreMessages(
      {int limit = 10, required String createdAt, required File file}) async {
    Response response;

    FileChatResponse fileChatResponse;
    try {
      response = await dio.get(
          //"https://bookipedia-backend-pr-79.onrender.com/ai/chat/663a11ba35a0a4f5c19bd94d?type=document&createdOnBefore=$createdAt&limit=$limit",
          "${ApiEndpoints.fileChat}${file.id}?type=book&createdOnBefore=$createdAt&limit=$limit",
          options: Options(headers: ApiHeaders.tokenHeader));
      fileChatResponse = FileChatResponse.fromJson(response.data);

      return fileChatResponse;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return FileChatResponse.empty(handler.failure.message);
    }
  }

  Future<FileChatResponse> send({required File file}) async {
    Response response;

    FileChatResponse fileChatResponse;
    try {
      response = await dio.get(
          //"https://bookipedia-backend-pr-79.onrender.com/ai/chat/663a11ba35a0a4f5c19bd94d?type=document",
          "${ApiEndpoints.fileChat}${file.id}?type=book",
          //"${ApiEndpoints.fileChat}${fileChatRequestBody.id}?type=${fileChatRequestBody.type}",
          options: Options(headers: ApiHeaders.tokenHeader));
      fileChatResponse = FileChatResponse.fromJson(response.data);

      return fileChatResponse;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return FileChatResponse.empty(handler.failure.message);
    }
  }
}
