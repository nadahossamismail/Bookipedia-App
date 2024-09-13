import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/screens/book_details.dart';
import 'package:bookipedia/presentation_layer/widgets/networkimage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookGrid extends StatelessWidget {
  final List<Book> toBeDisplayedList;
  const BookGrid({super.key, required this.toBeDisplayedList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 18, right: 18, top: 24),
        itemCount: toBeDisplayedList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 0,
            childAspectRatio: 2 / 2.7,
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          Book book = toBeDisplayedList[index];
          return BookUi(book: book);
        });
  }
}

class BookUi extends StatelessWidget {
  final Book book;

  const BookUi({super.key, required this.book});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (_) => BookDetailsView(
                        book: book,
                      )))
              .then((value) => BookCubit.get(context).getAllBooks()),
          child: Hero(
            tag: book.id,
            child: Card(
              elevation: 4,
              child: NetworkImageHandel(imageUrl: book.imageUrl),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 3.2,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              book.title,
              maxLines: 2,
              // style: const TextStyle(letterSpacing: 0.7, color: Colors.white),
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                fontSize: FontSize.f12,
                fontWeight: FontWeight.w500,
              )),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
