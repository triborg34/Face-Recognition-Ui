import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
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
                        //TODO:SHOW A SCREEN THAT PROMT FOR ADD
                      },
                      child: Text(
                        "اضافه کردن",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
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
                                child: Center(child: Text(index.toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Center(
                                    child:
                                        Text(CamearOf[index]['ID'].toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                child: Center(
                                    child: Text(CamearOf[index]['Camera name']
                                        .toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                child: Center(
                                    child:
                                        Text(CamearOf[index]['IP'].toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                child: Center(
                                    child: Text(
                                        CamearOf[index]['Port'].toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                child: Center(
                                    child: Text(
                                        CamearOf[index]['Gate'].toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 250,
                                height: 50,
                                child: Center(
                                    child: Text(
                                        CamearOf[index]['RTSP'].toString())),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Center(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.edit))),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
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
                                  onPressed: () {},
                                )),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: primaryColor))),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(vertical: 0),
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor)),
                        );
                      },
                      itemCount: CamearOf.length,
                    ),
                  )
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
                        //TODO:SHOW A SCREEN THAT PROMT FOR ADD
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
                                      child: Text(
                                          ccontroller.cameras[index]['ip'])),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                              
                                ),
                                               Container(
                                  width: 100,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                          ccontroller.cameras[index]['port'].toString())),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                              
                                              
                                ),
                                               Container(
                                  width: 100,
                                  height: 50,
                                  child: Center(
                                      child: IconButton(onPressed: (){
                                        //TODO:ADD TO RTSP AND SO ON
                                      }, icon: Icon(Icons.add))),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: primaryColor))),
                                              
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: ccontroller.cameras.length)),
                  )
                ],
              ),
            )),
          ],
        ));
  }
}
