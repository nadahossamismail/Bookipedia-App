import 'dart:developer';

import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/Api_requests/add_book_to_user_request.dart';
import 'package:bookipedia/data_layer/Api_requests/get_books_request.dart';
import 'package:bookipedia/data_layer/Api_requests/remove_book_from_user_req.dart';
import 'package:bookipedia/data_layer/Api_requests/update_progress.dart';
import 'package:bookipedia/data_layer/models/add_book_to_user.dart/add_book_to_user_response.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/models/books/get_user_books_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'books_operations_state.dart';

class BookCubit extends Cubit<BookOperationState> {
  BookCubit() : super(Initial());

  List<Book> allBooks = [];
  List<UserBook> userBooks = [];

  static BookCubit get(context) => BlocProvider.of(context);

  void getAllBooks() async {
    GetBooksResponse response;
    if (allBooks.isEmpty) {
      emit(BookOperationLoading());
    }

    response = await GetBooksRequest().getLibraryBooks();

    if (response.message == AppStrings.success) {
      allBooks = response.books;

      emit(BookOperationCompleted());
    } else {
      emit(BookOperationFailed(message: response.message));
    }
  }

  void getUserBooks() async {
    GetUserBooksResponse response;
    // if (userBooks.isEmpty) {
    //   emit(LoadingList());
    // }

    emit(LoadingList());
    response = await GetBooksRequest().getUserBooks();

    if (response.message == "success, all user books") {
      userBooks = response.userBooks;

      emit(BookOperationCompleted());
    } else {
      emit(BookOperationFailed(message: response.message));
    }
  }

  void updateProgressPage(
      {required int page, required String id, required String type}) async {
    UpdateProgressResponse response;
    emit(BookOperationLoading());

    response =
        await UpdateProgressRequest(progressPage: page, id: id, type: type)
            .send();
    if (response.message == AppStrings.success) {
      emit(BookOperationCompleted());
    } else {
      emit(BookOperationFailed(message: response.message));
    }
  }

  void addBookToUser(String id) async {
    AddBookToUserResponse response;
    emit(BookOperationLoading());

    response = await AddBookToUserRequest(id).send();
    if (response.message == "Book is added successfully to the user") {
      var addedBook = allBooks.where((book) => book.id == id);

      emit(BookOperationCompleted());
    } else {
      emit(BookOperationFailed(message: response.message));
    }
  }

  void removeBookToUser(String id) async {
    AddBookToUserResponse response;
    emit(BookOperationLoading());

    response = await RemoveBookToUserRequest(id).send();
    if (response.message == "Book is removed successfully from the user") {
      userBooks.removeWhere((book) => book.book.id == id);
      emit(BookOperationCompleted());
    } else {
      emit(BookOperationFailed(message: response.message));
    }
  }
}
