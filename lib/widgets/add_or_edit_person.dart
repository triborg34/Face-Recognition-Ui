import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/coustom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOrEditPerson extends StatelessWidget {
  const AddOrEditPerson(
      {super.key,
      required this.pcontroller,
      required this.name,
      required this.lastName,
      this.filepath,
      this.filename,
      required this.age,
      required this.gender,
      required this.role,
      required this.socialnumber,
      required this.isEditing,
      this.id,
      this.imagePath});
  final personController pcontroller;
  final String name;
  final String lastName;
  final Uint8List? filepath;
  final String? filename;
  final String age;
  final String gender;
  final String role;
  final String socialnumber;
  final bool isEditing;
  final String? imagePath;
  final String? id;

  @override
  Widget build(BuildContext context) {
    pcontroller.name.text = name;
    pcontroller.lastName.text = lastName;
    pcontroller.socialNumber.text = socialnumber;
    pcontroller.ageNumber.text = age;
    pcontroller.roleP.value = role;
    pcontroller.genterP.value = gender;

    if (!isEditing) {
      pcontroller.filename.value = filename!;
      pcontroller.filepath.value = filepath;
    }

    return Center(
        child: Material(
      child: Container(
        padding: EdgeInsets.all(15),
        height: 400,
        width: 500,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(15)),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "اضافه کردن شخص",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      Uint8List fileBytes = result.files.first.bytes!;
                      pcontroller.filename.value = result.files.single.name;

                      try {
                        // pcontroller.filepath.value =
                        Map<String, dynamic>? data = await uploadFile(
                          fileBytes,
                          "${Random().nextInt(999)}.${pcontroller.filename.value}",'False'
                        );
                        pcontroller.filepath.value = data!['imageData'];
                        pcontroller.filename.value = data['fileLocation'];
                      } catch (e) {
                        print(e);
                        await ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                            SnackBar(
                                content: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text("خطا در ارسال داده"))));
                      }
                    } else {
                      await ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                          SnackBar(
                              content: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text("خطا در انتخاب عکس"))));
                    }
                  },
                  child: Obx(() => Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: pcontroller.filepath.value!.length > 0
                                    ? MemoryImage(
                                        pcontroller.filepath.value!,
                                      )
                                    : NetworkImage(isEditing
                                        ? 'http://${url}:8091/api/files/known_face/${id}/${imagePath}'
                                        : 'assets/images/unknown-person1.png'),
                                fit: BoxFit.fill),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.indigo)),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                          hint: 'نام', tcontroller: pcontroller.name),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                          hint: 'نام خانوادگی',
                          tcontroller: pcontroller.lastName),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Obx(() => SizedBox(
                          width: 100,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                    focusColor: Colors.transparent,
                                    fillColor: Colors.indigo,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                                borderRadius: BorderRadius.circular(15),
                                value: pcontroller.genterP.value,
                                items: [
                                  DropdownMenuItem(
                                      value: "male", child: Text("مرد")),
                                  DropdownMenuItem(
                                      value: "female", child: Text("زن"))
                                ],
                                onChanged: (value) =>
                                    pcontroller.genterP.value = value!),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                          hint: 'کد ملی',
                          tcontroller: pcontroller.socialNumber),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 165,
                      child: CoustomTextField3(
                          hint: 'سن', tcontroller: pcontroller.ageNumber),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Obx(() => SizedBox(
                          width: 100,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                    focusColor: Colors.transparent,
                                    fillColor: Colors.indigo,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                                borderRadius: BorderRadius.circular(15),
                                value: pcontroller.roleP.value,
                                items: [
                                  DropdownMenuItem(
                                      value: "approve", child: Text("مجاز")),
                                  DropdownMenuItem(
                                      value: "denied", child: Text("غیر مجاز"))
                                ],
                                onChanged: (value) =>
                                    pcontroller.roleP.value = value!),
                          ),
                        ))
                  ],
                ),
                Spacer(),
                Center(
                    child: Container(
                  width: 300,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () async {
                        pcontroller.isLoading.value = true;
                        Uri uri =
                            Uri.parse('http://${url}:${port}/insertKToDp');
                        Map<String, dynamic> body = {
                          "name":
                              "${pcontroller.name.text} ${pcontroller.lastName.text}",
                          "imagePath": pcontroller.filename.value,
                          'age': pcontroller.ageNumber.text,
                          'gender': pcontroller.genterP.value,
                          'socialnumber': pcontroller.socialNumber.text,
                          "role": pcontroller.roleP.value
                        };
                        try {
                          if (isEditing) {
                            final record = await pb
                                .collection('known_face')
                                .update(id!, body: body);
                                   ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                                SnackBar(content: Text(record.id)));
                                
                          } else {
                            final response = await await http.post(uri,
                                body: jsonEncode(body),
                                headers: {'Content-Type': "application/json"});
                            ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                                SnackBar(content: Text(response.body)));
                          }
                        } catch (e) {
                          ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        } finally {
                          pcontroller.isLoading.value = false;
                          Navigator.pop(context);
                        }
                      },
                      child: pcontroller.isLoading.value
                          ? CircularProgressIndicator()
                          : Text(
                              'ثبت',
                              style: TextStyle(color: Colors.white),
                            ))),
                ))
              ],
            )),
      ),
    ));
  }
}
