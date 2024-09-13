import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/models/books/get_user_books_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class GetBooksRequest {
  final dio = DioFactory.getDio();

  Future<GetBooksResponse> getLibraryBooks() async {
    Response response;
    GetBooksResponse getBooksResponse;
    try {
      response = await dio.get(ApiEndpoints.getAllBooks,
          options: Options(headers: ApiHeaders.tokenHeader));

      getBooksResponse = GetBooksResponse.libraryFromJson(response.data);

      return getBooksResponse;
    } catch (error) {
      var failure = ErrorHandler.handle(error).failure;
      return GetBooksResponse.empty(message: failure.message);
    }
  }

  Future<GetUserBooksResponse> getUserBooks() async {
    Response response;
    GetUserBooksResponse getUserBooksResponse;
    try {
      response = await dio.get(ApiEndpoints.userBooks,
          options: Options(headers: ApiHeaders.tokenHeader));

      getUserBooksResponse = GetUserBooksResponse.fromJson(response.data);

      return getUserBooksResponse;
    } catch (error) {
      var failure = ErrorHandler.handle(error).failure;
      return GetUserBooksResponse.empty(message: failure.message);
    }
  }
}
