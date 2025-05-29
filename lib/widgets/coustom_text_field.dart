import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';

class CoustomTextField extends StatelessWidget {
  CoustomTextField({
    required this.hint,
    super.key,
  });

  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      controller: TextEditingController(),
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          hintTextDirection: TextDirection.rtl,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.indigo, width: 3.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: primaryColor, width: 3.0),
          )),
    );
  }
}
