
import 'package:faceui/utils/controller.dart';
import 'package:get/get.dart';

class MyBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => mainController(),);
    Get.lazyPut(() => ThemeController(),);
    Get.put(reportController(),);
    Get.lazyPut(() =>  cameraController());
    Get.lazyPut(() => personController(),);
    Get.put(videoFeedController());
    Get.put(networkController());
  }
}