import 'dart:typed_data';
import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/screens/pdf_view/pdf_viewer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer(
      {super.key, required this.bytes, required this.file, required this.page});
  final Uint8List bytes;
  final int page;
  final File file;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfViewerViewModel pdfViewerViewModel;
  late PdfViewerController pdfViewerController;
  final _key = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    pdfViewerController = PdfViewerController();
    pdfViewerController.jumpToPage(widget.page);
    pdfViewerViewModel = PdfViewerViewModel(
        file: widget.file, pdfViewerController, showHighLight: showHighlight);

    super.initState();
  }

  @override
  void dispose() {
    pdfViewerViewModel.dispose();
    pdfViewerController.dispose();

    super.dispose();
  }

  String getTitle() {
    if (widget.file.title.contains(".")) {
      return widget.file.title.substring(0, widget.file.title.length - 4);
    }
    return widget.file.title;
  }

  void showHighlight() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var title = getTitle();
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
              BookCubit.get(context).updateProgressPage(
                  page: pdfViewerController.pageNumber,
                  type: widget.file is Book ? "book" : "document",
                  id: widget.file.id);
            },
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.format_list_bulleted_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  pdfViewerViewModel.pdfViewerKey.currentState
                      ?.openBookmarkView();
                },
              ),
            ),
          ]),
      body: SfPdfViewer.memory(
        widget.bytes,
        onTextSelectionChanged: (details) =>
            pdfViewerViewModel.onSelection(context, details),
        key: pdfViewerViewModel.pdfViewerKey,
        controller: pdfViewerController,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          backgroundColor: ColorManager.primary,
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          fabSize: ExpandableFabSize.small,
        ),
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          backgroundColor: ColorManager.primary,
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
          ),
          fabSize: ExpandableFabSize.regular,
        ),
        key: _key,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.rotate,
        distance: 50,
        overlayStyle: const ExpandableFabOverlayStyle(),
        children: [
          FloatingActionButton.small(
            backgroundColor: ColorManager.primary,
            heroTag: null,
            onPressed: () => pdfViewerViewModel.showSummarizationInput(context),
            child: const Icon(Icons.edit_document, color: Colors.white),
          ),
          FloatingActionButton.small(
            backgroundColor: ColorManager.primary,
            heroTag: null,
            onPressed: () => pdfViewerViewModel.chat(context, showHighlight),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}
