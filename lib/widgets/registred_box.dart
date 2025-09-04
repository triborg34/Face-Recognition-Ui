import 'package:cached_network_image/cached_network_image.dart';

import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:math' as math;

class RegistredBox extends StatelessWidget {
  const RegistredBox({
    super.key,
    required this.mController,
    required this.nController,
  });

  final mainController mController;
  final networkController nController;

  void _resetSelection() {
    mController.personSelector.value = -1;
    mController.isPersonSelected.value = false;
    mController.unknownSelector.value = -1;
  }

  void _selectPerson(int index) {
    mController.personSelector.value = index;
    mController.unknownSelector.value = -1;
    mController.isPersonSelected.value = true;
    mController.globalIndex.value = index;
  }

  Widget _buildPersonCard(int index) {
    final person = nController.personList[index];

    return Obx(() => InkWell(
          onTap: () {
            mController.person = person;
            _selectPerson(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: mController.personSelector.value == index
                    ? Colors.indigo
                    : primaryColor,
              ),
            ),
            child: _buildPersonImage(person),
          ),
        ));
  }

  Widget _buildPersonImage(dynamic person) {
    if (person.croppedFrame?.isEmpty ?? true) {
      return const Icon(Icons.person);
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl:
                "http://${url}:8091/api/files/collection/${person.id}/${person.croppedFrame}",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: primaryColor,
                )),
            errorWidget: (context, url, error) => Icon(Icons.error)));
    //     Image.network(
    //       'http://${url}:8091/api/files/collection/${person.id}/${person.croppedFrame}',
    //       loadingBuilder: (BuildContext context, Widget child,
    //     ImageChunkEvent? loadingProgress) {
    //   if (loadingProgress == null) {
    //     // Image fully loaded
    //     return child;
    //   } else {
    //     // Still loading → show progress
    //     return Center(
    //       child: CircularProgressIndicator(
    //         value: loadingProgress.expectedTotalBytes != null
    //             ? loadingProgress.cumulativeBytesLoaded /
    //                 (loadingProgress.expectedTotalBytes ?? 1)
    //             : null,
    //       ),
    //     );
    //   }
    // },
    //       fit: BoxFit.fill,
    //     ),
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _resetSelection,
        child: SingleChildScrollView(
          child: Container(
            width: 50.w,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "افراد ثبت شده",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.expand),
                      onPressed: () => mController.isRegisterExpand.value =
                          !mController.isRegisterExpand.value,
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Builder(builder: (context) {
                  List<Widget> registred = nController.personList
                      .asMap()
                      .entries
                      .where((entry) =>
                          entry.value.name != 'unknown') // Filter out unknown
                      .map((entry) => _buildPersonCard(entry.key))
                      .toList(growable: true);
                  registred =
                      registred.sublist(0, math.min(16, registred.length));

                  return Wrap(
                      alignment: WrapAlignment.start,
                      textDirection: TextDirection.rtl,
                      spacing: 10,
                      runSpacing: 10,
                      children: registred);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
