import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeBox extends StatelessWidget {
  const TimeBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
            child: ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () async {
                  var picked = await showTimePicker(
                    context: context,
                    builder: (context, child) {
                      return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!);
                    },
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: TimeOfDay.now(),
                  );
                  final time;
                  if(picked!.hour > 9 && picked.minute >9){
                      time="${picked.hour}:${picked.minute}";
                  }  
                  else if(picked.hour >9 && picked.minute <=9){
                    time="${picked.hour}:0${picked.minute}";
                  }
                  else if(picked.hour <=9 && picked.minute >9 ){
                    time="0${picked.hour}:${picked.minute}";
                  }
                  else{
                    
                  }
                  Get.find<reportController>().fromTime.value="${picked.hour}:${picked.minute}";
                 Get.find<reportController>().isTime.value=true;
                },
                child: Text(
                Get.find<reportController>().fromTime.value=='' ?   "از ساعت" : Get.find<reportController>().fromTime.value,
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ))),
        SizedBox(
          width: 15,
        ),
        Icon(Icons.access_time),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () async {
                  var picked = await showTimePicker(
                    context: context,
                    builder: (context, child) {
                      return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!);
                    },
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: TimeOfDay.now(),
                  );
                  Get.find<reportController>().untilTime.value="${picked!.hour}:${picked.minute}";
                  Get.find<reportController>().isTime.value=true;
                },
                child: Text(
                 Get.find<reportController>().untilTime.value == '' ? "تا ساعت" : Get.find<reportController>().untilTime.value,
                  style: TextStyle(color: Colors.white,fontSize: 18),
                )))
      ],
    ));
  }
}
