import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/cubits/get_document_file/get_document_file_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_user_books_response.dart';
import 'package:bookipedia/presentation_layer/screens/pdf_view/pdf_viewer.dart';
import 'package:bookipedia/presentation_layer/widgets/custom_list_tile.dart';
import 'package:bookipedia/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class UserBooksList extends StatelessWidget {
  final List<UserBook> userBooks;
  const UserBooksList({super.key, required this.userBooks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
              height: AppSpacingSizing.s16,
            ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingSizing.s16, vertical: AppSpacingSizing.s24),
        itemCount: userBooks.length,
        itemBuilder: (context, index) {
          var book = userBooks[index];
          return BlocListener<GetFileCubit, GetFileState>(
            listener: (context, state) {
              state is GetFileCompleted
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PdfViewer(
                              page: userBooks[index].progressPage,
                              bytes: state.bytes,
                              file: userBooks[index].book)))
                  : state is GetFileLoading
                      ? AppSnackBar.showSnackBar(
                          context, "This might take a few seconds")
                      : null;
            },
            child: GestureDetector(
              onTap: () {
                GetFileCubit.get(context).getBook(userBooks[index].book);
              },
              child: BookTile(
                useTrailing: true,
                book: book,
              ),
            ),
          );
        });
  }
}

class BookTile extends StatelessWidget {
  final UserBook book;
  final bool useTrailing;
  const BookTile({super.key, required this.book, required this.useTrailing});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      tileColor: Theme.of(context).listTileTheme.tileColor,
      useTrailing: useTrailing,
      height: MediaQuery.sizeOf(context).height / 8.7,
      trailing: useTrailing
          ? PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete_outline_outlined,
                          ),
                          Text("Remove"),
                        ],
                      ),
                      onTap: () {
                        BookCubit.get(context).removeBookToUser(book.book.id);
                      },
                    )
                  ])
          : null,
      subTitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("By: ${book.book.author}"),
          SizedBox(
            height: book.progressPercentage.toDouble() == 0.0 ? 7 : 10,
          ),
          book.progressPercentage.toDouble() == 0.0
              ? Text("${book.book.pages} pages")
              : LinearPercentIndicator(
                  width: MediaQuery.sizeOf(context).width / 4.5,
                  animateFromLastPercent: true,
                  progressColor: ColorManager.primary,
                  percent: book.progressPercentage.toDouble(),
                  padding: const EdgeInsets.symmetric(),
                  animation: true,
                ),
        ],
      ),
      title: Text(
          book.book.author.replaceFirst(
              book.book.title[0], book.book.title[0].toUpperCase()),
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.7)),
      leading: Material(
        elevation: 3,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(book.book.imageUrl),
            width: MediaQuery.sizeOf(context).width / 4.8,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
