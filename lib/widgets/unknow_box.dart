import 'package:cached_network_image/cached_network_image.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:math' as math;

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

  void _loadMoreUnknown() {
    mController.unknownDisplayCount.value += 16;
  }

  Widget _buildUnknownPersonCard(int index, dynamic person) {
    return Obx(() => InkWell(
          onTap: () {
            mController.person = person;
            _selectUnknownPerson(index);
          },
          borderRadius: BorderRadius.circular(15),
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
                width: mController.unknownSelector.value == index ? 3 : 1,
              ),
              boxShadow: mController.unknownSelector.value == index
                  ? [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: _buildPersonImage(person),
          ),
        ));
  }

  Widget _buildPersonImage(dynamic person) {
    // Check if tempFrame exists and is not empty
    if (person.tempFrame == null || person.tempFrame.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[200],
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: RepaintBoundary(
        child: Image(
          image: MemoryImage(person.tempFrame),
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading memory image: $error");
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red[100],
              ),
              child: const Icon(
                Icons.error,
                color: Colors.red,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }

  List<dynamic> _getFilteredPersons() {
    return nController.personList
        .where((person) => person.name == 'unknown')
        .toList();
  }

  List<Widget> _buildPersonCards(List<dynamic> unknownPersons) {
    // Get the actual indices from the original list for proper selection handling
    Map<dynamic, int> personToOriginalIndex = {};
    for (int i = 0; i < nController.personList.length; i++) {
      if (nController.personList[i].name == 'unknown') {
        personToOriginalIndex[nController.personList[i]] = i;
      }
    }

    return unknownPersons
        .map((person) => _buildUnknownPersonCard(
              personToOriginalIndex[person]!,
              person,
            ))
        .toList(growable: false);
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
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "افراد ناشناس",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Reset display count when toggling
                        mController.unknownDisplayCount.value = 16;
                        mController.isUnknownExpand.value =
                            !mController.isUnknownExpand.value;
                        mController.isRegisterExpand.value = false;
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Obx(() {
                  final unknownPersons = _getFilteredPersons();
                  
                  if (unknownPersons.isEmpty) {
                    return Container(
                      height: 100,
                      child: const Center(
                        child: Text(
                          "هیچ فرد ناشناسی یافت نشد",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  List<Widget> allPersonCards = _buildPersonCards(unknownPersons);
                  
                  // Progressive loading: show up to displayCount items
                  int currentDisplayCount = math.min(
                    mController.unknownDisplayCount.value, 
                    allPersonCards.length
                  );
                  
                  List<Widget> displayedCards = allPersonCards.sublist(0, currentDisplayCount);
                  bool hasMore = currentDisplayCount < allPersonCards.length;

                  return Column(
                    children: [
                      Wrap(
                        textDirection: TextDirection.rtl,
                        spacing: 10,
                        runSpacing: 10,
                        children: displayedCards,
                      ),
                      if (hasMore)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: _loadMoreUnknown,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16, 
                                vertical: 10
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "نمایش 16 نفر بیشتر (${allPersonCards.length - currentDisplayCount} باقی مانده)",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!hasMore && allPersonCards.length > 16)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "همه ${allPersonCards.length} نفر نمایش داده شدند",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}