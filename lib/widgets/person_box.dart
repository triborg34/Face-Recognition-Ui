import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/registred_box.dart';
import 'package:faceui/widgets/unknow_box.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PersonBox extends StatelessWidget {
  const PersonBox({
    super.key,
    required this.mController,
  });

  final mainController mController;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            RegistredBox(mController: mController),
            Divider(color: primaryColor,),
            UnknowBox(mController: mController),
          ],
        ),
        width: 50.w,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primaryColor)),
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(vertical: 15));
  }
}
