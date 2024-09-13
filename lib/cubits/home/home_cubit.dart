import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/Api_requests/get_recommended_books.dart';

import 'package:bookipedia/data_layer/Api_requests/recent_activity.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  HomeCubit() : super(HomeCubitInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Datum> recentActivity = [];
  List<Book> recommendation = [];

  void getData() async {
    getRecentActivity();
    getRecommendedBooks();
  }

  void getRecentActivity() async {
    RecentActivity response;

    emit(LoadingRecentActivity());

    response = await GetRecentActivityRequest().send();

    if (response.status == AppStrings.success) {
      recentActivity = response.data;
      //  getRecommendedBooks();
      emit(LoadedRecentActivity());
    } else {
      emit(HomeCubitFailure(response.status));
    }
  }

  void getRecommendedBooks() async {
    GetBooksResponse response;

    emit(LoadingRecommendation());

    response = await GetRecommendedBooksRequest().send();

    if (response.message == AppStrings.success) {
      recommendation = response.books;
      emit(LoadedRecommendation());
    } else {
      emit(HomeCubitFailure(response.message));
    }
  }
}
