import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/player_information.dart';
import 'package:match_leaderboard_maker/pages/double_elimination_page.dart';
import 'package:match_leaderboard_maker/pages/first_page.dart';
import 'package:get/get.dart';
import 'package:match_leaderboard_maker/pages/home_page.dart';
import 'package:match_leaderboard_maker/provider/player_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // int i = 0;
  // List players = List.filled(16, Player(
  //   name: 'Player${i+ 1}',
  //   number: 0,
  // ));
  List<Player> players = List<Player>.generate(16, (index) {
    Player obj = Player(
      name: 'Player${index + 1}',
      number: 0);
    return obj;
  });
  bool _doShuffle = false;

  MyApp({super.key});

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
        home: FirstPage()
        // ChangeNotifierProvider(create: (_) => PlayerProvider(
        //   players: players,
        //   doShuffle: false,
        //   isDoubleElimination: true,
        // ),
        //   child: DoubleEliminationPage(),)
        ,
      ),
    );
  }
}
