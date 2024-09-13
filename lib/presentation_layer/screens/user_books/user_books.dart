import 'dart:developer';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_user_books_response.dart';
import 'package:bookipedia/presentation_layer/widgets/empty_list.dart';
import 'package:bookipedia/presentation_layer/widgets/loading.dart';
import 'package:bookipedia/presentation_layer/widgets/something_went_wrong.dart';
import 'package:bookipedia/presentation_layer/widgets/user_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBooksView extends StatefulWidget {
  const UserBooksView({super.key});

  @override
  State<UserBooksView> createState() => _UserBooksViewState();
}

class _UserBooksViewState extends State<UserBooksView> {
  //late List<UserBook> userBooks;
  List<UserBook> userBooks = [];
  @override
  void initState() {
    // if (BookCubit.get(context).userBooks.isEmpty) {
    //   BookCubit.get(context).getUserBooks();
    // }
    BookCubit.get(context).getUserBooks();

    // userBooks = BookCubit.get(context).userBooks;
    log("userBooks ${userBooks.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookCubit, BookOperationState>(
      listener: (context, state) {
        if (state is BookOperationCompleted) {
          setState(() {
            userBooks = BookCubit.get(context).userBooks;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Bookshelf",
                style: TextStyle(letterSpacing: 0.7),
              ),
            ),
            body: state is LoadingList
                ? const Loading()
                : state is BookOperationFailed
                    ? SomethingWentWrong(
                        onPressed: () => BookCubit.get(context).getUserBooks())
                    : userBooks.isEmpty
                        ? const EmptyList(
                            text: "Pick some books from the library")
                        : UserBooksList(userBooks: userBooks));
      },
    );
  }
}
