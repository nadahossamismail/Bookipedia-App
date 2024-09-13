import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:dio/dio.dart';

class GetRecentActivityRequest {
  final dio = DioFactory.getDio();

  Future<RecentActivity> send() async {
    Response response;
    RecentActivity recentActivity;

    try {
      response = await dio.get(ApiEndpoints.recentActivity,
          options: Options(
            headers: ApiHeaders.tokenHeader,
          ));

      recentActivity = RecentActivity.fromJson(response.data);

      return recentActivity;
    } catch (error) {
      var handler = ErrorHandler.handle(error);
      return RecentActivity.empty(message: handler.failure.message);
    }
  }
}

class RecentActivity {
  final String status;
  final List<Datum> data;

  RecentActivity({
    required this.status,
    required this.data,
  });
  factory RecentActivity.empty({message}) =>
      RecentActivity(status: message, data: []);
  factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  final String id;
  final String? title;
  final bool? aiApplied;
  final int progressPage;
  final String type;
  final Book? book;
  final int? bookPages;
  final double? progressPercentage;

  Datum({
    required this.id,
    this.title,
    this.aiApplied,
    required this.progressPage,
    required this.type,
    this.book,
    this.bookPages,
    this.progressPercentage,
  });
  factory Datum.empty() => Datum(id: "", progressPage: 0, type: "");
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        aiApplied: json["aiApplied"],
        progressPage: json["progress_page"],
        type: json["type"],
        book: json["book"] == null ? null : Book.fromJson(json["book"]),
        bookPages: json["book_pages"],
        progressPercentage: json["progress_percentage"]?.toDouble(),
      );
}
