import 'package:bookipedia/app/style/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final bool useTrailing;
  final Widget? leading;
  final Text? title;
  final Widget? subTitle;
  final Function? onTap;
  final Function? onLongPress;
  final Function? onDoubleTap;
  final Widget? trailing;
  final Color? tileColor;
  final double? height;

  const CustomListTile({
    super.key,
    this.leading,
    this.title,
    this.subTitle,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.trailing,
    this.tileColor,
    this.height,
    required this.useTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tileColor,
      child: InkWell(
        onTap: () => onTap,
        onDoubleTap: () => onDoubleTap,
        onLongPress: () => onLongPress,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 12.0, right: useTrailing ? 12 : 24),
                child: leading,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title ?? const SizedBox(),
                    const SizedBox(height: 2),
                    subTitle ?? const SizedBox(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: trailing,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
