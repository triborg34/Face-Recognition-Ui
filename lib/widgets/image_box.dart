import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageBox extends StatelessWidget {
  ImageBox({
    required this.rcontroller,
    super.key,
  });
  reportController rcontroller = Get.find<reportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: 300,
          height: 300,
          child: rcontroller.filepath.value!.length == 0
              ? SizedBox.shrink()
              : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                    rcontroller.filepath.value!,
                    fit: BoxFit.fill,
                  ),
              ),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(15)),
        ));
  }
}
