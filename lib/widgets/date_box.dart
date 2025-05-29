import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';

class DateBox extends StatelessWidget {
  const DateBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
            child: ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {},
                child: Text(
                  "از تاریخ",
                  style: TextStyle(color: Colors.white),
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
                onPressed: () {},
                child: Text(
                  "تا تاریخ",
                  style: TextStyle(color: Colors.white),
                )))
      ],
    );
  }
}
