import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsBox extends StatelessWidget {
  const DetailsBox({
    super.key,
    required this.mController,
  });

  final mainController mController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
            child: AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          crossFadeState: mController.isPersonSelected.value
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          secondChild: SizedBox.shrink(),
          firstChild: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Name and Family Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 60,
                    ),
                    Icon(Icons.arrow_forward),
                    CircleAvatar(
                      radius: 60,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                CoustomRow(
                  substring: "qju292319d",
                  title: "ID",
                ),
                SizedBox(
                  height: 10,
                ),
                CoustomRow(title: "Track_ID", substring: "2"),
                SizedBox(
                  height: 10,
                ),
                CoustomRow(title: "Gender", substring: "Male"),
                SizedBox(
                  height: 10,
                ),
                CoustomRow(title: "Age", substring: "27"),
                SizedBox(
                  height: 10,
                ),
                CoustomRow(title: "Confidnce", substring: "89%"),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: Container(
                  child: Center(
                    child: Text("FRAME"),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(15)),
                ))
              ],
            ),
          ),
        )));
  }
}
