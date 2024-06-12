import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tournament Bracket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF2A2D37),
      ),
      home: BracketPage(),
    );
  }
}

class BracketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Bracket'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(800, 600), // Adjusted size to fit the bracket
          painter: BracketPainter(),
        ),
      ),
    );
  }
}

class BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final textStyle = TextStyle(color: Colors.white, fontSize: 14);

    // Draw the brackets for the first round
    drawMatchup(
        canvas, paint, textStyle, Offset(50, 50), Offset(200, 50), '1', '8');
    drawMatchup(
        canvas, paint, textStyle, Offset(50, 150), Offset(200, 150), '4', '5');
    drawMatchup(
        canvas, paint, textStyle, Offset(50, 250), Offset(200, 250), '2', '7');
    drawMatchup(
        canvas, paint, textStyle, Offset(50, 350), Offset(200, 350), '3', '6');

    // Draw the brackets for the second round
    drawMatchup(
        canvas, paint, textStyle, Offset(300, 100), Offset(450, 100), '', '');
    drawMatchup(
        canvas, paint, textStyle, Offset(300, 300), Offset(450, 300), '', '');

    // Draw the final bracket
    drawMatchup(
        canvas, paint, textStyle, Offset(550, 200), Offset(700, 200), '', '');

    // Connect the brackets for the first round to the second round
    drawConnector(canvas, paint, Offset(200, 50), Offset(300, 100));
    drawConnector(canvas, paint, Offset(200, 150), Offset(300, 100));
    drawConnector(canvas, paint, Offset(200, 250), Offset(300, 300));
    drawConnector(canvas, paint, Offset(200, 350), Offset(300, 300));

    // Connect the brackets for the second round to the final round
    drawConnector(canvas, paint, Offset(450, 100), Offset(550, 200));
    drawConnector(canvas, paint, Offset(450, 300), Offset(550, 200));
  }

  void drawMatchup(Canvas canvas, Paint paint, TextStyle textStyle,
      Offset team1, Offset team2, String team1Name, String team2Name) {
    canvas.drawLine(team1, Offset(team1.dx + 100, team1.dy), paint);
    canvas.drawLine(team2, Offset(team2.dx + 100, team2.dy), paint);

    final textPainter1 = TextPainter(
      text: TextSpan(text: team1Name, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    final textPainter2 = TextPainter(
      text: TextSpan(text: team2Name, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter1.layout();
    textPainter2.layout();

    textPainter1.paint(canvas, Offset(team1.dx + 10, team1.dy - 10));
    textPainter2.paint(canvas, Offset(team2.dx + 10, team2.dy - 10));
  }

  void drawConnector(Canvas canvas, Paint paint, Offset start, Offset end) {
    canvas.drawLine(start, Offset(start.dx + 50, start.dy), paint);
    canvas.drawLine(
        Offset(start.dx + 50, start.dy), Offset(start.dx + 50, end.dy), paint);
    canvas.drawLine(Offset(start.dx + 50, end.dy), end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
