import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';

class TimeBox extends StatelessWidget {
  const TimeBox({
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
                  "از ساعت",
                  style: TextStyle(color: Colors.white),
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
                onPressed: () {},
                child: Text(
                  "تا ساعت",
                  style: TextStyle(color: Colors.white),
                )))
      ],
    );
  }
}
