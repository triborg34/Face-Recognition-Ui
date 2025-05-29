import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegistredBox extends StatelessWidget {
  const RegistredBox({
    super.key,
    required this.mController,
  });

  final mainController mController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            mController.personSelector.value=-1;
            mController.isPersonSelected.value=false;
             mController.unknownSelector.value = -1;
          },
          child: SingleChildScrollView(
            child: Container(
                                  width: 50.w,
                                  padding: EdgeInsets.all(15),
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
                "افراد ثبت شده",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(
                textDirection: TextDirection.rtl,
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int i = 0; i < ofRegistred.length; i++)
                    Obx(() => GestureDetector(
                          onTap: () {
                            mController.personSelector.value = i;
                            mController.unknownSelector.value = -1;
                            mController.isPersonSelected.value=true;
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(15),
                                border: Border.all(
                                  color: mController.personSelector
                                              .value ==
                                          i
                                      ? Colors.indigo
                                      : primaryColor,
                                )),
                            child: Center(
                              child: Text(ofRegistred[i]),
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
