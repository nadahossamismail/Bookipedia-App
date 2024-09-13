import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/cubits/delete_document/delete_document_cubit.dart';
import 'package:bookipedia/cubits/get_document_file/get_document_file_cubit.dart';
import 'package:bookipedia/cubits/user_document/user_document_cubit.dart';
import 'package:bookipedia/cubits/user_document/user_document_state.dart';
import 'package:bookipedia/cubits/documents_list/document_list_cubit.dart';
import 'package:bookipedia/presentation_layer/screens/pdf_view/pdf_viewer.dart';
import 'package:bookipedia/presentation_layer/screens/user_document/user_doc_viewmodel.dart';
import 'package:bookipedia/presentation_layer/widgets/snack_bar.dart';
import 'package:bookipedia/presentation_layer/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDocumentScreen extends StatefulWidget {
  const UserDocumentScreen({super.key});

  @override
  State<UserDocumentScreen> createState() => _UserDocumentScreenState();
}

class _UserDocumentScreenState extends State<UserDocumentScreen> {
  UserDocsViewModel userDocsViewModel = UserDocsViewModel();
  @override
  void initState() {
    // if (DocumentListCubit.get(context).documentList.isEmpty) {
    //   DocumentListCubit.get(context).sendRequest();
    // }
    DocumentListCubit.get(context).sendRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<DocumentListCubit, DocumentListState>(
              listener: (context, state) {
            state is DocumentListFailure
                ? SomethingWentWrong(
                    onPressed: () =>
                        DocumentListCubit.get(context).sendRequest())
                : null;
          }),
          BlocListener<UserDocumentCubit, UserDocumentState>(
              listener: (context, state) {
            if (state is UserDocumentDone) {
              DocumentListCubit.get(context).sendRequest();
            } else if (state is UserDocumentFailed) {
              AppSnackBar.showSnackBar(context, state.message);
            }
          }),
          BlocListener<GetFileCubit, GetFileState>(listener: (context, state) {
            if (state is GetFileCompleted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PdfViewer(
                            page: state.progressPage!,
                            bytes: state.bytes,
                            file: state.file,
                          )));
            } else if (state is GetFileFailure) {
              AppSnackBar.showSnackBar(context, state.message);
            } else {
              // AppSnackBar.showSnackBar(context, "opening ...");
            }
          }),
          BlocListener<DeleteDocumentCubit, DeleteDocumentState>(
            listener: (context, state) =>
                userDocsViewModel.deleteDocumentListener(context, state),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Documents"),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                    onPressed: () =>
                        UserDocumentCubit.get(context).pickDocument(),
                    icon: Icon(
                      Icons.add,
                      color: ColorManager.primaryLighter,
                      size: 28,
                    )),
              )
              // Padding(
              //   padding: const EdgeInsets.only(right: 16.0),
              //   child: IconButton(
              //       onPressed: () async {
              //         var dio = DioFactory.getDio();
              //         var fileName = "flutter.pdf";
              //         await dio.download(
              //             "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
              //             "/storage/emulated/0/Download/$fileName");
              //         print("downloaded");
              //       },
              //       icon: const Icon(Icons.download)),
              // )
            ],
          ),
          body: Builder(builder: (context) {
            var userDocumentState = context.watch<UserDocumentCubit>().state;
            var documentListState = context.watch<DocumentListCubit>().state;
            var deleteDocState = context.watch<DeleteDocumentCubit>().state;

            return userDocsViewModel.viewBody(
                context: context,
                userDocumentState: userDocumentState,
                documentListState: documentListState,
                deleteDocumentState: deleteDocState);
          }),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => UserDocumentCubit.get(context).pickDocument(),
          //   backgroundColor: ColorManager.primary,
          //   shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(24))),
          //   child: const Icon(Icons.add, size: 25, color: Colors.white),
          // ),
        ));
  }
}
