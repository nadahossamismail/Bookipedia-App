import 'dart:io';
import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/add_document/add_document_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class AddDocumentRequest {
  final File doc;

  AddDocumentRequest({required this.doc});
  Future<FormData> documentToJson() async {
    final String fileName = doc.path.split('/').last;
    var data = FormData.fromMap({
      'file': await MultipartFile.fromFile(doc.path,
          filename: fileName, contentType: MediaType('application', 'pdf')),
      "type": "application/pdf"
    });
    return data;
  }

  Future<AddDocumentResponse> sendRequest() async {
    final dio = DioFactory.getDio();
    var data = await documentToJson();
    AddDocumentResponse addDocumentResponse;
    try {
      var response = await dio.post(
        ApiEndpoints.addDocument,
        options: Options(headers: ApiHeaders.tokenHeader),
        data: data,
      );

      addDocumentResponse = AddDocumentResponse.fromJson(response.data);
      return addDocumentResponse;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return AddDocumentResponse.empty(handler.failure.message);
    }
  }
}
