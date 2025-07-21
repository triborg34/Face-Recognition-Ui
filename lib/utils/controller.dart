import 'dart:convert';
import 'dart:typed_data';

import 'package:faceui/models/cameraClass.dart';
import 'package:faceui/models/knownPModels.dart';
import 'package:faceui/models/personModels.dart';
import 'package:faceui/models/reportClass.dart';
import 'package:faceui/models/settingClass.dart';
import 'package:faceui/models/userClass.dart';
import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class mainController extends GetxController {
  var tabindex = 1.obs;
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
  var isDate = false.obs;
  var isTime = false.obs;
  var isUnknown = false.obs;

  var filename = 'انتخاب'.obs;
  var filepath = Rxn<Uint8List>(Uint8List(0));
  var fromDate = ''.obs;
  var untilDate = ''.obs;
  var fromTime = ''.obs;
  var untilTime = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController sageController = TextEditingController();
  TextEditingController eageController = TextEditingController();

  var reportList = <reportClass>[].obs;
}

class cameraController extends GetxController {
  var searchCameras = <Map<String, dynamic>>[].obs;
  var cameras = <cameraClass>[].obs;

  var isRtspEnabled = false.obs;
  var gateWayc = 'entre'.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController rtspNameController = TextEditingController();
  TextEditingController rtspController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void startSub() {
    pb.collection('cameras').subscribe(
      '*',
      (e) {
        if (e.action == 'create') {
          cameras.add(cameraClass.fromJson(e.record!.data));
        } else if (e.action == 'delete') {
          cameras.removeWhere(
            (element) => element.id == e.record!.id,
          );
        } else {
          int index =
              cameras.indexWhere((element) => element.id == e.record!.id);
          if (index != -1) {
            cameras[index] = cameraClass.fromJson(e.record!.toJson());
          }
        }
      },
    );
  }

  fetchFirstData() async {
    final mList = await pb.collection('cameras').getFullList();
    for (var json in mList) {
      cameras.add(cameraClass.fromJson(json.data));
    }
  }

  @override
  void onReady() async {
    await fetchFirstData();
    startSub();
    super.onReady();
  }

  void startDiscovery() async {
    searchCameras.clear();
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
        searchCameras.add(data);
      }
    });
  }
}

class personController extends GetxController {
  RxBool isVisible = false.obs;
  RxBool isLoading = false.obs;
  var knownList = <knowPerson>[].obs;

  var roleP = 'approve'.obs;
  var genterP = 'male'.obs;
  var filename = ''.obs;
  var filepath = Rxn<Uint8List>(Uint8List(0));

  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController socialNumber = TextEditingController();
  TextEditingController ageNumber = TextEditingController();

  fetchFirstData() async {
    final kList = await pb.collection('known_face').getFullList();
    for (var json in kList) {
      knownList.add(knowPerson.fromJson(json.data));
    }
  }

  void startSub() {
    pb.collection('known_face').subscribe(
      '*',
      (e) {
        if (e.action == 'create') {
          knownList.add(knowPerson.fromJson(e.record!.data));
        } else if (e.action == 'delete') {
          knownList.removeWhere(
            (element) => element.id == e.record!.id,
          );
        } else {
          int index =
              knownList.indexWhere((element) => element.id == e.record!.id);
          if (index != -1) {
            knownList[index] = knowPerson.fromJson(e.record!.toJson());
          }
        }
      },
    );
  }

  @override
  void onReady() async {
    await fetchFirstData();
    startSub();
    super.onReady();
  }

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

  fetchFirstData() async {
    final mList =
        await pb.collection('collection').getFullList(sort: '-created');
    for (var json in mList) {
      personList.add(personClass.fromJson(json.data));
    }
  }

  void startSub() {
    pb.collection('collection').subscribe(
      '*',
      (e) {
        if (e.action == 'create') {
          personList.insert(0, personClass.fromJson(e.record!.data));
        } else if (e.action == 'delete') {
          personList.removeWhere(
            (element) => element.id == e.record!.id,
          );
        }
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

class userController extends GetxController {
  var users = <UsersClass>[].obs;
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  var role = 'admin'.obs;

  fetchFirstData() async {
    final kList = await pb.collection('users').getFullList();
    for (var json in kList) {
      users.add(UsersClass.fromJson(json.data));
    }
  }

  void startSub() {
    pb.collection('users').subscribe(
      '*',
      (e) {
        if (e.action == 'create') {
          users.add(UsersClass.fromJson(e.record!.data));
        } else if (e.action == 'delete') {
          users.removeWhere(
            (element) => element.id == e.record!.id,
          );
        } else {
          int index = users.indexWhere((element) => element.id == e.record!.id);
          if (index != -1) {
            users[index] = UsersClass.fromJson(e.record!.toJson());
          }
        }
      },
    );
  }

  @override
  void onInit() async {
    await fetchFirstData();
    startSub();

    super.onInit();
  }
}

class settinController extends GetxController {
  var settings = <SettingClass>[].obs;

  var padding = 0.obs;
  var score = 0.0.obs;
  var quality = 0.0.obs;

  var isRfid = false.obs;
  TextEditingController rfipController = TextEditingController();
  TextEditingController rfportConroller = TextEditingController();
  var isrlOne = false.obs;
  var isrlTwo = false.obs;
  var rfconnect = false.obs;

  var isAlarm = false.obs;

  fetchFirstData() async {
    final kList = await pb.collection('setting').getFullList();
    for (var json in kList) {
      settings.add(SettingClass.fromJson(json.data));
    }
  }

  void startSub() {
    pb.collection('setting').subscribe(
      '*',
      (e) {
        if (e.action == 'create') {
          settings.add(SettingClass.fromJson(e.record!.data));
        } else if (e.action == 'delete') {
          settings.removeWhere(
            (element) => element.id == e.record!.id,
          );
        } else {
          int index =
              settings.indexWhere((element) => element.id == e.record!.id);
          if (index != -1) {
            settings[index] = SettingClass.fromJson(e.record!.toJson());
          }
        }
      },
    );
  }

  firstIniliazed() async {
    score.value = settings.first.score!;
    padding.value = settings.first.padding!;
    quality.value = settings.first.quality!.toDouble();
    isRfid.value = settings.first.isRfid!;
    rfipController.text = settings.first.rfidip!;
    rfportConroller.text = settings.first.rfidport!.toString();
    isrlOne.value = settings.first.rl1!;
    isrlTwo.value = settings.first.rl2!;
    rfconnect.value = settings.first.rfconnect!;
    isAlarm.value = settings.first.isAlarm!;
  }

  checkForConnect() async {
    if (isRfid.value && rfconnect.value) {
      Uri uri = Uri.parse(
          'http://127.0.0.1:8000/iprelay?ip=${rfipController.text}&port=${rfportConroller.text}');

      await http.post(
        uri,
        body: {"isconnect": true},
      );
    }
  }

  @override
  void onInit() async {
    await fetchFirstData();
    await firstIniliazed();
    await checkForConnect();
    startSub();

    super.onInit();
  }
}
