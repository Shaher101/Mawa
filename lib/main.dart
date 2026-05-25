import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_flow_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // ✅ الـ design size — الشاشة اللي صممت عليها (iPhone 14 مقاس افتراضي)
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(debugShowCheckedModeBanner: false, home: child);
      },
      child: AppFlowScreen(),
    );
  }
}
