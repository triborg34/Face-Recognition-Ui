import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UnknowBox extends StatelessWidget {
  const UnknowBox({
    super.key,
    required this.mController,
  });

  final mainController mController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        mController.unknownSelector.value = -1;
        mController.isPersonSelected.value = false;
        mController.personSelector.value = -1;
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          width: 50.w,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "افراد ناشناس",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(
                textDirection: TextDirection.rtl,
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int i = 0; i < ofUnknown.length; i++)
                    Obx(() => InkWell(
                          onTap: () {
                            mController.unknownSelector.value = i;
                            mController.isPersonSelected.value = true;
                            mController.personSelector.value = -1;
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: mController.unknownSelector.value == i
                                      ? Colors.indigo
                                      : primaryColor,
                                )),
                            child: Center(
                              child: Text(ofUnknown[i]),
                            ),
                          ),
                        ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
