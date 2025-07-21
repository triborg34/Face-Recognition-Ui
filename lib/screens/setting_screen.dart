import 'package:faceui/screens/general_box_page_two.dart';
import 'package:faceui/screens/user_box_page_one.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({
    super.key,
  });
  final PageController _pageController = PageController();
  userController ucontroller = Get.find<userController>();
  settinController scontroller = Get.find<settinController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(15)),
      child: RawScrollbar(
        interactive: true,
        thumbVisibility: true,
        thickness: 12,
        trackColor: primaryColor,
        trackRadius: Radius.circular(10),
        trackVisibility: true,
        padding: EdgeInsets.all(10),
        radius: Radius.circular(10),
        controller: _pageController,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              UserBoxPageOne(ucontroller: ucontroller),
              GeneralBoxPageTwo(
                scontroller: scontroller,
              ),
              InfoBox(),

            ],
          ),
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(15),
      width: Get.width,
      height: 200,
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(15),),
          child: Column(
            children: [
              KeyValueRow(
                    keyString: "BuilDNumber", valueString: "SN/14040430"),
                Divider(
                  color: primaryColor,
                ),
                KeyValueRow(keyString: "UpdateNo", valueString: "7.21.2025"),
                Divider(
                  color: primaryColor,
                ),
                KeyValueRow(
                    keyString: "Last Update",
                    valueString:
                        "${DateTime.now().year.toString()}/${DateTime.now().month.toString()}/${DateTime.now().day.toString()}"),
                Divider(color: primaryColor),
                KeyValueRow(
                    keyString: "Train Model Serial",
                    valueString: "INSIGHTFACE"),
                Divider(
                  color: primaryColor,
                ),
            ],
          ),
    );
  }
}

class KeyValueRow extends StatelessWidget {
  late String keyString;
  late String valueString;
  KeyValueRow({required this.keyString, required this.valueString});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.transparent,
          width: 150,
          child: Text(
            keyString + " : ",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'arial'),
          ),
        ),
        Text(
          "  " + valueString,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "arial"),
        )
      ],
    );
  }
}
