import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:faceui/models/reportClass.dart';
import 'package:faceui/models/userClass.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/age_box.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:faceui/widgets/date_box.dart';
import 'package:faceui/widgets/gender_box.dart';
import 'package:faceui/widgets/image_box.dart';
import 'package:faceui/widgets/name_box.dart';
import 'package:faceui/widgets/time_box.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
      // Get.find<reportController>().isComplete.value=false;
      Get.find<reportController>().isPressed.value = false;
      Get.find<reportController>().isDate.value = false;
      Get.find<reportController>().isTime.value = false;
      Get.find<reportController>().isPersonType.value = false;
      Get.find<reportController>().personTypeValue.value = 'colleague';
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
                      width: 350,
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
                                  "${Random().nextInt(999)}.${result.files.single.name}";

                              try {
                                Map<String, dynamic>? data = await uploadFile(
                                    fileBytes,
                                    rcontroller.filename.value,
                                    "True");
                                rcontroller.filepath.value = data!['imageData'];
                                rcontroller.filelocation.value =
                                    data['fileLocation'];
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
          IgnorePointer(
            ignoring: rcontroller.isImage.value,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: rcontroller.isImage.value ? 0.5 : 1,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  NameBox(
                    rcontroller: rcontroller,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SocialBox(
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
                  _buildPersonTypeFilter(rcontroller),
                  SizedBox(
                    height: 15,
                  ),
                  DateBox(),
                  SizedBox(
                    height: 15,
                  ),
                  TimeBox(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Center(
            child: SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                  style: TextButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () async {
                    if (Get.find<settinController>().isReportLock.value) {
                      TextEditingController? password = TextEditingController();
                      UsersClass user =
                          Get.find<userController>().users.firstWhere(
                                (element) => element.username == 'admin',
                              );
                      await showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15)),
                              width: 300,
                              height: 80,
                              child: Center(
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height: 70,
                                      child: Material(
                                          color: Colors.blue,
                                          child: CoustomTextField5(
                                            controller: password,
                                            hint: "رمز عبور",
                                            width: 250,
                                            onsubmit: (value) async {
                                              if (value ==
                                                  utf8.decode(base64.decode(
                                                      user.password!))) {
                                                Navigator.pop(context);
                                                await searchReport(
                                                    rcontroller, context);
                                              } else {
                                                ScaffoldMessenger.maybeOf(
                                                        context)!
                                                    .showSnackBar(SnackBar(
                                                        content: Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child: Text(
                                                                "رمز اشتباه است"))));
                                              }
                                            },
                                          )),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (password.text ==
                                              utf8.decode(base64
                                                  .decode(user.password!))) {
                                            Navigator.pop(context);
                                            await searchReport(
                                                rcontroller, context);
                                          } else {
                                            ScaffoldMessenger.maybeOf(context)!
                                                .showSnackBar(SnackBar(
                                                    content: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text(
                                                            "رمز اشتباه است"))));
                                          }
                                        },
                                        child: Text("تایید"))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      await searchReport(rcontroller, context);
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

  Future<void> searchReport(
      reportController rcontroller, BuildContext context) async {
    rcontroller.isPressed.value = true;
    rcontroller.reportList.clear();
    rcontroller.isComplete.value = false;

    try {
      if (rcontroller.isImage.value) {
        rcontroller.isComplete.value = await getImages(rcontroller);
      } else {
        rcontroller.isComplete.value = await getResult(rcontroller);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text("خطا در جستجو لطفا دوباره امتحان کنید"))));
    }
  }

  Future<bool> getImages(reportController rcontroller) async {
    var response = await http.get(Uri.parse(
        "http://${url}:${port}/util/imageSearch?fileLocation=${rcontroller.filelocation}"));

    for (String data in jsonDecode(response.body)) {
      final json =
          await pb.collection('collection').getFirstListItem('id="$data"');

      final request = await http.get(Uri.parse(
          'http://${url}:8091/api/files/collection/${json.data['id']}/${json.data['cropped_frame']}'));
      Uint8List tempUint = request.bodyBytes;
      rcontroller.reportList.add(reportClass(
          age: json.data['age'],
          camera: json.data['camera'],
          collectionId: json.data['collectionId'],
          collectionName: json.data['collectionName'],
          created: json.data['created'],
          croppedFrame: json.data['cropped_frame'],
          date: json.data['date'],
          frame: json.data['frame'],
          gender: json.data['gender'],
          id: json.data['id'],
          role: json.data['role'],
          imageByte: tempUint,
          name: json.data['name'],
          score: json.data['score'],
          time: json.data['time'],
          socialnumber: json.data['socialnumber'],
          trackId: json.data['track_id'],
          updated: json.data['updated']));
      ;
    }

    return true;
  }

  Future<bool> getResult(reportController rcontroller) async {
    if (rcontroller.isDate.value && rcontroller.untilDate.value.length == 0) {
      rcontroller.untilDate.value = rcontroller.fromDate.value;
    }
    if (rcontroller.isTime.value && rcontroller.untilTime.value.length == 0) {
      rcontroller.untilTime.value = rcontroller.fromTime.value;
    }
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
    if (rcontroller.isSocialNUmber.value) {
      filters.add('socialnumber="${rcontroller.socialValue.text}"');
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

    // If person type filter is active, get matching names from known_face first
    // List<String>? personTypeNames;
    // if (rcontroller.isPersonType.value) {
    //   try {
    //     final knownRecords = await pb
    //         .collection('known_face')
    //         .getFullList(
    //             filter: 'role="${rcontroller.personTypeValue.value}"');
    //     personTypeNames = knownRecords
    //         .map((r) => r.data['name']?.toString() ?? '')
    //         .where((n) => n.isNotEmpty)
    //         .toList();
    //     if (personTypeNames.isEmpty) {
    //       rcontroller.reportList.clear();
    //       return true;
    //     }
    //   } catch (e) {
    //     personTypeNames = null;
    //   }
    // }

    final records = await pb
        .collection('collection')
        .getFullList(filter: filterString, sort: '-created');
    var tempList = records.where((element) {
      bool passesDateFilter = true;
      bool passesTimeFilter = true;
      bool passesPersonTypeFilter = true;

      // if (personTypeNames != null) {
      //   final recordName = element.data['name']?.toString() ?? '';
      //   passesPersonTypeFilter = personTypeNames.contains(recordName);
      // }
      if (rcontroller.isDate.value) {
        DateTime fromDate = DateTime.parse(rcontroller.fromDate.value);
        DateTime untilDate = DateTime.parse(rcontroller.untilDate.value);

        DateTime initDate = DateTime.parse(element.data['date']);
        print("${fromDate} , ${untilDate} , ${initDate}");

        if (rcontroller.fromDate.value == rcontroller.untilDate.value ||
            rcontroller.untilDate.value == '') {
          passesDateFilter =
              element.data['date'] == rcontroller.untilDate.value;
        } else {
          passesDateFilter =
              initDate.isBefore(untilDate) && initDate.isAfter(fromDate);
        }
      }
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

        if (rcontroller.fromTime.value == rcontroller.fromTime.value) {
          passesTimeFilter = element.data['time'] == rcontroller.fromTime.value;
        } else {
          passesTimeFilter = getTime(fromTime, untilTime, initTime);
        }
      }
      return passesTimeFilter && passesDateFilter && passesPersonTypeFilter;
    }).toList();

    for (var json in tempList) {
      // rcontroller.reportList.add(reportClass.fromJson(json.data));
      final repsonse = await http.get(Uri.parse(
          'http://${url}:8091/api/files/collection/${json.data['id']}/${json.data['cropped_frame']}'));
      Uint8List tempUint = repsonse.bodyBytes;
      rcontroller.reportList.add(reportClass(
          age: json.data['age'],
          camera: json.data['camera'],
          collectionId: json.data['collectionId'],
          collectionName: json.data['collectionName'],
          created: json.data['created'],
          croppedFrame: json.data['cropped_frame'],
          date: json.data['date'],
          frame: json.data['frame'],
          gender: json.data['gender'],
          id: json.data['id'],
          role: json.data['role'],
          imageByte: tempUint,
          name: json.data['name'],
          score: json.data['score'],
          time: json.data['time'],
          socialnumber: json.data['socialnumber'],
          trackId: json.data['track_id'],
          updated: json.data['updated']));
    }
    if (rcontroller.isPersonType.value) {
      List<reportClass> tempclass = [];

      rcontroller.reportList.forEach(
        (element) {
          for (var person in Get.find<personController>().knownList) {
            if (element.name == person.name &&
                rcontroller.personTypeValue.value == person.userwhom) {
              tempclass.add(reportClass(
                  age: element.age,
                  camera: element.camera,
                  collectionId: element.collectionId,
                  collectionName: element.collectionName,
                  created: element.created,
                  croppedFrame: element.croppedFrame,
                  date: element.date,
                  frame: element.frame,
                  gender: element.gender,
                  id: element.id,
                  imageByte: element.imageByte,
                  name: element.name,
                  role: element.role,
                  score: element.score,
                  socialnumber: element.socialnumber,
                  time: element.time,
                  trackId: element.trackId,
                  updated: element.updated,
                  userwhom: person.userwhom));
            }
          }
        },
      );
      rcontroller.reportList.value = tempclass;
    }

    return true;

    // If no filters are active, return empty result
    // if (filterString.isEmpty) {
    //   final records = await pb.collection('collection').getFullList();
    //   for (var json in records) {
    //     // rcontroller.reportList.add(reportClass.fromJson(json.data));
    //     final repsonse = await http.get(Uri.parse(
    //         'http://${url}:8091/api/files/collection/${json.data['id']}/${json.data['cropped_frame']}'));
    //     Uint8List tempUint = repsonse.bodyBytes;
    //     rcontroller.reportList.add(reportClass(
    //         age: json.data['age'],
    //         camera: json.data['camera'],
    //         collectionId: json.data['collectionId'],
    //         collectionName: json.data['collectionName'],
    //         created: json.data['created'],
    //         croppedFrame: json.data['cropped_frame'],
    //         date: json.data['date'],
    //         frame: json.data['frame'],
    //         gender: json.data['gender'],
    //         id: json.data['id'],
    //         role: json.data['role'],
    //         imageByte: tempUint,
    //         name: json.data['name'],
    //         score: json.data['score'],
    //         time: json.data['time'],
    //         trackId: json.data['track_id'],
    //         updated: json.data['updated']));
    //   }

    //   return true;
    // }

    // // Fetch records from database
    // final records =
    //     await pb.collection('collection').getFullList(filter: filterString);
    // print('Filter: $filterString');

    // // Apply date and time filters in memory
    // var tempList = records.where((element) {
    //   bool passesDateFilter = true;
    //   bool passesTimeFilter = true;

    //   // Apply date filter if active
    //   if (rcontroller.isDate.value) {
    //     DateTime fromDate = DateTime.parse(rcontroller.fromDate.value);
    //     DateTime untilDate = DateTime.parse(rcontroller.untilDate.value);
    //     DateTime initDate = DateTime.parse(element.data['date']);

    //     if (rcontroller.fromDate.value == rcontroller.untilDate.value ||
    //         rcontroller.untilDate.value == '') {
    //       passesDateFilter = element.data['date'] == rcontroller.fromDate.value;
    //     } else {
    //       passesDateFilter =
    //           initDate.isBefore(untilDate) && initDate.isAfter(fromDate);
    //     }
    //   }

    //   // Apply time filter if active
    //   if (rcontroller.isTime.value) {
    //     TimeOfDay fromTime = TimeOfDay(
    //         hour: int.parse(rcontroller.fromTime.value.split(':')[0]),
    //         minute: int.parse(rcontroller.fromTime.value.split(':')[1]));
    //     TimeOfDay untilTime = TimeOfDay(
    //         hour: int.parse(rcontroller.untilTime.value.split(':')[0]),
    //         minute: int.parse(rcontroller.untilTime.value.split(':')[1]));
    //     TimeOfDay initTime = TimeOfDay(
    //         hour: int.parse(element.data['time'].split(':')[0]),
    //         minute: int.parse(element.data['time'].split(':')[1]));

    //     if (rcontroller.fromTime.value == rcontroller.untilTime.value) {
    //       passesTimeFilter = element.data['time'] == rcontroller.fromTime.value;
    //     } else {
    //       passesTimeFilter = getTime(fromTime, untilTime, initTime);
    //     }
    //   }

    //   return passesDateFilter && passesTimeFilter;
    // }).toList();

    // // Add results to report list
    // for (var json in tempList) {
    //   rcontroller.reportList.add(reportClass.fromJson(json.data));
    // }

    // return true;
  }

  bool getTime(TimeOfDay ft, TimeOfDay lt, TimeOfDay it) {
    int ftMin = ft.hour * 60 + ft.minute;
    int ltMin = lt.hour * 60 + ft.minute;
    int itMin = it.hour * 60 + it.minute;

    return ftMin < itMin && itMin <= ltMin;
  }

  Widget _buildPersonTypeFilter(reportController rcontroller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Obx(() => Checkbox(
                  value: rcontroller.isPersonType.value,
                  onChanged: (val) {
                    rcontroller.isPersonType.value = val ?? false;
                  },
                  // activeColor: primaryColor,
                )),
            Text(
              "نوع شخص",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Obx(() => rcontroller.isPersonType.value
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text('همکار', style: TextStyle(fontSize: 12)),
                        value: 'colleague',
                        groupValue: rcontroller.personTypeValue.value,
                        onChanged: (val) {
                          rcontroller.personTypeValue.value = val!;
                        },
                        // activeColor: primaryColor,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title:
                            Text('ارباب رجوع', style: TextStyle(fontSize: 12)),
                        value: 'visitor',
                        groupValue: rcontroller.personTypeValue.value,
                        onChanged: (val) {
                          rcontroller.personTypeValue.value = val!;
                        },
                        // activeColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()),
      ],
    );
  }
}
