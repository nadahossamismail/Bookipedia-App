import 'dart:developer';

import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/widgets/book_grid.dart';
import 'package:bookipedia/presentation_layer/widgets/empty_list.dart';
import 'package:bookipedia/presentation_layer/widgets/loading.dart';
import 'package:bookipedia/presentation_layer/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  // late List<Book> booksList;
  List<Book> booksList = [];
  List<Book> filteredList = [];
  bool isSearching = false;
  late TextEditingController searchingController;
  @override
  void initState() {
    if (BookCubit.get(context).allBooks.isEmpty) {
      BookCubit.get(context).getAllBooks();
      log("in if");
    } else {
      booksList = BookCubit.get(context).allBooks;
      log("in else");
    }

    // BookCubit.get(context).getAllBooks();
    searchingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchClearIcon =
        isSearching ? const Icon(Icons.clear) : const Icon(Icons.search);
    var toBeDisplayedList =
        searchingController.text.isEmpty ? booksList : filteredList;

    return BlocConsumer<BookCubit, BookOperationState>(
      listener: (context, state) {
        if (state is BookOperationCompleted) {
          setState(() {
            log("in set state");
            booksList = BookCubit.get(context).allBooks;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: isSearching ? searchInputField() : const Text("Library"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacingSizing.s16),
                  child: IconButton(
                      onPressed: () => search(), icon: searchClearIcon),
                )
              ],
            ),
            body: state is BookOperationLoading
                ? const Loading()
                : state is BookOperationFailed
                    ? SomethingWentWrong(
                        onPressed: () => BookCubit.get(context).getAllBooks())
                    : toBeDisplayedList.isEmpty
                        ? const EmptyList(text: "No Results")
                        : BookGrid(toBeDisplayedList: toBeDisplayedList));
      },
    );
  }

  Widget searchInputField() {
    return TextField(
      controller: searchingController,
      keyboardAppearance: Brightness.dark,
      showCursor: true,
      decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(
            letterSpacing: 0.7,
            fontSize: 18,
          ),
          border: InputBorder.none,
          hintFadeDuration: Duration(milliseconds: 400)),
      onChanged: (value) => filterBooks(value),
    );
  }

  void filterBooks(String searchPrompt) {
    setState(() {
      filteredList = booksList
          .where((book) =>
              book.title.toLowerCase().contains(searchPrompt.toLowerCase()))
          .toList();
    });
  }

  void search() {
    if (isSearching) {
      clearSearchBar();
    } else {
      showSearchBar();
    }
  }

  void clearSearchBar() {
    searchingController.clear();
    filteredList.clear;
    setState(() {
      filteredList.addAll(booksList);
    });
  }

  void showSearchBar() {
    setState(() {
      isSearching = true;
    });
    ModalRoute.of(context)!.addLocalHistoryEntry(
        LocalHistoryEntry(onRemove: () => closeSearchBar()));
  }

  void closeSearchBar() {
    searchingController.clear();
    filteredList.clear;
    setState(() {
      filteredList.addAll(booksList);
      isSearching = false;
    });
  }
}
