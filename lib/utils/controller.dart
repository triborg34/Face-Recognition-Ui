import 'dart:convert';
import 'dart:typed_data';

import 'package:faceui/models/knownPModels.dart';
import 'package:faceui/models/personModels.dart';
import 'package:faceui/models/reportClass.dart';
import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class mainController extends GetxController {
  var tabindex = 2.obs;
  var videoIndex = (-1).obs;
  var personSelector = (-1).obs;
  var unknownSelector = (-1).obs;
  var isPersonSelected = false.obs;
  var globalIndex = (-1).obs;
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

class reportController extends GetxController {
  var isImage = false.obs;
  var isName = false.obs;
  var isGender = false.obs;
  var genderValue = 'male'.obs;
  var isAge = false.obs;
  var isComplete = false.obs;
  var isDate=false.obs;
  var isTime=false.obs;
  var isUnknown=false.obs;

  var filename='انتخاب'.obs;
 var filepath= Rxn<Uint8List>(Uint8List(0));
var fromDate=''.obs;
var untilDate=''.obs;
var fromTime=''.obs;
var untilTime=''.obs;
 TextEditingController nameController=TextEditingController();
 TextEditingController familyController=TextEditingController();
 TextEditingController sageController=TextEditingController();
 TextEditingController eageController=TextEditingController();

  var reportList=<reportClass>[].obs;
}




class cameraController extends GetxController {
  var cameras = <Map<String, dynamic>>[].obs;
  var gateWayc='entre'.obs;
  var isRtspEnabled = false.obs;

  void startDiscovery() async {
    cameras.clear();
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

class personController extends GetxController {
  RxBool isVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), () {
      isVisible.value = true;
    });
  }

  @override
  void onClose() {
    isVisible.value = false;
    super.onClose();
  }
}

class videoFeedController extends GetxController {
  final _cameras = <String, html.ImageElement>{}.obs;

  void connect(String url, String viewId) {
    final imgElement = html.ImageElement()
      ..src = url
      ..id = viewId
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover';

    _cameras[viewId] = imgElement;
  }

  html.ImageElement? getElement(String viewId) => _cameras[viewId];

  void disconnect(String viewId) {
    print(viewId);
    final element = _cameras[viewId];
    if (element != null) {
      element.src = '';
      element.remove();
      _cameras.remove(viewId);
    }
  }

  /// 🔌 Disconnects all active camera streams
  void disconnectAll() {
    final keys = _cameras.keys.toList(); // Avoid concurrent modification
    for (final viewId in keys) {
      disconnect(viewId);
    }
  }

  @override
  void onClose() {
    disconnectAll();
    super.onClose();
  }
}

class networkController extends GetxController {
  var personList = <personClass>[].obs;
  var knownList=<knowPerson>[].obs;
 


  fetchFirstData() async {
    final mList = await pb.collection('collection').getFullList();
    for (var json in mList) {
      personList.add(personClass.fromJson(json.data));
    }

    final kList=await pb.collection('known_face').getFullList();
    for (var json in kList){
      knownList.add(knowPerson.fromJson(json.data));

    }
  }

  void startSub() {
    pb.collection('collection').subscribe(
      '*',
      (e) {
        if (e.action == 'create') {
          personList.add(personClass.fromJson(e.record!.data));
        }
        print(e.record);
      },
    );
  }

  @override
  void onReady() async {
    await fetchFirstData();
    startSub();
    super.onReady();
  }
}
