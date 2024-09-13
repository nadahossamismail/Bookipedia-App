import 'dart:convert';

import 'package:bookipedia/data_layer/models/books/get_books_response.dart';

AddDocumentResponse addDocumentResponseDartFromJson(String str) =>
    AddDocumentResponse.fromJson(json.decode(str));

class AddDocumentResponse {
  final String message;
  final Document document;

  AddDocumentResponse({
    required this.message,
    required this.document,
  });

  factory AddDocumentResponse.empty(message) => AddDocumentResponse(
        message: message,
        document: Document.empty(),
      );

  factory AddDocumentResponse.fromJson(Map<String, dynamic> json) =>
      AddDocumentResponse(
        message: json["message"],
        document: Document.fromJson(json["document"]),
      );
}

class Document extends File {
  final int progressPage;
  final bool isAiApplied;

  Document(
      {required super.id,
      required super.title,
      required this.progressPage,
      required this.isAiApplied});

  factory Document.empty() =>
      Document(id: "", title: "", progressPage: 0, isAiApplied: false);

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      title: json["title"],
      id: json["_id"],
      progressPage: json["progress_page"],
      isAiApplied: json["aiApplied"]);
}
