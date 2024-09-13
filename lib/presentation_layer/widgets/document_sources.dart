import 'dart:developer';

import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/data_layer/models/file_chat/file_chat_response.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentSources extends StatelessWidget {
  final PdfViewerController pdfViewerController;
  final Function showHighlight;
  final List<DocSource> docSources;
  const DocumentSources(
      {super.key,
      required this.pdfViewerController,
      required this.showHighlight,
      required this.docSources});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3,
            mainAxisSpacing: 10,
            mainAxisExtent: 30),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: docSources.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              var searchResult = pdfViewerController.searchText("Every JWT");

              //pdfViewerController.jumpToPage(docSources[index].pageNo);
              Navigator.pop(context);

              searchResult.addListener(() {
                if (searchResult.hasResult && searchResult.isSearchCompleted) {
                  log("show");
                  showHighlight();
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  // color: const Color.fromARGB(255, 230, 236, 241),
                  color: ColorManager.cardColor,
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                "Page: ${docSources[index].pageNo.toString()}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }));
  }
}
