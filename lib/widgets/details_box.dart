import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsBox extends StatelessWidget {
  const DetailsBox(
      {super.key, required this.mController, required this.nController});

  final mainController mController;
  final networkController nController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => mController.globalIndex.value == (-1)
        ? SizedBox.shrink()
        : Expanded(
            child: AnimatedCrossFade(
            duration: Duration(milliseconds: 500),
            crossFadeState: mController.isPersonSelected.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: SizedBox.shrink(),
            firstChild: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      nController
                          .personList[mController.globalIndex.value].name!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(nController
                                    .personList[mController.globalIndex.value]
                                    .croppedFrame!
                                    .length ==
                                0
                            ? 'assets/images/unknown-person1.png'
                            : 'http://127.0.0.1:8090/api/files/collection/${nController.personList[mController.globalIndex.value].id}/${nController.personList[mController.globalIndex.value].croppedFrame}'),
                      ),
                      Icon(Icons.arrow_forward),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          nController
                                    .personList[mController.globalIndex.value]
                                    .croppedFrame!
                                    .length ==
                                0
                            ? 'assets/images/unknown-person1.png' :
                            "http://127.0.0.1:8090/api/files/known_face/${nController.knownList.firstWhere(
                                  (p0) =>
                                      p0.name ==
                                      nController
                                          .personList[
                                              mController.globalIndex.value]
                                          .name,
                                ).id!}/${nController.knownList.firstWhere(
                                  (p0) =>
                                      p0.name ==
                                      nController
                                          .personList[
                                              mController.globalIndex.value]
                                          .name,
                                ).image!}"),
                        radius: 60,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CoustomRow(
                    substring: nController
                        .personList[mController.globalIndex.value].id!,
                    title: "ID",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CoustomRow(
                      title: "Track_ID",
                      substring: nController
                          .personList[mController.globalIndex.value].trackId!),
                  SizedBox(
                    height: 10,
                  ),
                  CoustomRow(
                      title: "Gender",
                      substring: nController
                          .personList[mController.globalIndex.value].gender!),
                  SizedBox(
                    height: 10,
                  ),
                  CoustomRow(
                      title: "Age",
                      substring: nController
                          .personList[mController.globalIndex.value].age!),
                  SizedBox(
                    height: 10,
                  ),
                  CoustomRow(
                      title: "Confidnce",
                      substring:
                          "${nController.personList[mController.globalIndex.value].score}%"),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: Container(
                    child: nController.personList[mController.globalIndex.value]
                                .frame!.length ==
                            0
                        ? Center(child: Icon(Icons.person))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'http://127.0.0.1:8090/api/files/collection/${nController.personList[mController.globalIndex.value].id}/${nController.personList[mController.globalIndex.value].frame}',
                              fit: BoxFit.fill,
                            ),
                          ),
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(15)),
                  ))
                ],
              ),
            ),
          )));
  }
}
