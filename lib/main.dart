import 'package:faceui/screens/splash_screen.dart';
import 'package:faceui/utils/consts.dart';
import 'package:faceui/utils/network_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pocketbase/pocketbase.dart';

import 'utils/bindings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set URL/port BEFORE runApp so `pb` initializes with correct values.
  var host = getNetworkInfo();
  url = host['hostname'] ?? '127.0.0.1';
  // port =  '8003';

  // Reinitialize pb with the correct URL (it was created with defaults).
  pb = PocketBase('http://$url:8091');

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
          fontFamilyFallback: ['arial', 'robot'],
          fontFamily: 'nazanin',
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
        ),
        getPages: pages,
        initialBinding: MyBindings(),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
