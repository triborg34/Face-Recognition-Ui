import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UnknowBox extends StatelessWidget {
  const UnknowBox({
    super.key,
    required this.mController,
    required this.nController,
  });

  final mainController mController;
  final networkController nController;

  void _resetSelection() {
    mController.unknownSelector.value = -1;
    mController.isPersonSelected.value = false;
    mController.personSelector.value = -1;
  }

  void _selectUnknownPerson(int index) {
    mController.unknownSelector.value = index;
    mController.isPersonSelected.value = true;
    mController.personSelector.value = -1;
    mController.globalIndex.value = index;
  }

  Widget _buildUnknownPersonCard(int index) {
    final person = nController.personList[index];
    
    if (person.name != 'unknown') {
      return const SizedBox.shrink();
    }

    return Obx(() => InkWell(
      onTap: () => _selectUnknownPerson(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: mController.unknownSelector.value == index
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
            padding: const EdgeInsets.all(15),
            width: 50.w,
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
                  "افراد ناشناس",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  textDirection: TextDirection.rtl,
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    nController.personList.length,
                    (index) => _buildUnknownPersonCard(index),
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