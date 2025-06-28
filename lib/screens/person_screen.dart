import 'dart:typed_data';

import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:file_picker/file_picker.dart';
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
                      onPressed: () async {
                        print(pcontroller.filepath.value);
                        await showAdaptiveDialog(
                          context: context,
                          builder: (context) => Center(
                              child: Material(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              height: 400,
                              width: 500,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "اضافه کردن شخص",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.image);
                                          if (result != null) {
                                            Uint8List fileBytes =
                                                result.files.first.bytes!;
                                            pcontroller.filename.value =
                                                result.files.single.name;

                                            try {
                                              // pcontroller.filepath.value =
                                                Map<String,dynamic>? data=  await uploadFile(
                                                fileBytes,
                                                result.files.single.name,
                                              );
                                              pcontroller.filepath.value =data!['imageData'];
                                              pcontroller.filename.value=data['fileLocation'];
                                             
                                    
                                            } catch (e) {
                                              print(e);
                                              await ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(SnackBar(
                                                      content: Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: Text(
                                                              "خطا در ارسال داده"))));
                                            }
                                          } else {
                                            await ScaffoldMessenger.maybeOf(
                                                    context)!
                                                .showSnackBar(SnackBar(
                                                    content: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text(
                                                            "خطا در انتخاب عکس"))));
                                          }
                                        },
                                        child: Obx(() => Container(
                                              // child: Center(
                                              //     child: pcontroller.filepath
                                              //                 .value!.length >
                                              //             0
                                              //         ? Image.memory(pcontroller
                                              //             .filepath.value!)
                                              //         : Icon(
                                              //             Icons.person,
                                              //             size: 36,
                                              //             color: Colors.indigo,
                                              //           )),
                                              width: 128,
                                              height: 128,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: pcontroller
                                                                  .filepath
                                                                  .value!
                                                                  .length >
                                                              0
                                                          ? MemoryImage(
                                                              pcontroller
                                                                  .filepath
                                                                  .value!,
                                                            )
                                                          : NetworkImage(
                                                              'assets/images/unknown-person1.png'),
                                                      fit: BoxFit.fill),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.indigo)),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 165,
                                            child: CoustomTextField3(
                                                hint: 'نام',
                                                tcontroller: pcontroller.name),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 165,
                                            child: CoustomTextField3(
                                                hint: 'نام خانوادگی',
                                                tcontroller:
                                                    pcontroller.lastName),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Obx(() => SizedBox(
                                                width: 100,
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child:
                                                      DropdownButtonFormField(
                                                          decoration: InputDecoration(
                                                              focusColor: Colors
                                                                  .transparent,
                                                              fillColor:
                                                                  Colors.indigo,
                                                              filled: true,
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent)),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent)),
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent))),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          value: pcontroller
                                                              .genterP.value,
                                                          items: [
                                                            DropdownMenuItem(
                                                                value: "male",
                                                                child: Text(
                                                                    "مرد")),
                                                            DropdownMenuItem(
                                                                value: "female",
                                                                child:
                                                                    Text("زن"))
                                                          ],
                                                          onChanged: (value) =>
                                                              pcontroller
                                                                      .genterP
                                                                      .value =
                                                                  value!),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 165,
                                            child: CoustomTextField3(
                                                hint: 'کد ملی',
                                                tcontroller:
                                                    pcontroller.socialNumber),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 165,
                                            child: CoustomTextField3(
                                                hint: 'سن',
                                                tcontroller:
                                                    pcontroller.ageNumber),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Obx(() => SizedBox(
                                                width: 100,
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child:
                                                      DropdownButtonFormField(
                                                          decoration: InputDecoration(
                                                              focusColor: Colors
                                                                  .transparent,
                                                              fillColor:
                                                                  Colors.indigo,
                                                              filled: true,
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent)),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent)),
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent))),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          value: pcontroller
                                                              .roleP.value,
                                                          items: [
                                                            DropdownMenuItem(
                                                                value:
                                                                    "approve",
                                                                child: Text(
                                                                    "مجاز")),
                                                            DropdownMenuItem(
                                                                value: "denied",
                                                                child: Text(
                                                                    "غیر مجاز"))
                                                          ],
                                                          onChanged: (value) =>
                                                              pcontroller.roleP
                                                                      .value =
                                                                  value!),
                                                ),
                                              ))
                                        ],
                                      ),
                                      Spacer(),
                                      Center(
                                          child: Container(
                                        width: 300,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "ثبت",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.indigo),
                                        ),
                                      ))
                                    ],
                                  )),
                            ),
                          )),
                        );
                      },
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
                                        //TODO :ICON BUTTON
                                        Icons.edit,
                                        size: 20,
                                      )),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        //TODO:ICON BUTTON
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
                                        Text(ofReport[i]['Time'].toString()),
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
