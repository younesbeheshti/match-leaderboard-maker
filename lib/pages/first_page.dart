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
    ["Asian Table", "/AsianTablePage"],
    ["Seeding", "/SidingPage"],
    ["MW Table", "/MWPage"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),  // Light Gray background
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF3F51B5),  // Indigo AppBar
        title: Text(
          "Match Leaderboard",
          style: TextStyle(color: Color(0xFFFFC107)),  // Amber Text
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
                  cardColor: Color(0xFF00BCD4),  // Cyan Card background
                  textColor: Color(0xFF212121),  // Dark Gray Text
                  iconColor: Color(0xFFFFC107),  // Amber Icons
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
