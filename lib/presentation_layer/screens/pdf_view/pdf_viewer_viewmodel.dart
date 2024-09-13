import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/cubits/file_chat/file_chat_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/screens/chat.dart';
import 'package:bookipedia/presentation_layer/screens/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerViewModel {
  OverlayEntry? _overlayEntry;
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  TextEditingController messageController = TextEditingController();
  final File file;
  final PdfViewerController pdfViewerController;
  final TextEditingController startPageController = TextEditingController();
  final TextEditingController endPageController = TextEditingController();
  final Function() showHighLight;

  PdfViewerViewModel(this.pdfViewerController,
      {required this.file, required this.showHighLight});

  void dispose() {
    messageController.dispose();
    startPageController.dispose();
    endPageController.dispose();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: details.globalSelectedRegion!.center.dy - 55,
            left: details.globalSelectedRegion!.bottomLeft.dx,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: ColorManager.cardColor),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        chat(context, showHighLight);
                        messageController.text =
                            "Excerpt: \"${details.selectedText!}\"";
                        pdfViewerController.clearSelection();
                      },
                      icon: const Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        textToSpeech(context, details.selectedText);
                      },
                      icon: const Icon(
                        Icons.spatial_audio_off,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        chat(context, showHighLight);
                        messageController.text =
                            "Summarize: \"${details.selectedText!}\"";
                        pdfViewerController.clearSelection();
                      },
                      icon: const Icon(
                        Icons.edit_document,
                        color: Colors.white,
                      ))
                ],
              ),
            )));
    overlayState.insert(_overlayEntry!);
  }

  void textToSpeech(context, text) async {
    pdfViewerController.clearSelection();
    Navigator.push(
        context,
        ModalBottomSheetRoute(
            isDismissible: false,
            modalBarrierColor: Colors.grey.withOpacity(0.3),
            useSafeArea: true,
            builder: (_) => TextToSpeech(text: text),
            isScrollControlled: false));
  }

  void onSelection(context, PdfTextSelectionChangedDetails details) {
    if (details.selectedText == null && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else if (details.selectedText != null && _overlayEntry == null) {
      _showContextMenu(context, details);
    }
  }

  void showSummarizationInput(context) {
    showModalBottomSheet(
      barrierColor: Colors.grey.withOpacity(0.4),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      context: context,
      builder: (_) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(alignment: WrapAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacingSizing.s32,
                  bottom: AppSpacingSizing.s16,
                  left: AppSpacingSizing.s16,
                  right: AppSpacingSizing.s16),
              child: Text(
                "Select the range of summarization",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: FontSize.f18, color: Colors.white)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: startPageController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary)),
                      focusColor: ColorManager.primary,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      constraints:
                          const BoxConstraints(maxWidth: AppSpacingSizing.s64),
                      hintText: "start",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacingSizing.s24),
                  child: Text(
                    "to",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: FontSize.f18)),
                  ),
                ),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: endPageController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary)),
                      focusColor: ColorManager.primary,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      constraints:
                          const BoxConstraints(maxWidth: AppSpacingSizing.s64),
                      hintText: "end",
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacingSizing.s32),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(ColorManager.primary)),
                    onPressed: () {
                      summarize(context);
                    },
                    child: const Text(
                      "Summarize",
                      style: TextStyle(color: Colors.white),
                    )))
          ]),
        );
      },
    );
  }

  summarize(context) {
    Navigator.pop(context);
    chat(context, showHighLight);
    messageController.text =
        "Summarize from page ${startPageController.text} to page ${endPageController.text} ";
    pdfViewerController.clearSelection();
  }

  void chat(context, showHighlight) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => FileChatCubit(),
            child: ChatView(
                file: file,
                show: showHighlight,
                pdfViewerController: pdfViewerController,
                messageController: messageController),
          ),
        ));
  }
}
