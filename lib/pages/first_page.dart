import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/my_card.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List tables = [
    ["جدول یک حذفی", "/EliminationPage"],
    ["جدول دو حذفی", "/DoubleEliminationPage"],
    ["جدول آسیایی", "/AsianTablePage"],
    ["سیدبندی", "/SidingPage"],
    ["جدول MW ", "/MWPage"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[200] ?? Colors.grey,
        title: Text(
          "Match Leaderboard",
          style: TextStyle(color: Colors.orange),
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
                  cardColor: Colors.grey[200] ?? Colors.grey,
                  textColor: Colors.black,
                  iconColor: Colors.orange,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
