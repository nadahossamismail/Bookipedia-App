import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:bookipedia/presentation_layer/screens/auth_screens/sign_up/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      backgroundColor: ColorManager.primaryLighter,
      splash: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Image.asset("assets/images/Logo-Final-No-Title.png")),
          Text(
            "Bookipedia",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: FontSize.f24, fontWeight: FontWeight.w700)),
          )
        ],
      ),
      nextScreen: const SignUpView(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
