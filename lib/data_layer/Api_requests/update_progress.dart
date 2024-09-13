import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class UpdateProgressRequest {
  final int progressPage;
  final String id;
  final String type;
  final dio = DioFactory.getDio();

  UpdateProgressRequest(
      {required this.progressPage, required this.id, required this.type});

  Future<UpdateProgressResponse> send() async {
    Response response;

    UpdateProgressResponse updateProgressResponse;
    try {
      response = await dio.patch(
          ApiEndpoints.updateProgressPage
              .replaceFirst("id", id)
              .replaceFirst("file", type),
          data: {"page": progressPage},
          options: Options(headers: ApiHeaders.tokenHeader));
      updateProgressResponse = UpdateProgressResponse.fromJson(response.data);

      return updateProgressResponse;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return UpdateProgressResponse.empty(message: handler.failure.message);
    }
  }
}

class UpdateProgressResponse {
  final String status;
  final String message;
  final int progressPage;

  UpdateProgressResponse({
    required this.status,
    required this.message,
    required this.progressPage,
  });

  factory UpdateProgressResponse.empty({message}) => UpdateProgressResponse(
        status: AppStrings.failure,
        message: message,
        progressPage: 0,
      );

  factory UpdateProgressResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProgressResponse(
        status: json["status"],
        message: AppStrings.success,
        progressPage: json["progress_page"],
      );
}
