import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard(
      {super.key, required this.title, required this.onIconPressed});
  final String title;
  final Function() onIconPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(
            vertical: AppSpacingSizing.s8, horizontal: AppSpacingSizing.s8),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacingSizing.s24,
                vertical: AppSpacingSizing.s8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: FontSize.f20, fontWeight: FontWeight.w400),
                ),
                PopupMenuButton(
                    icon: const Icon(Icons.more_horiz),
                    itemBuilder: (_) => [
                          PopupMenuItem(
                              onTap: onIconPressed,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_outlined,
                                  ),
                                  Text("Remove"),
                                ],
                              ))
                        ]),
              ],
            )));
  }
}
