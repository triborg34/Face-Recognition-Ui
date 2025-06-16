import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgeBox extends StatelessWidget {
  AgeBox({required this.rcontroller});
  reportController rcontroller;
  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Row(
      textDirection: TextDirection.rtl,
      children: [
        Checkbox(
          value: rcontroller.isAge.value,
          onChanged: (value) =>
              rcontroller.isAge.value = !rcontroller.isAge.value,
        ),
        Text(
          "سن",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 30,
        ),
        Visibility(
            visible: rcontroller.isAge.value,
            child: Row(
              children: [
                SizedBox(width: 60, child: CoustomTextField(hint: '27',tcontroller: rcontroller.eageController,)),
                SizedBox(width: 15,),
                Icon(Icons.arrow_back),
                SizedBox(width: 15,)
                ,SizedBox(width: 60, child: CoustomTextField(hint: '19',tcontroller: rcontroller.sageController,))
              ],
            ))
      ],
    ));
  }
}
