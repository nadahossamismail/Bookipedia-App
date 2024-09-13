import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String text;
  const EmptyList({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 250,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: FontSize.f18, color: Colors.grey),
      ),
    ));
  }
}
