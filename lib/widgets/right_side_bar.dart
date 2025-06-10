import 'dart:typed_data';

import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/age_box.dart';
import 'package:faceui/widgets/date_box.dart';
import 'package:faceui/widgets/gender_box.dart';
import 'package:faceui/widgets/image_box.dart';
import 'package:faceui/widgets/name_box.dart';
import 'package:faceui/widgets/time_box.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RightSideBar extends StatelessWidget {
  const RightSideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<reportController>(
      builder: (rcontroller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState: rcontroller.isImage.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: SizedBox.shrink(),
            firstChild: Center(
              child: ImageBox(rcontroller: rcontroller,),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: rcontroller.isImage.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          rcontroller.isImage.value = false;
                          rcontroller.filename.value="انتخاب";
                          rcontroller.filepath.value=Uint8List(0);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              Uint8List fileBytes = result.files.first.bytes!;
                              rcontroller.filename.value =
                                  result.files.single.name;

                              try {
                               rcontroller.filepath.value= await uploadAndGetImage(fileBytes,
                                    result.files.single.name,);
                                
                    
                              } catch (e) {
                                print(e);
                                await ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(SnackBar(
                                        content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text("خطا در ارسال داده"))));
                              }
                            }
                            else{
                                       await ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(SnackBar(
                                        content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text("خطا در انتخاب عکس"))));
                            }
                          },
                          child: Text(
                            rcontroller.filename.value,
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  )
                : ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      rcontroller.isImage.value = true;
                    },
                    child: Text(
                      "انتخاب عکس",
                      style: TextStyle(color: Colors.white),
                    )),
          ),
          SizedBox(
            height: 20,
          ),
          NameBox(
            rcontroller: rcontroller,
          ),
          SizedBox(
            height: 15,
          ),
          GenderBox(rcontroller: rcontroller),
          SizedBox(
            height: 15,
          ),
          AgeBox(rcontroller: rcontroller),
          SizedBox(
            height: 15,
          ),
          DateBox(),
          SizedBox(
            height: 15,
          ),
          TimeBox(),
          Spacer(),
          Center(
            child: SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                  style: TextButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    rcontroller.isComplete.value = true;
                  },
                  child: Text(
                    "جستسجو",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
