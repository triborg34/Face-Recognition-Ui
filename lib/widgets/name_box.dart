import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameBox extends StatelessWidget {
  NameBox({
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
          value: rcontroller.isName.value,
          onChanged: (value) =>
              rcontroller.isName.value = !rcontroller.isName.value,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "اسم",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Visibility(
            visible: rcontroller.isName.value,
            child: Row(
              children: [
                SizedBox(
                    width: 125,
                    child: CoustomTextField(
                      hint: "نام خانوادگی",
                    )),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                    width: 125,
                    child: CoustomTextField(
                      hint: "نام",
                    )),
              ],
            ))
      ],
    ));
  }
}
