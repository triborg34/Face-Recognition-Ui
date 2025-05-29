import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/details_box.dart';
import 'package:faceui/widgets/person_box.dart';
import 'package:faceui/widgets/video_box.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.mController,
  });

  final mainController mController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VideoBox(mController: mController),
        PersonBox(mController: mController),
        DetailsBox(mController: mController)
      ],
    );
  }
}
