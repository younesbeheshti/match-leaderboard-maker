import 'dart:ui';

import 'package:flutter/material.dart';

class Player {
  String name;
  int score;
  bool isWin = false;
  Color color = Color(0xFF027EFA);

  Player({required this.name, this.score = 0});

  String getName() {
    return this.name;
  }

  int getScore() => this.score;
  bool getIsWin() => this.isWin;
  Color getColor() => this.color;

  void setScore(int score) => this.score = score;
  void setIsWin(bool isWin) => this.isWin = isWin;
  void setColor(Color color) => this.color = color;

  void defaultColor() => this.color = Color(0xFF027EFA);
}
