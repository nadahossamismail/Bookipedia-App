import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/add_book_to_user.dart/add_book_to_user_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class RemoveBookToUserRequest {
  final String id;
  final dio = DioFactory.getDio();

  RemoveBookToUserRequest(this.id);

  Future<AddBookToUserResponse> send() async {
    Response response;
    AddBookToUserResponse addBookToUserResponse;
    try {
      response = await dio.delete(
          ApiEndpoints.removeBookFromUser.replaceFirst("id", id),
          options: Options(headers: ApiHeaders.tokenHeader));
      addBookToUserResponse = AddBookToUserResponse.fromJson(response.data);

      return addBookToUserResponse;
    } catch (error) {
      var failure = ErrorHandler.handle(error).failure;
      return AddBookToUserResponse.empty(message: failure.message);
    }
  }
}
