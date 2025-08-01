import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/camera_feed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoBox extends StatelessWidget {
  const VideoBox({
    super.key,
    required this.mController,
  });

  final mainController mController;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mController.videoIndex.value = -1;
      },
      child: Container(
        padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: 500,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primaryColor)),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 15,
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i <Get.find<cameraController>().cameras.length; i++)
                Obx(
                  () => InkWell(
                    onTap: () {
                      mController.videoIndex.value = i;
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      width: mController.videoIndex.value == i ? 500 : 225,
                      height: mController.videoIndex.value == i ? 300 : 100,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: mController.videoIndex.value == i
                                  ? Colors.indigoAccent
                                  : primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          CameraFeed(
                              streamUrl:
                                  'http://${url}:${port}/rt${i+1}?source=${Get.find<cameraController>().cameras[i].rtspUrl}'),
                          GestureDetector(
                            onTap: () => mController.videoIndex.value = i,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
