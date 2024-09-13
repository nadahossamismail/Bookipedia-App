import 'dart:convert';

import 'package:bookipedia/data_layer/models/books/get_books_response.dart';

GetUserBooksResponse getUserBooksResponseFromJson(String str) =>
    GetUserBooksResponse.fromJson(json.decode(str));

class GetUserBooksResponse {
  final String message;
  final List<UserBook> userBooks;

  GetUserBooksResponse({
    required this.message,
    required this.userBooks,
  });
  factory GetUserBooksResponse.empty({message}) =>
      GetUserBooksResponse(message: message, userBooks: []);

  factory GetUserBooksResponse.fromJson(Map<String, dynamic> json) =>
      GetUserBooksResponse(
        message: json["message"],
        userBooks: List<UserBook>.from(
            json["userBooks"].map((x) => UserBook.fromJson(x))),
      );
}

class UserBook {
  final Book book;
  final int progressPage;
  final double progressPercentage;

  UserBook({
    required this.book,
    required this.progressPage,
    required this.progressPercentage,
  });

  factory UserBook.fromJson(Map<String, dynamic> json) => UserBook(
        book: Book.fromJson(json["book"]),
        progressPage: json["progress_page"],
        progressPercentage: json["progress_percentage"].toDouble(),
      );
}
