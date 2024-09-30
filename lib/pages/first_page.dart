import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/my_card.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List tables = [
    ["Single Elimination", "/EliminationPage"],
    ["Double Elimination", "/DoubleEliminationPage"],
    // ["Asian Table", "/AsianTablePage"],
    // ["MW Table", "/MWPage"],
    ["Periodic Table", "/PeriodicPage"]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF323232),  // Darker Gray Background
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF323232),  // Darker Gray AppBar
        title: Text(
          "Match Leaderboard",
          style: TextStyle(color: Color(0xFFF37329)),  // Bright Orange Text
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 700,
            child: ListView.builder(
              itemCount: tables.length,
              itemBuilder: (context, index) {
                return MyCard(
                  tableType: tables[index][0],
                  routeName: tables[index][1],
                  imagePath: 'assets/bracket.png',
                  cardColor: Color(0xFF626262),  // Medium Gray Card background
                  textColor: Color(0xFFD8D8D8),  // Light Gray Text
                  iconColor: Color(0xFFF37329),  // Bright Orange Icons
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
