import 'dart:convert';

import 'package:faceui/models/cameraClass.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/add_or_edit_camera.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends StatelessWidget {
  final cameraController ccontroller = Get.find<cameraController>();

  @override
  Widget build(BuildContext context) {
    // ccontroller.startDiscovery();

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(25),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await showAdaptiveDialog(
                          context: context,
                          builder: (context) => AddOrEditCamera(
                            ccontroller: ccontroller,
                            context: context,
                            name: '',
                            ip: '',
                            port: '',
                            isRtsp: false,
                            gate: 'entre',
                            password: '',
                            rtsp: '',
                            rtspName: '',
                            username: '',
                            isDiscovery: false,
                            isEditing: false,
                          ),
                        );
                      },
                      child: Text(
                        "اضافه کردن",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => Container(
                        height: 300,
                        color: Colors.transparent,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                textDirection: TextDirection.rtl,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: Text((index + 1).toString())),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      ccontroller.cameras[index].id.toString(),
                                      style: TextStyle(fontFamily: 'robot'),
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                        child: Text(ccontroller
                                            .cameras[index].name
                                            .toString())),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      ccontroller.cameras[index].ip.toString(),
                                      style: TextStyle(fontFamily: 'robot'),
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      ccontroller.cameras[index].port
                                          .toString(),
                                      style: TextStyle(fontFamily: 'robot'),
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        ccontroller.cameras[index].gate
                                                    .toString() ==
                                                "entre"
                                            ? "ورود"
                                            : "خروج",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Center(
                                        child: Text(
                                      ccontroller.cameras[index].rtspUrl
                                          .toString(),overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'robot'),
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      ccontroller.cameras[index].username!
                                          .toString(),
                                      style: TextStyle(fontFamily: 'robot'),
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: IconButton(
                                            onPressed: () async {
                                              cameraClass data =
                                                  ccontroller.cameras[index];
                                              await showAdaptiveDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AddOrEditCamera(
                                                        ccontroller:
                                                            ccontroller,
                                                        context: context,
                                                        name: data.name!,
                                                        ip: data.ip!,
                                                        port: data.port!,
                                                        rtsp: data.rtspUrl!,
                                                        rtspName: data.rtspName!,
                                                        username:
                                                            data.username!,
                                                        password: utf8.decode(
                                                            base64.decode(data
                                                                .password!)),
                                                        isRtsp: data.isRtsp!,
                                                        gate: data.gate!,
                                                        id: data.id,
                                                        isEditing: true,
                                                        isDiscovery: false),
                                              );
                                            },
                                            icon: Icon(Icons.edit))),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () async {
                                        await pb.collection('cameras').delete(
                                            ccontroller.cameras[index].id!);
                                        ScaffoldMessenger.maybeOf(context)!
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Camera Number ${ccontroller.cameras[index].id!} is Deleted")));
                                      },
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: primaryColor))),
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(vertical: 0),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor)),
                            );
                          },
                          itemCount: ccontroller.cameras.length,
                        ),
                      ))
                ],
              ),
            )),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        ccontroller.startDiscovery();
               
                      },
                      child: Text(
                        "جستجو",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 300,
                    child: Obx(() => ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor)),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(child: Text(index.toString())),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                ),
                                Container(
                                  width: 100,
                                  height: 50,
                                  child: Center(
                                      child: Text(ccontroller
                                          .searchCameras[index]['ip'])),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                ),
                                Container(
                                  width: 100,
                                  height: 50,
                                  child: Center(
                                      child: Text(ccontroller
                                          .searchCameras[index]['port']
                                          .toString())),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                ),
                                Container(
                                  width: 100,
                                  height: 50,
                                  child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            showAdaptiveDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AddOrEditCamera(
                                                      ccontroller: ccontroller,
                                                      context: context,
                                                      name: '',
                                                      ip: ccontroller
                                                          .searchCameras[index]
                                                              ['ip']
                                                          .toString(),
                                                      port: ccontroller
                                                          .searchCameras[index]
                                                              ['port']
                                                          .toString(),
                                                      isRtsp: false,
                                                      gate: 'entre',
                                                      password: '',
                                                      rtsp: '',
                                                      rtspName: 'stream',
                                                      username: '',
                                                      isDiscovery: true,
                                                      isEditing: false,
                                                    ));
                                          },
                                          icon: Icon(Icons.add))),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: ccontroller.searchCameras.length)),
                  )
                ],
              ),
            )),
          ],
        ));
  }

}
