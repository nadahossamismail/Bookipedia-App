import 'package:bookipedia/app/app_routes.dart';
import 'package:bookipedia/app/style/app_theme.dart';
import 'package:bookipedia/cubits/books/books_operations_cubit.dart';
import 'package:bookipedia/cubits/get_document_file/get_document_file_cubit.dart';
import 'package:bookipedia/cubits/home/home_cubit.dart';
import 'package:bookipedia/cubits/user_document/user_document_cubit.dart';
import 'package:bookipedia/main.dart';
import 'package:bookipedia/presentation_layer/screens/auth_screens/login/login_view.dart';
import 'package:bookipedia/presentation_layer/screens/main/main_view.dart';
import 'package:bookipedia/presentation_layer/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();
  factory MyApp() => _instance;

  @override
  Widget build(BuildContext context) {
    if (preferences.getBool("web") == null) {
      preferences.setBool("web", false);
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetFileCubit(),
        ),
        BlocProvider(
          create: (_) => BookCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeManger().getApplicationTheme(),
          darkTheme: ThemeManger().getDarkTheme(),
          themeMode: ThemeMode.dark,
          onGenerateRoute: RouteGenerator.generateRoute,
          home: const LoginView() // destination(),
          ),
    );
  }

  Widget destination() {
    var isUserAuthenticated = preferences.getString("token") == null ||
            preferences.getString("token") == ""
        ? false
        : true;
    return isUserAuthenticated ? const MainView() : const SplashView();
  }
}
