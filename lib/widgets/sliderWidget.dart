
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class SlidersWidgets extends StatelessWidget {
  const SlidersWidgets({
    super.key,
    required this.scontroller,
  });

  final settinController scontroller;

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
    children: [
      Row(
        textDirection: TextDirection.rtl,
        children: [
          FutursOfSystemRow(
            lable: "دقت تشخیص چهره",
          ),
          SizedBox(
            width: 5,
          ),
          Obx(() => SizedBox(
                height: 10,
                child: Slider(
                  activeColor: primaryColor,
                  inactiveColor: Colors.white70,
                  value: scontroller.score.value,
                  onChanged: (value) {
                    scontroller.score.value = value;
                  },
                ),
              )),
          SizedBox(
            width: 0,
          ),
          Obx(
            () => Text(
              textDirection: TextDirection.rtl,
              "${(scontroller.score.value * 100).round()}%",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
      SizedBox(
        height: 35,
      ),
            Row(
        textDirection: TextDirection.rtl,
        children: [
          FutursOfSystemRow(
            lable: "دقت تشخیص انسان",
          ),
          SizedBox(
            width: 5,
          ),
          Obx(() => SizedBox(
                height: 10,
                child: Slider(
                  activeColor: primaryColor,
                  inactiveColor: Colors.white70,
                  value: scontroller.hScore.value,
                  onChanged: (value) {
                    scontroller.hScore.value = value;
                  },
                ),
              )),
          SizedBox(
            width: 0,
          ),
          Obx(
            () => Text(
              textDirection: TextDirection.rtl,
              "${(scontroller.hScore.value * 100).round()}%",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
      SizedBox(
        height: 35,
      ),
       Row(
        textDirection: TextDirection.rtl,
        children: [
          FutursOfSystemRow(
            lable: "کادر عکس",
          ),
          Obx(() => SizedBox(
                height: 10,
                child: Slider(
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: primaryColor,
                  inactiveColor: Colors.white70,
                  value: scontroller.padding.value.toDouble(),
                  onChanged: (value) {
                    scontroller.padding.value = value.toInt();
                  },
                ),
              )),
          SizedBox(
            width: 0,
          ),
          Obx(
            () => Text(
              "${(scontroller.padding.value)}%",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    
      SizedBox(
        height: 25,
      ),
      Row(
        textDirection: TextDirection.rtl,
        children: [
          FutursOfSystemRow(
            lable: "کیفیت عکس",
          ),
          Obx(() => SizedBox(
                height: 10,
                child: Slider(
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: primaryColor,
                  inactiveColor: Colors.white70,
                  value: scontroller.quality.value,
                  onChanged: (value) {
                    scontroller.quality.value = value;
                  },
                ),
              )),
          SizedBox(
            width: 0,
          ),
          Obx(
            () => Text(
              "${(scontroller.quality.value)}%",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    ],
          ),
        );
  }
}




class FutursOfSystemRow extends StatelessWidget {
  String lable;

  FutursOfSystemRow({required this.lable});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.w,
      child: Text(
        lable,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}