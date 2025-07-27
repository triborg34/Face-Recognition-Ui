import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoustomAppbar extends StatelessWidget {
  const CoustomAppbar({
    super.key,
    required this.tabs,
    required this.mController,
    required this.tabsIcon,
  });

  final List<String> tabs;
  final mainController mController;
  final List<IconData> tabsIcon;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      color: primaryColor,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Image.asset(
           'assets/images/mainlogo2.png'
           
          ),
          SizedBox(
            width: 15,
          ),
          for (int i = 0; i < tabs.length; i++)
            Obx(
              () => InkWell(
                onTap: () {
                  mController.tabindex.value = i;
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  color: mController.tabindex.value == i
                      ? Colors.indigo
                      : primaryColor,
                  width: mController.tabindex.value == i ? 110 : 100,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tabsIcon[i]),
                        SizedBox(
                          width: 5,
                        ),
                        Text(tabs[i]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Spacer(),
          CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Icon(Icons.person),
            radius: 15,
          ),
          SizedBox(
            width: 10,
          ),
          Text(unames.capitalizeFirst!),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 90,
            child:      IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
          )
        ],
      ),
    );
  }
}
