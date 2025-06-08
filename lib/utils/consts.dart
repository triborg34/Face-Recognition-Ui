import 'package:faceui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

List<GetPage> pages = [GetPage(name: '/', page: () => MainScreen())];
var pb =PocketBase('http://127.0.0.1:8090');
Color primaryColor = Color.fromARGB(255, 25, 32, 71);

var cameras=["rtsp://192.168.1.245:554/stream"];

var ofRegistred = [for (int i = 0; i < 50; i++) "Person ${i}"];

var ofUnknown = [for (int i = 0; i < 50; i++) "Unknown ${i}"];

var ofReport = [
  for (int i = 0; i < 50; i++)
    {
      "Image": "image $i",
      "Id ${i}": i,
      "Name": "Name of $i",
      "Gender": "Gender ${i}",
      "Age": "age ${i}",
      "Date": "date ${i}",
      'Conf': "conf $i",
      "Time": "time $i",
      "Camera": "camera $i"
    }
];


String fakeHashAndEncrypt(int number) {
  // Step 1: Fake hash by adding a number and a string
  String mixed = '${number + 1337}_secret';

  // Step 2: Fake encryption by reversing the string
  String encrypted = mixed.split('').reversed.join();

  return encrypted;
}
var CamearOf = [
  for (int i = 0; i < 10; i++)
    {
      "ID":'ID ${i}',

      "Camera name": "Camera Number $i",
      "IP": "192.168.1.$i",
      "Port": 80,
      "Gate": 'Gate $i',
      "Licance":fakeHashAndEncrypt(i)
      ,"RTSP" : 'rtsp://192.168.1.$i:554/mainstream'
    }
];


