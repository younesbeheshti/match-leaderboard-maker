import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:match_leaderboard_maker/components/player_container.dart';
import 'package:match_leaderboard_maker/pages/elimination_page.dart';
import 'package:match_leaderboard_maker/util/dimensions.dart';

// import 'components/player_information.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  // List players = [
  //   Player(name: 'Player 1'),
  //   Player(name: 'Player 2'),
  //   Player(name: 'Player 3'),
  //   Player(name: 'Player 4'),
  // ];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late String playerName;
  late int number;
  bool isClicked = false;
  Color _color = Color(0xFF626262);

  void _onTap() {
    setState(() {
      isClicked = !isClicked;
      if (isClicked) {
        _color = Color(0xFFF37329);
      } else {
        _color = Color(0xFF626262);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: Text("hello"),//EliminationPage(),
      )
      /*Scaffold(
        appBar: AppBar(
          title: Text('SVG with Text and Button'),
        ),
        body: Center(
          child: Row(
            children: [
              Container(
                color: Colors.grey[200],
                width: 280,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlayerContainer(
                      playerName: "Yones beheshti",
                      number: 1,
                      bottomRadius: 0,
                      topRadius: 10,
                    ),
                    Divider(
                      color: Color(0xFF4d4d4d),
                      thickness: 0.3,
                      height: 0.2,
                    ),
                    PlayerContainer(
                      playerName: "Yones beheshti",
                      number: 1,
                      bottomRadius: 10,
                      topRadius: 0,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset("line_connector.svg"),
            ],
          ),
        ),
      ),*/
    );
  }
}
