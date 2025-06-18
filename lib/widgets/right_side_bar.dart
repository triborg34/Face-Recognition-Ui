import 'dart:typed_data';

import 'package:faceui/models/reportClass.dart';
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
    try {
      Get.find<reportController>().isImage.value = false;
      Get.find<reportController>().filename.value = "انتخاب";
      Get.find<reportController>().filepath.value = Uint8List(0);
      Get.find<reportController>().fromDate = ''.obs;
      Get.find<reportController>().untilDate = ''.obs;
      Get.find<reportController>().fromTime = ''.obs;
      Get.find<reportController>().untilTime = ''.obs;
      Get.find<reportController>().nameController.text = '';
      Get.find<reportController>().familyController.text = '';
      Get.find<reportController>().sageController.text = '';
      Get.find<reportController>().eageController.text = '';
    } catch (e) {
      ScaffoldMessenger.maybeOf(context)!
          .showSnackBar(SnackBar(content: Text("Somthing Went Wrong")));
    }
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
              child: rcontroller.filepath.value == null
                  ? Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(child: Text("خطا دوباره امتحان کنید")),
                    )
                  : ImageBox(
                      rcontroller: rcontroller,
                    ),
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
                          rcontroller.filename.value = "انتخاب";
                          rcontroller.filepath.value = Uint8List(0);
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
                                rcontroller.filepath.value =
                                    await uploadAndGetImage(
                                  fileBytes,
                                  result.files.single.name,
                                );
                              } catch (e) {
                                print(e);
                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text("خطا در ارسال داده"))));
                              }
                            } else {
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
                  onPressed: () async {
                    rcontroller.reportList.clear();
                    try {
                      await getResult(rcontroller);
                      rcontroller.isComplete.value = true;
                    } catch (e) {
                      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
                          content: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  "خطا در جستجو لطفا دوباره امتحان کنید"))));
                    }
                  },
                  child: Text(
                    "جستجو",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> getResult(reportController rcontroller) async {
    // Build the filter string based on active filters
    List<String> filters = [];

    // Add age filter
    if (rcontroller.isAge.value) {
      filters.add(
          '${int.parse(rcontroller.sageController.text.trim())}<=age && age<${int.parse(rcontroller.eageController.text.trim())}');
    }

    // Add gender filter
    if (rcontroller.isGender.value) {
      filters.add('gender="${rcontroller.genderValue.value}"');
    }

    // Add name filter
    if (rcontroller.isName.value) {
      if (rcontroller.isUnknown.value) {
        filters.add('name ~ "unknown"');
      } else {
        filters.add(
            'name ~ "${rcontroller.nameController.text.trim()} ${rcontroller.familyController.text.trim()}"');
      }
    }

    // Build the complete filter string
    String filterString = filters.join(' && ');

    // If no filters are active, return empty result
    if (filterString.isEmpty) {
      final records = await pb.collection('collection').getFullList();
      for (var json in records) {
        rcontroller.reportList.add(reportClass.fromJson(json.data));
      }
      return true;
    }

    // Fetch records from database
    final records =
        await pb.collection('collection').getFullList(filter: filterString);
    print('Filter: $filterString');

    // Apply date and time filters in memory
    var tempList = records.where((element) {
      bool passesDateFilter = true;
      bool passesTimeFilter = true;

      // Apply date filter if active
      if (rcontroller.isDate.value) {
        DateTime fromDate = DateTime.parse(rcontroller.fromDate.value);
        DateTime untilDate = DateTime.parse(rcontroller.untilDate.value);
        DateTime initDate = DateTime.parse(element.data['date']);

        if (rcontroller.fromDate.value == rcontroller.untilDate.value ||
            rcontroller.untilDate.value == '') {
          passesDateFilter = element.data['date'] == rcontroller.fromDate.value;
        } else {
          passesDateFilter =
              initDate.isBefore(untilDate) && initDate.isAfter(fromDate);
        }
      }

      // Apply time filter if active
      if (rcontroller.isTime.value) {
        TimeOfDay fromTime = TimeOfDay(
            hour: int.parse(rcontroller.fromTime.value.split(':')[0]),
            minute: int.parse(rcontroller.fromTime.value.split(':')[1]));
        TimeOfDay untilTime = TimeOfDay(
            hour: int.parse(rcontroller.untilTime.value.split(':')[0]),
            minute: int.parse(rcontroller.untilTime.value.split(':')[1]));
        TimeOfDay initTime = TimeOfDay(
            hour: int.parse(element.data['time'].split(':')[0]),
            minute: int.parse(element.data['time'].split(':')[1]));

        if (rcontroller.fromTime.value == rcontroller.untilTime.value) {
          passesTimeFilter = element.data['time'] == rcontroller.fromTime.value;
        } else {
          passesTimeFilter = getTime(fromTime, untilTime, initTime);
        }
      }

      return passesDateFilter && passesTimeFilter;
    }).toList();

    // Add results to report list
    for (var json in tempList) {
      rcontroller.reportList.add(reportClass.fromJson(json.data));
    }

    return true;
  }

  bool getTime(TimeOfDay ft, TimeOfDay lt, TimeOfDay it) {
    int ftMin = ft.hour * 60 + ft.minute;
    int ltMin = lt.hour * 60 + ft.minute;
    int itMin = it.hour * 60 + it.minute;

    return ftMin < itMin && itMin <= ltMin;
  }
}
