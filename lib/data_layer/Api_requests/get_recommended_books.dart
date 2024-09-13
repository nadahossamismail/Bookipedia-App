import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class GetRecommendedBooksRequest {
  final dio = DioFactory.getDio();

  Future<GetBooksResponse> send() async {
    Response response;
    GetBooksResponse recommendedBooks;

    try {
      response = await dio.get("${ApiEndpoints.recommendedBooks}?count=5",
          options: Options(
            headers: ApiHeaders.tokenHeader,
          ));

      recommendedBooks =
          GetBooksResponse.recommendedBooksFromJson(response.data);

      return recommendedBooks;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return GetBooksResponse.empty(message: handler.failure.message);
    }
  }
}
