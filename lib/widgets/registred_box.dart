import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

    if (person.name == 'unknown') {
      return const SizedBox.shrink();
    }

    return Obx(() => InkWell(
          onTap: () => _selectPerson(index),
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
      child: Image.network(
        'http://127.0.0.1:8090/api/files/collection/${person.id}/${person.croppedFrame}',
        fit: BoxFit.fill,
      ),
    );
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
                const Text(
                  "افراد ثبت شده",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  alignment: WrapAlignment.start,
                  textDirection: TextDirection.rtl,
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(

                    nController.personList.length,
                    (index) => _buildPersonCard(index),
                  ).reversed.toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
