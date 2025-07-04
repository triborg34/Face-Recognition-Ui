import 'dart:convert';
import 'package:faceui/utils/testpage.dart';
import 'package:http/http.dart' as http;
import 'package:faceui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

List<GetPage> pages = [GetPage(name: '/', page: () => MainScreen()),GetPage(name: '/test', page:() =>  Test())];
var pb =PocketBase('http://127.0.0.1:8090');
Color primaryColor = Color.fromARGB(255, 25, 32, 71);


// Future<Uint8List?> uploadAndGetImage(List<int> fileBytes, String filename) async {
//   try {
//     final uri = Uri.parse('http://127.0.0.1:8000/upload');
//     final request = http.MultipartRequest('POST', uri)
//       ..files.add(http.MultipartFile.fromBytes(
//         'file',
//         fileBytes,
//         filename: filename,
//       ));

//     final response = await request.send();
    
//     if (response.statusCode == 200) {
//       // Convert stream to bytes directly
//       final bytes = await response.stream.toBytes();
//       return Uint8List.fromList(bytes);
//     } else {
//       print('Error: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error uploading file: $e');
//     return null;
//   }
// }




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


