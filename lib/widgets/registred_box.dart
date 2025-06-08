import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegistredBox extends StatelessWidget {
  const RegistredBox(
      {super.key, required this.mController, required this.nController});

  final mainController mController;
  final networkController nController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        mController.personSelector.value = -1;
        mController.isPersonSelected.value = false;
        mController.unknownSelector.value = -1;
      },
      child: SingleChildScrollView(
        child: Container(
          width: 50.w,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "افراد ثبت شده",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(
                textDirection: TextDirection.rtl,
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int i = 0; i < nController.personList.length; i++)
                    Obx(() => InkWell(
                          onTap: () {
                            mController.personSelector.value = i;
                            mController.unknownSelector.value = -1;
                            mController.isPersonSelected.value = true;
                            mController.globalIndex.value=i;
                          },
                          child: nController.personList[i].name == 'unknown'
                              ? SizedBox.shrink()
                              : AnimatedContainer(
                                  duration: Duration(milliseconds: 250),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color:
                                            mController.personSelector.value ==
                                                    i
                                                ? Colors.indigo
                                                : primaryColor,
                                      )),
                                  child:  nController.personList[i].croppedFrame!
                                              .length ==
                                          0
                                      ? Icon(Icons.person)
                                      : ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                            'http://127.0.0.1:8090/api/files/collection/${nController.personList[i].id}/${nController.personList[i].croppedFrame}',
                                            fit: BoxFit.fill,
                                          ),
                                      ),
                                ),
                        ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
