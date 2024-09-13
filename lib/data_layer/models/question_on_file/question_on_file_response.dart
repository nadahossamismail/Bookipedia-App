import 'dart:convert';

import 'package:bookipedia/data_layer/models/file_chat/file_chat_response.dart';

QuestionSources sourcesFromJson(String str) =>
    QuestionSources.fromJson(json.decode(str));

String sourcesToJson(QuestionSources data) => json.encode(data.toJson());

class QuestionSources {
  final Sources sources;

  QuestionSources({
    required this.sources,
  });

  factory QuestionSources.fromJson(Map<String, dynamic> json) =>
      QuestionSources(
        sources: Sources.fromJson(json["sources"]),
      );

  Map<String, dynamic> toJson() => {
        "sources": sources.toJson(),
      };
}
