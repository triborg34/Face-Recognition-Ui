import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:faceui/utils/consts.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.find<personController>();

    return Obx(() => AnimatedOpacity(
          opacity: pcontroller.isVisible.value ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "اضافه کردن",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 15,
                        runSpacing: 10,
                        children: [
                          for (int i = 0; i < ofReport.length; i++)
                            Container(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                      )),
                                  Align(
                            alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      )),
                                  InkWell(
                                    onTap: () => print(i),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 110,
                                          child: Center(
                                            child: Icon(
                                              Icons.person,
                                              size: 36,
                                              color: primaryColor,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: primaryColor),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(ofReport[i]['Name'].toString()),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(ofReport[i]['Age'].toString()),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(ofReport[i]['Gender'].toString()),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(ofReport[i]['ID'].toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              height: 300,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: primaryColor),
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
