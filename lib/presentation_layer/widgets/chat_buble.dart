import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bookipedia/app/style/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:selectable/selectable.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isQuestion;
  final bool willBeStreamed;
  final Function()? showSources;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isQuestion,
      this.willBeStreamed = false,
      this.showSources});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isQuestion
              ? ColorManager.primary
              : const Color.fromARGB(255, 224, 223, 223),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isQuestion ? "You" : "Ai",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Selectable(
                popupMenuItems: [
                  SelectableMenuItem(
                      icon: Icons.volume_up,
                      title: "Text to speech",
                      type: SelectableMenuItemType.other,
                      isEnabled: (_) {
                        return true;
                      },
                      handler: (_) {
                        return true;
                      }),
                ],
                child: willBeStreamed
                    ? AnimatedTextKit(
                        isRepeatingAnimation: false,
                        onFinished: showSources,
                        animatedTexts: [
                          TyperAnimatedText(message,
                              textAlign: TextAlign.justify,
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              speed: const Duration(milliseconds: 10)),
                        ],
                      )
                    : Text(
                        message,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        maxLines: 100,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              // !isQuestion
              //     ? const Text(
              //         "we based our answer on :",
              //         style: TextStyle(
              //           decoration: TextDecoration.underline,
              //           fontSize: 16,
              //           fontWeight: FontWeight.w800,
              //         ),
              //       )
              //     : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
