import 'dart:convert';
import 'package:faceui/models/personModels.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/utils/testpage.dart';
import 'package:http/http.dart' as http;
import 'package:faceui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
// import 'package:audioplayers/audioplayers.dart';


String role = '';
String email = '';
String url = '127.0.0.1';
String port = "8000";


List<GetPage> pages = [GetPage(name: '/', page: () => MainScreen()),GetPage(name: '/test', page:() =>  Test())];
var pb =PocketBase('http://${url}:8091');
Color primaryColor = Color.fromARGB(255, 25, 32, 71);





Future<Map<String, dynamic>?> uploadFile(List<int> fileBytes, String filename) async {
    try {
          final uri = Uri.parse('http://127.0.0.1:8000/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filename,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        
        return {
          'fileLocation': responseData['file_location'],
          'imageData': base64Decode(responseData['image_data']),
          'mediaType': responseData['media_type'],
        };
      }
      return null;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }







String fakeHashAndEncrypt(int number) {
  // Step 1: Fake hash by adding a number and a string
  String mixed = '${number + 1337}_secret';

  // Step 2: Fake encryption by reversing the string
  String encrypted = mixed.split('').reversed.join();

  return encrypted;
}


void onRelayOne() async {
  Uri uri = Uri.parse("http://${url}:${port}/iprelay?onOff=true&relay=1");
  await http.get(uri);
}

void onRelayTwo() async {
  Uri uri = Uri.parse("http://${url}:${port}/iprelay?onOff=true&relay=2");
  await http.get(uri);
}

// void alarmPlay(personClass entry) {
//   if (Get.find<settinController>().isAlarm.value) {
//     AudioPlayer audioPlayer = AudioPlayer();
//     if (Get.find<personController>()
//         .knownList
//         .where(
//           (element) => element.name != entry.name,
//         )
//         .isNotEmpty) {
//       audioPlayer.play(UrlSource('assets/alarm.mp3'));
//     }

//     http.post(Uri.parse('http://127.0.0.1:8000/email?email=${email}'), body: {
//       "plateNumber": entry.name,
//       "eDate": entry.date,
//       "eTime": entry.time
//     });
//   }
// }

void relayAutomatic(personClass entry) {
  if (Get.find<settinController>().isRfid.value) {
    if (Get.find<personController>()
        .knownList
        .where(
          (element) => element.name == entry.name,
        )
        .isNotEmpty) {
      if (Get.find<settinController>().isrlOne.value &&
          Get.find<settinController>().isrlTwo.value) {
        onRelayOne();
        onRelayTwo();
      } else if (Get.find<settinController>().isrlOne.value == true &&
          Get.find<settinController>().isrlTwo.value == false) {
        onRelayOne();
      } else if (Get.find<settinController>().isrlOne.value == false &&
          Get.find<settinController>().isrlTwo.value == true) {
        onRelayTwo();
      }
    }
  }
}


