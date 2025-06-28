import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:flutter/material.dart';

class RtspOn extends StatelessWidget {
  const RtspOn({
    super.key,
    required this.ccontroller,
  });

  final cameraController ccontroller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.ltr,
      children: [
        SizedBox(
          width: 15,
        ),
        SizedBox(
          width: 300,
          child: CoustomTextField2(
              hint: "RTSP URL", tcontroller: ccontroller.rtspController),
        ),
        SizedBox(
          width: 40,
          child: IconButton(
            icon: Icon(
              Icons.change_circle,
              color: primaryColor,
              size: 28,
            ),
            onPressed: () => ccontroller.isRtspEnabled.value =
                !ccontroller.isRtspEnabled.value,
          ),
        ),
      ],
    );
  }
}
