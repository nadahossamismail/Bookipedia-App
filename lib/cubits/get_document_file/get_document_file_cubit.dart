import 'dart:typed_data';
import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/Api_requests/get_book_file_request.dart';
import 'package:bookipedia/data_layer/Api_requests/get_document_file.dart';
import 'package:bookipedia/data_layer/models/add_document/add_document_response.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/models/get_doc_file/get_doc_file_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'get_document_file_state.dart';

class GetFileCubit extends Cubit<GetFileState> {
  GetFileCubit() : super(GetFileInitial());
  static GetFileCubit get(context) => BlocProvider.of(context);

  void getDocument(Document doc) async {
    GetFileResponse response;
    emit(GetFileLoading());

    response = await GetDocumentFileRequest(doc.id).send();

    if (response.message == AppStrings.success) {
      emit(GetFileCompleted(
          bytes: response.bytes, file: doc, progressPage: doc.progressPage));
    } else {
      emit(GetFileFailure(response.message));
    }
  }

  void getBook(Book book) async {
    GetFileResponse response;
    emit(GetFileLoading());

    response = await GetBookFileRequest(book.id).send();

    if (response.message == AppStrings.success) {
      emit(GetFileCompleted(
        bytes: response.bytes,
        file: book,
      ));
    } else {
      emit(GetFileFailure(response.message));
    }
  }
}
