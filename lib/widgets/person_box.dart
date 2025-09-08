import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/registred_box.dart';
import 'package:faceui/widgets/unknow_box.dart';
import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class PersonBox extends StatelessWidget {
  const PersonBox(
      {super.key, required this.mController, required this.nController});

  final mainController mController;
  final networkController nController;

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        //  Obx(() =>
         Column(
              textDirection: TextDirection.rtl,
              children: [
              // mController.isUnknownExpand.value
              //       ? SizedBox.shrink()
              //       :  
                    RegistredBox(
                  mController: mController,
                  nController: nController,
                ),
                Divider(
                  color: primaryColor,
                ),

                // mController.isRegisterExpand.value
                //     ? SizedBox.shrink()
                //     :
                     UnknowBox(
                        mController: mController,
                        nController: nController,
                      ),
              ],
            )
            // )
            ,
        width: 50.w,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primaryColor)),
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(vertical: 15));
  }
}
