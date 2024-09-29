import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/pages/home_page.dart';

class MyCard extends StatelessWidget {
  final String tableType;
  final String routeName;
  final String imagePath;
  final Color cardColor;
  final Color textColor;
  final Color iconColor;

  MyCard({
    required this.tableType,
    required this.routeName,
    required this.imagePath,
    this.cardColor = Colors.white,
    this.textColor = Colors.black,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          tableType,
          style: TextStyle(color: textColor),
        ),
        trailing: Icon(Icons.arrow_forward, color: iconColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(routeName: routeName,)),
          );
        },
      ),
    );
  }
}
