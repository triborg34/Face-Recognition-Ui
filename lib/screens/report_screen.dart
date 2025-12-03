
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:faceui/widgets/right_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
        GetX<reportController>(
            builder: (rcontroller) => Expanded(
                  child: AnimatedCrossFade(
                    duration: Duration(milliseconds: 500),
                    crossFadeState:
                        Get.find<reportController>().isPressed.value
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
                      child:  Get.find<reportController>().isComplete.value==false? CoustomLoading() : Column(
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
                                    onTap: () {
                                      showImageViewer(context, NetworkImage('http://${url}:8091/api/files/collection/${rcontroller.reportList[index].id}/${rcontroller.reportList[index].frame}'));
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
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width: 150,
                                                      child: ClipRRect(
                                                        child: Image.network(
                                                          'http://${url}:8091/api/files/collection/${rcontroller.reportList[index].id}/${rcontroller.reportList[index].croppedFrame}',
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
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
                                                  .reportList[index].score!.toStringAsFixed(2)+"%"
                                                  ),
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
                                onPressed: () async {
                                  await saveFunction(rcontroller);
                                },
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

  Future<void> saveFunction(reportController rcontroller) async {
    final doc = pw.Document();
    final ttf = await fontFromAssetBundle('fonts/arial.ttf');

    doc.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(10),
      orientation: pw.PageOrientation.portrait,
      textDirection: pw.TextDirection.rtl,
      // pageFormat: PdfPageFormat(
      //   2480,
      //   3508,

      // ),
      build: (context) {
        return [
          for (var person in rcontroller.reportList.reversed)
            pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                height: 50,
                child: pw.Row(children: [
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                          (rcontroller.reportList.reversed
                                      .toList()
                                      .indexOf(person) +
                                  1)
                              .toString(),
                          style: pw.TextStyle(font: ttf)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Image(pw.MemoryImage(person.imageByte!),
                          fit: pw.BoxFit.fill),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(person.name!,
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(person.date!.toPersianDate(),
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(person.time!.toPersianDigit(),
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(person.gender =='male' ?"مرد" : "زن",
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                  pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                          person.role == 'approve' ? "مجاز" : "غیر مجاز",
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                                   pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                          person.age!,
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                        pw.Container(
                      height: 50,
                      width: 60,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                          person.role == 'approve' ? "مجاز" : "غیر مجاز",
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                      
                                   pw.Container(
                      height: 50,
                      width: 30,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        
                          person.camera!,
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      decoration: pw.BoxDecoration(border: pw.Border.all())),
                ])),
                
                
        ];
      },
    ));

    await Printing.layoutPdf(
        format: PdfPageFormat.a4,
        dynamicLayout: true,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}

class CoustomLoading extends StatelessWidget {
  const CoustomLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,textDirection: TextDirection.rtl,
      children: [
        CircularProgressIndicator(color: primaryColor,),
      ],
    ));
  }
}
