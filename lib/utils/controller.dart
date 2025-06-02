
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class mainController extends GetxController{

  var tabindex=2.obs;
  var videoIndex=(-1).obs;
  var personSelector=(-1).obs;
  var unknownSelector=(-1).obs;
  var isPersonSelected=false.obs;

}

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void toggleTheme() {
    if (Get.isDarkMode) {
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }
}

class reportController extends GetxController{
  var isImage=false.obs;
  var isName=false.obs;
  var isGender=false.obs;
  var genderValue='male'.obs;
  var isAge=false.obs;
  var isComplete=false.obs;
  
}

class cameraController extends GetxController {
  var cameras = <Map<String, dynamic>>[].obs;

  void startDiscovery() async {
    final uri = Uri.parse('http://127.0.0.1:8000/onvif/get-stream');
    final request = http.Request('GET', uri)
      ..headers['Accept'] = 'text/event-stream';

    final client = http.Client();
    final response = await client.send(request);

    response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      if (line.startsWith('data: ')) {
        final jsonStr = line.replaceFirst('data: ', '');
        final data = jsonDecode(jsonStr);
        cameras.add(data);
      }
    });
  }
}