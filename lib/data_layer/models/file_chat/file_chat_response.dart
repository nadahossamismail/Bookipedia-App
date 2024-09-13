import 'dart:convert';

FileChatResponse fileChatResponseFromJson(String str) =>
    FileChatResponse.fromJson(json.decode(str));

String fileChatResponseToJson(FileChatResponse data) =>
    json.encode(data.toJson());

class FileChatResponse {
  final String message;
  final List<Datum> data;

  FileChatResponse({
    required this.message,
    required this.data,
  });
  factory FileChatResponse.empty(message) =>
      FileChatResponse(message: message, data: []);

  factory FileChatResponse.fromJson(Map<String, dynamic> json) =>
      FileChatResponse(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String question;
  String answer;
  Sources sources;
  String? createdAt;
  int? index;

  Datum(
      {this.createdAt,
      required this.question,
      required this.answer,
      required this.sources,
      this.index});
  factory Datum.empty() =>
      Datum(createdAt: "", question: "", answer: "", sources: Sources.empty());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        question: json["question"],
        createdAt: json["createdAt"],
        answer: json["answer"],
        sources: Sources.fromJson(json["sources"]),
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "createdAt": createdAt,
        "sources": sources.toJson(),
      };
}

class Sources {
  final List<DocSource> docSources;
  final List<String> webSources;

  Sources({
    required this.docSources,
    required this.webSources,
  });
  factory Sources.empty() => Sources(docSources: [], webSources: []);

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        docSources: List<DocSource>.from(
            json["doc_sources"].map((x) => DocSource.fromJson(x))),
        webSources: List<String>.from(json["web_sources"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "doc_sources": List<dynamic>.from(docSources.map((x) => x.toJson())),
        "web_sources": List<dynamic>.from(webSources.map((x) => x)),
      };
}

class DocSource {
  final String docId;
  final int pageNo;
  final String text;

  DocSource({
    required this.docId,
    required this.pageNo,
    required this.text,
  });

  factory DocSource.fromJson(Map<String, dynamic> json) => DocSource(
        docId: json["doc_id"],
        pageNo: json["page_no"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "doc_id": docId,
        "page_no": pageNo,
        "text": text,
      };
}
