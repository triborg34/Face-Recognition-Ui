// import 'dart:math';

import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/add_or_edit_person.dart';
import 'package:faceui/widgets/coustom_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailsBox extends StatelessWidget {
  const DetailsBox({
    super.key,
    required this.mController,
    required this.nController,
  });

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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPersonName(context),
                    SizedBox(height: 15),
                    _buildAvatarComparison(),
                    SizedBox(height: 15),
                    _buildPersonDetails(),
                    SizedBox(height: 15),
                    _buildFullImage(),
                  ],
                ),
              ),
            ),
          ));
  }

  Widget _buildPersonName(context) {
    final person = nController.personList[mController.globalIndex.value];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        person.name == "unknown"
            ? IconButton(
                onPressed: () async {
                  final response = await http.get(Uri.parse(
                      'http://127.0.0.1:8090/api/files/collection/${person.id}/${person.croppedFrame}'));

                  await showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AddOrEditPerson(
                            filename:
                                'http://127.0.0.1:8090/api/files/collection/${person.id}/${person.humancrop}',
                            filepath: response.bodyBytes,
                            pcontroller: Get.find<personController>(),
                            name: '',
                            lastName: '',
                            age: person.age!,
                            gender: person.gender!,
                            role: 'approve',
                            socialnumber: '',
                            isEditing: false);
                      });
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ))
            : person.role=='approve' ? Icon(
                Icons.check_sharp,
                color: Colors.green,
              ):Icon(
                Icons.cancel,
                color: Colors.red,
              ),
        Text(
          person.name! == "unknown" ? "ناشناس" : person.name!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        IconButton(
            onPressed: () async {
              await pb.collection('collection').delete(person.id!);
            },
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ))
      ],
    );
  }

  Widget _buildAvatarComparison() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetectedAvatar(),
        Icon(Icons.arrow_forward),
        _buildKnownAvatar(),
      ],
    );
  }

  Widget _buildDetectedAvatar() {
    final person = nController.personList[mController.globalIndex.value];
    final hasImage = person.croppedFrame?.isNotEmpty ?? false;

    return CircleAvatar(
      radius: 60,
      backgroundImage: NetworkImage(
        hasImage
            ? 'http://127.0.0.1:8090/api/files/collection/${person.id}/${person.croppedFrame}'
            : 'assets/images/unknown-person1.png',
      ),
    );
  }

  Widget _buildKnownAvatar() {
    final person = nController.personList[mController.globalIndex.value];
    final hasImage = person.croppedFrame?.isNotEmpty ?? false;

    if (!hasImage) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage('assets/images/unknown-person1.png'),
      );
    }

    try {
      final knownPerson = Get.find<personController>().knownList.firstWhere(
            (p) => p.name == person.name,
          );
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(
          'http://127.0.0.1:8090/api/files/known_face/${knownPerson.id}/${knownPerson.image}',
        ),
      );
    } catch (e) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage('assets/images/unknown-person1.png'),
      );
    }
  }

  Widget _buildPersonDetails() {
    final person = nController.personList[mController.globalIndex.value];

    return Column(
      children: [
        CoustomRow(title: "شناسه", substring: person.id!),
        SizedBox(height: 10),
        CoustomRow(title: "شماره شناسایی", substring: person.trackId!),
        SizedBox(height: 10),
        CoustomRow(
            title: "جنسیت", substring: person.gender! == 'male' ? "مرد" : "زن"),
        SizedBox(height: 10),
        CoustomRow(title: "سن", substring: person.age!),
        SizedBox(height: 10),
        CoustomRow(
            title: "اطمینان",
            substring: person.name == "unknown" ? "96%" : "${person.score}%"),
      ],
    );
  }

  Widget _buildFullImage() {
    final person = nController.personList[mController.globalIndex.value];
    final hasFrame = person.frame?.isNotEmpty ?? false;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: hasFrame
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'http://127.0.0.1:8090/api/files/collection/${person.id}/${person.frame}',
                  fit: BoxFit.fill,
                ),
              )
            : Center(child: Icon(Icons.person)),
      ),
    );
  }
}
