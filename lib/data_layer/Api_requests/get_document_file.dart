import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/get_doc_file/get_doc_file_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class GetDocumentFileRequest {
  final String id;
  final dio = DioFactory.getDio();

  GetDocumentFileRequest(this.id);

  Future<GetFileResponse> send() async {
    Response response;
    GetFileResponse getDocumentFileResponse;

    try {
      response = await dio.get("${ApiEndpoints.getDocumentFile}$id",
          options: Options(
              headers: ApiHeaders.tokenHeader,
              responseType: ResponseType.bytes));

      getDocumentFileResponse = GetFileResponse(bytes: response.data);

      return getDocumentFileResponse;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return GetFileResponse.empty(message: handler.failure.message);
    }
  }
}
