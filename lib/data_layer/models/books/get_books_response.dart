import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/models/books/get_user_books_response.dart';

class File {
  final String id;
  final String title;

  File({required this.id, required this.title});
}

class GetBooksResponse {
  final String message;
  final List<Book> books;

  GetBooksResponse({
    required this.message,
    required this.books,
  });
  factory GetBooksResponse.recommendedBooksFromJson(
          Map<String, dynamic> json) =>
      GetBooksResponse(
        message: AppStrings.success,
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
      );
  factory GetBooksResponse.libraryFromJson(Map<String, dynamic> json) =>
      GetBooksResponse(
        message: AppStrings.success,
        books: List<Book>.from(json["Books"].map((x) => Book.fromJson(x))),
      );

  factory GetBooksResponse.empty({message}) =>
      GetBooksResponse(message: message, books: []);
}

class Book extends File {
  final String author;
  final int pages;
  final int chapters;
  final String category;
  final String description;
  final String fileId;
  final String imageUrl;
  final String impageName;
  final bool aiApplied;
  final DateTime createdAt;
  final double recommendation;
  final bool? favourite;

  Book({
    required super.id,
    required super.title,
    required this.author,
    required this.pages,
    required this.chapters,
    required this.category,
    required this.description,
    required this.fileId,
    required this.imageUrl,
    required this.impageName,
    required this.aiApplied,
    required this.createdAt,
    required this.recommendation,
    this.favourite,
  });
  static UserBook toUserBook({required book}) =>
      UserBook(book: book, progressPage: 0, progressPercentage: 0);
  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["_id"],
        title: json["title"],
        author: json["author"],
        pages: json["pages"],
        chapters: json["chapters"],
        category: json["category"],
        description: json["description"],
        fileId: json["file_id"],
        imageUrl: json["image_url"],
        impageName: json["impage_name"],
        aiApplied: json["aiApplied"],
        createdAt: DateTime.parse(json["createdAt"]),
        recommendation: json["recommendation"]?.toDouble(),
        favourite: json["favourite"],
      );
}
