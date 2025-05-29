import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';

import 'package:faceui/widgets/right_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(15)),
            width: 400,
            height: MediaQuery.of(context).size.height,
            child: RightSideBar()),
        //Left Side
        Obx(() => Expanded(
              child: AnimatedCrossFade(
                duration: Duration(milliseconds: 500),
                crossFadeState: Get.find<reportController>().isComplete.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                secondChild: SizedBox.shrink(),
                firstChild: Container(
                  width: 75.w,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(15),
                  height: MediaQuery.sizeOf(context).height,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("ردیف"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("عکس"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("نام و نام خانوادگی"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("جنسیت"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("سن"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("تاریخ"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("زمان"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: primaryColor))),
                              width: 150,
                              child: Center(
                                child: Text("درصد تشخیص"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(),
                              width: 155,
                              child: Center(
                                child: Text("دوربین"),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            border: Border.all(color: primaryColor)),
                      ),
                      Container(
                        height: 75.h,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  print(index);
                                },
                                child: Container(
                                  height: 100,
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(index.toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(ofReport[index]['Image']
                                              .toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                              ofReport[index]['Name'].toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(ofReport[index]['Gender']
                                              .toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                              ofReport[index]['Age'].toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                              ofReport[index]['Date'].toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                              ofReport[index]['Time'].toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: primaryColor))),
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                              ofReport[index]['Conf'].toString()),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(),
                                        width: 155,
                                        child: Center(
                                          child: Text(ofReport[index]['Camera']
                                              .toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: primaryColor)),
                                ),
                              );
                            },
                            itemCount: ofReport.length),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {},
                            child: Text(
                              "خروجی گرفتن",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
