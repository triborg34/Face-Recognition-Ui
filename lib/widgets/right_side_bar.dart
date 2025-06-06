import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/age_box.dart';
import 'package:faceui/widgets/date_box.dart';
import 'package:faceui/widgets/gender_box.dart';
import 'package:faceui/widgets/image_box.dart';
import 'package:faceui/widgets/name_box.dart';
import 'package:faceui/widgets/time_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RightSideBar extends StatelessWidget {
  const RightSideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<reportController>(
      builder: (rcontroller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState: rcontroller.isImage.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: SizedBox.shrink(),
            firstChild: Center(
              child: ImageBox(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  rcontroller.isImage.value = true;
                },
                child: Text(
                  "انتخاب عکس",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          NameBox(
            rcontroller: rcontroller,
          ),
          SizedBox(
            height: 15,
          ),
          GenderBox(rcontroller: rcontroller),
          SizedBox(
            height: 15,
          ),
          AgeBox(rcontroller: rcontroller),
          SizedBox(
            height: 15,
          ),
          DateBox(),
          SizedBox(
            height: 15,
          ),
          TimeBox(),
          Spacer(),
          Center(
            child: SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                  style: TextButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    rcontroller.isComplete.value=true;
                  },
                  child: Text(
                    "جستسجو",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
