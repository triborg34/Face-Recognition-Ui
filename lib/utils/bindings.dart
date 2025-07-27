
import 'package:faceui/utils/controller.dart';
import 'package:get/get.dart';

class MyBindings extends Bindings{
  @override
  void dependencies() {
    Get.put( mainController(),);
    Get.lazyPut(() => ThemeController(),);
    Get.put(reportController(),);
    Get.put( cameraController());
    Get.put(personController(),);
    Get.put(videoFeedController());
    Get.put(networkController());
    Get.put(userController());
    Get.put(settinController());
  }
}