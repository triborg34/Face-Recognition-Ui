import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:flutter/material.dart';

class RtspOff extends StatelessWidget {
  const RtspOff({
    super.key,
    required this.ccontroller,
  });

  final cameraController ccontroller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        SizedBox(
          width: 5,
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
        SizedBox(
          width: 130,
          child: CoustomTextField2(
              hint: "Rtsp Name", tcontroller: TextEditingController()),
        ),SizedBox(width: 10,),
        SizedBox(
          width: 60,
          child: CoustomTextField2(
              hint: "Port", tcontroller: TextEditingController()),
        ),SizedBox(width: 10,),
        SizedBox(
          width: 100,
          child: CoustomTextField2(
              hint: "IP", tcontroller: TextEditingController()),
        )
      ],
    );
  }
}
