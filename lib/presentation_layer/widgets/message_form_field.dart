import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/main.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField(
      {super.key, required this.messageController, this.onPressed});
  final TextEditingController messageController;
  final Function()? onPressed;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  @override
  Widget build(BuildContext context) {
    var enteredText = widget.messageController.text;
    var webOn = preferences.getBool("web");
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: TextField(
          controller: widget.messageController,
          maxLines: 4,
          minLines: 1,
          enableSuggestions: true,
          onChanged: (val) {
            setState(() {
              enteredText = val;
            });
          },
          scrollPhysics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          decoration: InputDecoration(
              prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      webOn
                          ? preferences.setBool("web", false)
                          : preferences.setBool("web", true);
                    });
                  },
                  icon: Icon(
                    Icons.language_rounded,
                    color: webOn! ? ColorManager.primary : Colors.grey,
                    size: 24,
                  )),
              suffixIcon: IconButton(
                onPressed: widget.onPressed,
                icon: Icon(
                  Icons.send,
                  color: (enteredText.isEmpty || enteredText == "")
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.only(right: 8),
              ),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: ColorManager.primary),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: ColorManager.primaryLight),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              contentPadding:
                  const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 30),
              hintFadeDuration: const Duration(milliseconds: 300),
              hintText: "Message")),
    );
  }
}
