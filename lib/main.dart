import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/pages/first_page.dart';
import 'package:get/get.dart';
import 'package:match_leaderboard_maker/provider/player_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlayerProvider(
            players: [],
            doShuffle: false,
            isDoubleElimination: false,
          ),
        ),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
        home: FirstPage(),
      ),
    );
  }
}
