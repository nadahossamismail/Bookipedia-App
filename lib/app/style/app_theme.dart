import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManger {
  ThemeData getApplicationTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorManager.primary,
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStatePropertyAll(ColorManager.primary))),
        //  dialogTheme: const DialogTheme(backgroundColor: Colors.grey),
        bottomSheetTheme: BottomSheetThemeData(
            modalBarrierColor: Colors.grey.withOpacity(0.4)),
        colorScheme: ColorScheme.dark(
            surface: ColorManager.backgroundDark,
            onPrimary: Colors.white,
            secondaryContainer: ColorManager.primary),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: ColorManager.primary,
            selectionColor: const Color(0xff297494).withOpacity(0.6),
            selectionHandleColor: const Color(0xff297494)),
        primaryColorLight: ColorManager.primaryLight,
        primaryColorDark: ColorManager.primaryDark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
            backgroundColor: ColorManager.primary),
        scaffoldBackgroundColor: ColorManager.backgroundDark,
        navigationBarTheme: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: ColorManager.cardColor,
          iconTheme: const MaterialStatePropertyAll(
              IconThemeData(color: Colors.white)),
        ),
        primaryColor: ColorManager.primary,
        listTileTheme:
            ListTileThemeData(tileColor: ColorManager.backgroundDark),
        cardTheme: CardTheme(color: ColorManager.cardColor),
        appBarTheme: AppBarTheme(
            backgroundColor: ColorManager.backgroundDark,
            foregroundColor: Colors.white,
            titleTextStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: FontSize.f24, fontWeight: FontWeight.w500)),
            elevation: 0,
            surfaceTintColor: ColorManager.backgroundDark));
  }
}
