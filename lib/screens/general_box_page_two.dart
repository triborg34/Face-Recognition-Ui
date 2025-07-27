import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:faceui/widgets/sliderWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GeneralBoxPageTwo extends StatelessWidget {
  GeneralBoxPageTwo({
    required this.scontroller,
    super.key,
  });

  settinController scontroller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: primaryColor,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "عمومی",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                      child: Container(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
                          SlidersWidgets(scontroller: scontroller),
                          SizedBox(
                            height: 15,
                          ),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                ipFunction("نام شبکه", "Lan"),
                                SizedBox(
                                  height: 10,
                                ),
                                ipFunction("آدرس شبکه", url),
                                SizedBox(
                                  height: 10,
                                ),
                                ipFunction("نوع آدرس", 'IPV4'),
                              ],
                            ),
                          )),
                          ElevatedButton(
                              onPressed: () async {
                                final body = <String, dynamic>{
                                  "score": double.parse(scontroller.score.value
                                      .toStringAsFixed(2)),
                                  "padding": scontroller.padding.value,
                                  "isRfid": scontroller.isRfid.value,
                                  "rl1": scontroller.isrlOne.value,
                                  "rl2": scontroller.isrlTwo.value,
                                  "rfidip": scontroller.rfipController.text,
                                  "rfidport": int.parse(
                                      scontroller.rfportConroller.text),
                                  "alarm": scontroller.isAlarm.value,
                                  "quality":
                                      (scontroller.quality.value).toInt(),
                                  'rfconnect': scontroller.rfconnect.value
                                };

                                try {
                                  final record = await pb
                                      .collection('setting')
                                      .update(scontroller.settings.first.id!,
                                          body: body);
                                  ScaffoldMessenger.maybeOf(context)!
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    "با موفقیت انجام شد ${record.id}",
                                    textDirection: TextDirection.rtl,
                                  )));
                                } catch (e) {
                                  ScaffoldMessenger.maybeOf(context)!
                                      .showSnackBar(
                                          SnackBar(content: Text("خطا")));
                                }
                              },
                              child: Text(
                                "ذخیره",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ))
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 15,
                  ),
                  VerticalDivider(
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Container(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "اتصال به رله",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Obx(() => Switch(
                                  value: scontroller.isRfid.value,
                                  onChanged: (value) async {
                                    scontroller.isRfid.value = value;
                                  },
                                )),
                            Obx(() => Visibility(
                                  visible: scontroller.isRfid.value,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                              controller:
                                                  scontroller.rfipController,
                                              readOnly: false,
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'arial'),
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'eg:192.168.1.91',
                                                  hintTextDirection:
                                                      TextDirection.ltr))),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                              controller:
                                                  scontroller.rfportConroller,
                                              readOnly: false,
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'arial'),
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'eg:2000',
                                                  hintTextDirection:
                                                      TextDirection.ltr))),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "رله یک",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Obx(() => Checkbox(
                                            value: scontroller.isrlOne.value,
                                            onChanged: (value) {
                                              scontroller.isrlOne.value =
                                                  value!;
                                            },
                                          )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "رله دو",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Obx(() => Checkbox(
                                            value: scontroller.isrlTwo.value,
                                            onChanged: (value) {
                                              scontroller.isrlTwo.value =
                                                  value!;
                                            },
                                          )),
                                      TextButton(
                                          onPressed: () async {
                                            if (Get.find<settinController>()
                                                .isRfid
                                                .value) {
                                              Uri uri = Uri.parse(
                                                  'http://${url}:${port}/iprelay?ip=${scontroller.rfipController.text}&port=${scontroller.rfportConroller.text}');

                                              var res = await http.post(
                                                uri,
                                                body: {"isconnect": false},
                                              );
                                              if (res.statusCode == 200) {
                                                scontroller.rfconnect.value =
                                                    !scontroller
                                                        .rfconnect.value;
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "اتصال قطع شد",
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl)));
                                            } else {
                                              Uri uri = Uri.parse(
                                                  'http://${url}:${port}/iprelay?ip=${scontroller.rfipController.text}&port=${scontroller.rfportConroller.text}');

                                              var res = await http.post(
                                                uri,
                                                body: {"isconnect": true},
                                              );
                                              if (res.statusCode == 200) {
                                                scontroller.rfconnect.value =
                                                    !scontroller
                                                        .rfconnect.value;
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "اتصال متصل شد",
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl)));
                                            }

                                            scontroller.rfconnect.value =
                                                !scontroller.rfconnect.value;
                                          },
                                          child: Text(
                                            scontroller.rfconnect.value
                                                ? "قطع"
                                                : "اتصال",
                                            style: TextStyle(fontSize: 16),
                                          )),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "فعال سازی آلارم",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Obx(() => Switch(
                                      value: scontroller.isAlarm.value,
                                      onChanged: (value) {
                                        scontroller.isAlarm.value = value;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("فعال شد",
                                                    textDirection:
                                                        TextDirection.rtl)));
                                      },
                                    )),
                              ],
                            )),
                      ]),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding ipFunction(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: [
          Container(
            width: 110,
            child: Text(
              "${label}:",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )
        ],
      ),
    );
  }
}
