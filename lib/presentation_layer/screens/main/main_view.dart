import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/presentation_layer/screens/Library/library_view.dart';
import 'package:bookipedia/presentation_layer/screens/home/home_view.dart';
import 'package:bookipedia/presentation_layer/screens/user_books/user_books.dart';
import 'package:bookipedia/presentation_layer/screens/user_document/user_document.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;
  var pages = [
    const HomeView(),
    const LibraryView(),
    const UserBooksView(),
    const UserDocumentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: NavigationBar(
            surfaceTintColor: ColorManager.primaryLighter,
            indicatorColor: ColorManager.primary,
            selectedIndex: currentIndex,
            onDestinationSelected: (val) => setState(() {
                  currentIndex = val;
                }),
            destinations: [
              const NavigationDestination(
                  icon: Icon(Icons.home_rounded, size: 30), label: "Home"),
              NavigationDestination(
                  icon: SizedBox(
                      child: Image.asset(
                    "assets/images/image_2024-07-10_08-45-10.png",
                    height: 30,
                    width: 30,
                  )),
                  label: "library"),
              const NavigationDestination(
                  icon: Icon(
                    Icons.book,
                    size: 30.0,
                  ),
                  label: "BookShelf"),
              const NavigationDestination(
                icon: Icon(Icons.upload_file_rounded, size: 30),
                label: "Docs",
              ),
            ]));
  }
}
