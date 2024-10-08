import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: color ?? Colors.white60,
      ),
    );
  }
}
