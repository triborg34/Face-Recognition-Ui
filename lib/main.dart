import 'package:faceui/utils/consts.dart';
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
      builder: (context, orientation, screenType) =>  GetMaterialApp(
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
          
        ),
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
        ),
        getPages: pages,
        initialBinding: MyBindings(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
            
        
      ),
    );
  }
  //TODO:SETTING SCREEN???
}
