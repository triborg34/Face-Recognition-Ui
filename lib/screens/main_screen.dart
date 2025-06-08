import 'package:faceui/screens/camera_screen.dart';
import 'package:faceui/screens/home_screen.dart';
import 'package:faceui/screens/person_screen.dart';
import 'package:faceui/screens/report_screen.dart';
import 'package:faceui/screens/setting_screen.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> tabs = ['Home', "Report", "Camera", "Person", "Setting"];

  List<IconData> tabsIcon = [
    Icons.home_filled,
    Icons.repartition_outlined,
    Icons.camera_indoor_rounded,
    Icons.person_add_alt_1,
    Icons.settings
  ];

  mainController mController = Get.find();
  networkController nController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => print(Get.find<networkController>().personList.length),
      ),
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: CoustomAppbar(
              tabs: tabs, mController: mController, tabsIcon: tabsIcon)),
      extendBody: false,
      body: Obx(() => nController.personList.length == 0
          ? Center(
              child: CircularProgressIndicator(color: primaryColor,),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: GetX<mainController>(
                builder: (controller) {
                  switch (controller.tabindex.value) {
                    case 0:
                      return HomeScreen(mController: controller,nController: nController,);
                    case 1:
                      return ReportScreen();
                    case 2:
                      return CameraScreen();
                    case 3:
                      return PersonScreen();
                    case 4:
                      return SettingScreen();
                    default:
                      return HomeScreen(mController: controller,nController: nController,);
                  }
                },
              ))),
    );
  }
}
