import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/pages/first_page.dart';
import 'package:match_leaderboard_maker/pages/home_page.dart';
import 'package:match_leaderboard_maker/pages/login_page.dart';
import 'package:match_leaderboard_maker/pages/periodic_table.dart';
import 'package:match_leaderboard_maker/test.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(

        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      // ResponsiveLayout(
      //   mobileScaffold: MobileScaffold(),
      //   tabletScaffold: TabletScaffold(),
      //   desktopScaffold: DesktopScaffold(),
      // ),
    );
  }
}
