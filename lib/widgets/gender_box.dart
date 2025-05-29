import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderBox extends StatelessWidget {
  GenderBox({
    required this.rcontroller,
    super.key,
  });
  reportController rcontroller;

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Row(
      textDirection: TextDirection.rtl,
      children: [
        Checkbox(
          value: rcontroller.isGender.value,
          onChanged: (value) =>
              rcontroller.isGender.value = !rcontroller.isGender.value,
        ),
        Text(
          "جسنیت",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 30,
        ),
        Visibility(
          visible: rcontroller.isGender.value,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Radio<String>(
                toggleable: false,
                value: "male",
                groupValue: rcontroller.genderValue.value,
                onChanged: (value) {
                  rcontroller.genderValue.value = value!;
                },
              ),
              SizedBox(
                width: 5,
              ),
              Text("مرد"),
              SizedBox(
                width: 15,
              ),
              Radio<String>(
                toggleable: false,
                value: "female",
                groupValue: rcontroller.genderValue.value,
                onChanged: (value) {
                  rcontroller.genderValue.value = value!;
                },
              ),
              SizedBox(
                width: 5,
              ),
              Text("زن"),
            ],
          ),
        ),
      ],
    ));
  }
}
