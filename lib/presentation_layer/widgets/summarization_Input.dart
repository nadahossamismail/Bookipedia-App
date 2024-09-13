import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummarizationInput extends StatelessWidget {
  const SummarizationInput(
      {super.key,
      required this.startPageController,
      required this.endPageController});
  final TextEditingController startPageController;
  final TextEditingController endPageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  constraints:
                      const BoxConstraints(maxWidth: AppSpacingSizing.s64),
                  hintText: "start",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacingSizing.s24),
              child: Text(
                "to",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: FontSize.f18)),
              ),
            ),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: startPageController,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorManager.primary)),
                  focusColor: ColorManager.primary,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  constraints:
                      const BoxConstraints(maxWidth: AppSpacingSizing.s64),
                  hintText: "end",
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacingSizing.s32),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(ColorManager.primary)),
                onPressed: () {},
                child: const Text(
                  "Summarize",
                  style: TextStyle(color: Colors.white),
                )))
      ]),
    );
  }
}
