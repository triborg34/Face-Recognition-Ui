import 'package:flutter/material.dart';

class CoustomRow extends StatelessWidget {
  CoustomRow({super.key, required this.title, required this.substring});
  String title;
  String substring;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [Text(substring), Spacer(), Text(title)],
    );
  }
}
