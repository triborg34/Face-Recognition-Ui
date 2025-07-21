import 'dart:typed_data';

import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/add_or_edit_person.dart';

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
                        await showAdaptiveDialog(
                          context: context,
                          builder: (context) => AddOrEditPerson(
                            pcontroller: pcontroller,
                            name: '',
                            lastName: '',
                            age: '',
                            filename: '',
                            filepath: Uint8List(0),
                            gender: 'male',
                            role: 'approve',
                            isEditing: false,
                            socialnumber: '',
                          ),
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
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 15,
                      runSpacing: 10,
                      children: [
                        for (int i = 0; i < pcontroller.knownList.length; i++)
                          Container(
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      onTap: () async {
                                        await showAdaptiveDialog(
                                          context: context,
                                          builder: (context) => AddOrEditPerson(
                                              id: pcontroller.knownList[i].id!,
                                              imagePath: pcontroller
                                                  .knownList[i].image!,
                                              pcontroller: pcontroller,
                                              name: pcontroller
                                                  .knownList[i].name!
                                                  .split(' ')[0],
                                              lastName: pcontroller
                                                  .knownList[i].name!
                                                  .split(' ')[1],
                                              age:
                                                  pcontroller.knownList[i].age!,
                                              gender: pcontroller
                                                  .knownList[i].gender!,
                                              role: pcontroller
                                                  .knownList[i].role!,
                                              socialnumber: pcontroller
                                                  .knownList[i].socialNumber!,
                                              isEditing: true),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () async {
                                        await pb
                                            .collection('known_face')
                                            .delete(
                                                pcontroller.knownList[i].id!);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    )),
                                Column(
                                  children: [
                                    Container(
                                      height: 110,
                                      child: Center(
                                        child: pcontroller.knownList[i].image!
                                                    .length >
                                                0
                                            ? null
                                            : Icon(
                                                Icons.person,
                                                size: 36,
                                                color: primaryColor,
                                              ),
                                      ),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'http://127.0.0.1:8091/api/files/known_face/${pcontroller.knownList[i].id}/${pcontroller.knownList[i].image}'),
                                            fit: BoxFit.contain),
                                        border: Border.all(color: primaryColor),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(pcontroller.knownList[i].name!),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(pcontroller.knownList[i].age!),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(pcontroller.knownList[i].gender ==
                                            'male'
                                        ? "مرد"
                                        : "زن"),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                        pcontroller.knownList[i].socialNumber!),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Icon(
                                      pcontroller.knownList[i].role == "approve"
                                          ? Icons.check_box
                                          : Icons.cancel,
                                      color: pcontroller.knownList[i].role ==
                                              "approve"
                                          ? Colors.green
                                          : Colors.red,
                                    )
                                  ],
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
