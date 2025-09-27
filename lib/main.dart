
import 'package:faceui/screens/splash_screen.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/network_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'utils/bindings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) => GetMaterialApp(
        darkTheme: ThemeData(
          fontFamily: 'nazanin',
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
        ),
        theme: ThemeData(
          fontFamily: 'nazanin',
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
        ),
        getPages: pages,
        initialBinding: MyBindings(),
        debugShowCheckedModeBanner: false,
       home: SplashScreen(),
        onInit: () {
          var host = getNetworkInfo();
          url = host['hostname'];
          url='127.0.0.1';
          port = host['port'];
          port="8000";

        },
      ),
    );
  }


    //TODO:ADD SEARCH IMAGE TO FILTERS
  //TODO:LAST AND LEAST FIX RELAYS
//TODO:FIx issues for backend
}
