import 'package:faceui/utils/consts.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({
    super.key,
  });
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(15)),
      child: RawScrollbar(
        interactive: true,
        thumbVisibility: true,
        thickness: 12,
        trackColor: primaryColor,
        trackRadius: Radius.circular(10),
        trackVisibility: true,
        padding: EdgeInsets.all(10),
        radius: Radius.circular(10),
        controller: _pageController,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "عمومی",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  "ورود خودکار",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Expanded(child: Container())
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Center(
                  child: Text("Page Two"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Page Three"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Page Four"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Page Five"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
