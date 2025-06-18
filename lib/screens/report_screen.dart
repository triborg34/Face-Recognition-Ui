import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:faceui/widgets/right_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({
    super.key,
  });
//TODO:EXPORT AND MAYBE DETILS SCREEN 
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
        GetX<reportController>(
            builder: (rcontroller) => Expanded(
                  child: AnimatedCrossFade(
                    duration: Duration(milliseconds: 500),
                    crossFadeState:
                        Get.find<reportController>().isComplete.value
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
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("ردیف"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("عکس"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("نام و نام خانوادگی"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("جنسیت"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("سن"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("تاریخ"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                  width: 150,
                                  child: Center(
                                    child: Text("زمان"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
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
                                    onTap: () {},
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
                                              child:
                                                  Text((index + 1).toString()),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: primaryColor))),
                                            width: 150,
                                            child: Center(
                                              child: rcontroller
                                                      .reportList[index]
                                                      .croppedFrame!
                                                      .isNotEmpty
                                                  ? Container(
                                                    padding: EdgeInsets.all(5),
                                                    width: 150,
                                                    child: ClipRRect(
                                                        child: Image.network(
                                                          'http://127.0.0.1:8090/api/files/collection/${rcontroller.reportList[index].id}/${rcontroller.reportList[index].croppedFrame}',
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0),
                                                      ),
                                                  )
                                                  : Center(
                                                      child:
                                                          Icon(Icons.person)),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: primaryColor))),
                                            width: 150,
                                            child: Center(
                                              child: Text(rcontroller
                                                          .reportList[index]
                                                          .name!
                                                          .toString() ==
                                                      'unknown'
                                                  ? "ناشناس"
                                                  : rcontroller
                                                      .reportList[index].name!
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
                                              child: Text(rcontroller
                                                          .reportList[index]
                                                          .gender
                                                          .toString() ==
                                                      'male'
                                                  ? "مرد"
                                                  : "زن"),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: primaryColor))),
                                            width: 150,
                                            child: Center(
                                              child: Text(rcontroller
                                                  .reportList[index].age
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
                                              child: Text(rcontroller
                                                  .reportList[index].date!
                                                  .toPersianDate()
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
                                              child: Text(rcontroller
                                                  .reportList[index].time
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
                                              child: Text(rcontroller
                                                  .reportList[index].score
                                                  .toString()),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(),
                                            width: 155,
                                            child: Center(
                                              child: Text(rcontroller
                                                  .reportList[index].camera
                                                  .toString()),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border:
                                              Border.all(color: primaryColor)),
                                    ),
                                  );
                                },
                                itemCount: rcontroller.reportList.length),
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
