import 'dart:developer';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/cubits/home/home_cubit.dart';
import 'package:bookipedia/data_layer/Api_requests/recent_activity.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/presentation_layer/screens/profile.dart';
import 'package:bookipedia/presentation_layer/widgets/loading.dart';
import 'package:bookipedia/presentation_layer/widgets/recent_activity.dart';
import 'package:bookipedia/presentation_layer/widgets/something_went_wrong.dart';
import 'package:bookipedia/presentation_layer/widgets/user_book.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Datum> recentActivity = [];
  List<Book> recommendation = [];
  @override
  void initState() {
    // if (HomeCubit.get(context).recentActivity.isEmpty) {
    //   HomeCubit.get(context).getData();
    // } else {
    //   recentActivity = HomeCubit.get(context).recentActivity;
    //   recommendation = HomeCubit.get(context).recommendation;
    // }
    HomeCubit.get(context).getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(recommendation.length.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Home",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: FontSize.f24, fontWeight: FontWeight.w500)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacingSizing.s12),
            child: IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Profile())),
              icon:
                  const Icon(Icons.account_circle, size: AppSpacingSizing.s28),
            ),
          )
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeCubitState>(
        listener: (context, state) {
          state is LoadedRecentActivity
              ? recentActivity = HomeCubit.get(context).recentActivity
              : null;
          state is LoadedRecommendation
              ? recommendation = HomeCubit.get(context).recommendation
              : null;
        },
        builder: (context, state) {
          return state is LoadingRecentActivity ||
                  state is LoadingRecommendation
              ? const Loading()
              : state is HomeCubitFailure
                  ? SomethingWentWrong(
                      onPressed: () => HomeCubit.get(context).getData())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: AppSpacingSizing.s28,
                        left: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: AppSpacingSizing.s12,
                          ),
                          Text(
                            "Continue Reading",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: FontSize.f18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            height: AppSpacingSizing.s12,
                          ),
                          RecentActivityUi(recentActivity: recentActivity),
                          const SizedBox(
                            height: AppSpacingSizing.s24,
                          ),
                          Text(
                            "People also read",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.f18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: AppSpacingSizing.s24,
                                    bottom: AppSpacingSizing.s16),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: AppSpacingSizing.s16,
                                    ),
                                itemCount: recommendation.length,
                                itemBuilder: (context, index) {
                                  var book = recommendation[index];
                                  return BookTile(
                                    useTrailing: false,
                                    book: Book.toUserBook(book: book),
                                  );
                                }),
                          )
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
