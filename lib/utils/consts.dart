import 'package:faceui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<GetPage> pages = [GetPage(name: '/', page: () => MainScreen())];

Color primaryColor = Color.fromARGB(255, 25, 32, 71);

List ofCamera = ['Camera 1 ', 'Camera 2 ', "Camera 3", "Camera 4", "Camera 5"];

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
