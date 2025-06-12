import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class DateBox extends StatelessWidget {
  const DateBox({
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
                  Jalali? picked = await showPersianDatePicker(
                    context: context,
                    builder: (context, child) {
                      return Localizations.override(
                        delegates: [
                          PersianMaterialLocalizations.delegate,
                          PersianCupertinoLocalizations.delegate,
                        ],
                        locale: Locale("fa", "IR"),
                        context: context,
                        child: Directionality(
                            textDirection: TextDirection.rtl, child: child!),
                      );
                    },
                    initialDate: Jalali.now(),
                    firstDate: Jalali(1385, 8),
                    lastDate: Jalali.max,
                    initialEntryMode: PersianDatePickerEntryMode.calendarOnly,
                    initialDatePickerMode: PersianDatePickerMode.day,
                  );
                  var date =
                      "${picked!.toGregorian().year}/${picked.toGregorian().month}/${picked.toGregorian().day}";
                  Get.find<reportController>().fromDate.value=date;
                },
                child: Text(
                Get.find<reportController>().fromDate.value=="" ?'از تاریخ' :  Get.find<reportController>().fromDate.value.toPersianDate(),
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ))),
        SizedBox(
          width: 15,
        ),
        Icon(Icons.date_range),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () async {
                  Jalali? picked = await showPersianDatePicker(
                    context: context,
                    builder: (context, child) {
                      return Localizations.override(
                        delegates: [
                          PersianMaterialLocalizations.delegate,
                          PersianCupertinoLocalizations.delegate,
                        ],
                        locale: Locale("fa", "IR"),
                        context: context,
                        child: Directionality(
                            textDirection: TextDirection.rtl, child: child!),
                      );
                    },
                    initialDate: Jalali.now(),
                    firstDate: Jalali(1385, 8),
                    lastDate: Jalali.max,
                    initialEntryMode: PersianDatePickerEntryMode.calendarOnly,
                    initialDatePickerMode: PersianDatePickerMode.day,
                  );
                  var date =
                      "${picked!.toGregorian().year}/${picked.toGregorian().month}/${picked.toGregorian().day}";
                  Get.find<reportController>().untilDate.value=date;
                  print(date);
                },
                child: Text(
                 Get.find<reportController>().untilDate.value=='' ? "تا تاریخ" : Get.find<reportController>().untilDate.value.toPersianDate(),
                  style: TextStyle(color: Colors.white,fontSize: 18),
                )))
      ],
    ));
  }
}
