import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoustomTextField extends StatelessWidget {
  CoustomTextField({
    required this.hint,
    required this.tcontroller,
    super.key,
  });

  final String hint;
  final TextEditingController tcontroller;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 350),
      opacity: Get.find<reportController>().isUnknown.value ? 0.2 : 1.0,
      child: TextField(
        readOnly: Get.find<reportController>().isUnknown.value,
        textDirection: TextDirection.rtl,
        controller: tcontroller,
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
      ),
    );
  }
}

class CoustomTextField2 extends StatelessWidget {
  CoustomTextField2({
    required this.hint,
    required this.tcontroller,
    super.key,
  });

  final String hint;
  final TextEditingController tcontroller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: hint.toLowerCase() != 'نام'
          ? TextDirection.ltr
          : TextDirection.rtl,
      controller: tcontroller,
      style: TextStyle(fontFamily: 'robot'),
      decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          hintTextDirection:hint.toLowerCase() != 'نام'
              ? TextDirection.ltr
              : TextDirection.rtl,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent, width: 3.0),
          )),
    );
  }
}


class CoustomTextField3 extends StatelessWidget {
  CoustomTextField3({
    required this.hint,
    required this.tcontroller,
    super.key,
  });

  final String hint;
  final TextEditingController tcontroller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection:  TextDirection.rtl,
      controller: tcontroller,
      style: TextStyle(fontFamily: 'robot'),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.indigo,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          hintTextDirection: TextDirection.rtl,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent, width: 3.0),
          )),
    );
  }
}



class CoustomTextField4 extends StatelessWidget {
  CoustomTextField4({
    required this.controller,
    required this.hint,
    required this.width,
    super.key,
  });
  double width;
  String hint;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        textDirection: hint != '' ? TextDirection.rtl : TextDirection.ltr,
        controller: controller,
        obscureText: hint == 'رمز عبور' ? true : false,
        decoration: InputDecoration(
            hintTextDirection: TextDirection.rtl,
            hintText: hint,
            fillColor: Colors.indigo,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent, width: 1.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            )),
      ),
    );
  }
}