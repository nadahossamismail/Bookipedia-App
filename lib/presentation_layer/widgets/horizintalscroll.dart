import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/widgets/networkimage.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HorizintalScrollList extends StatelessWidget {
  const HorizintalScrollList({
    super.key,
    required this.list,
    this.padding = 10,
    this.listPadding,
  });
  final List<Book> list;
  final double padding;

  final EdgeInsetsGeometry? listPadding;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 3.5,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          width: 15,
        ),
        padding: listPadding,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width / 2.5,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NetworkImageHandel(imageUrl: list[index].imageUrl),
                const MaxGap(10),
                Text(
                  list[index].title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                ),
              ],
            ),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
