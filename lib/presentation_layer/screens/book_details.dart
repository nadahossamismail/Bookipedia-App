import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/cubits/get_document_file/get_document_file_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/screens/pdf_view/pdf_viewer.dart';
import 'package:bookipedia/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsView extends StatefulWidget {
  final Book book;
  final ScrollController? scrollController;
  const BookDetailsView({super.key, required this.book, this.scrollController});

  @override
  State<BookDetailsView> createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  late bool isFavorite;
  @override
  void initState() {
    isFavorite = widget.book.favourite!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.book.id,
                child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 4,
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 231, 226, 226),
                            borderRadius: BorderRadius.circular(12)),
                        child: Image.network(
                          widget.book.imageUrl,
                          filterQuality: FilterQuality.medium,
                          height: MediaQuery.sizeOf(context).height / 4,
                        ))),
              ),
            ),
            Text(
              widget.book.title.replaceFirstMapped(widget.book.title[0],
                  (match) => widget.book.title[0].toUpperCase()),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7),
            ),
            Text("By: ${widget.book.author}",
                style: const TextStyle(
                  fontSize: 14,
                )),
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacingSizing.s16,
                bottom: AppSpacingSizing.s12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      BlocListener<GetFileCubit, GetFileState>(
                        listener: (context, state) {
                          state is GetFileCompleted
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PdfViewer(
                                          page: 0,
                                          bytes: state.bytes,
                                          file: widget.book)))
                              : state is GetFileLoading
                                  ? AppSnackBar.showSnackBar(
                                      context, "This might take a few seconds")
                                  : null;
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            GetFileCubit.get(context).getBook(widget.book);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(
                                  side: BorderSide(width: 1.4)),
                              // backgroundColor:
                              //     const Color.fromARGB(255, 37, 36, 36)
                              backgroundColor: ColorManager.cardColor),
                          child: const Icon(Icons.auto_stories,
                              color: Colors.white),
                        ),
                      ),
                      const Text("Read")
                    ],
                  ),
                  Column(
                    children: [
                      BlocConsumer<BookCubit, BookOperationState>(
                        listener: (context, state) {
                          if (state is BookOperationCompleted) {}
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              isFavorite
                                  ? BookCubit.get(context)
                                      .removeBookToUser(widget.book.id)
                                  : BookCubit.get(context)
                                      .addBookToUser(widget.book.id);

                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.cardColor,
                              shape: const CircleBorder(
                                  side: BorderSide(width: 1.1)),
                            ),
                            child: isFavorite
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                  )
                                : const Icon(
                                    Icons.favorite_outline,
                                    color: Colors.white,
                                  ),
                          );
                        },
                      ),
                      const Text("save")
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              indent: AppSpacingSizing.s12,
              endIndent: AppSpacingSizing.s12,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacingSizing.s16),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.15,
                child: Text(
                  widget.book.description.replaceAll("\n", " "),
                  style: const TextStyle(fontSize: FontSize.f16),
                  textAlign: TextAlign.justify,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
