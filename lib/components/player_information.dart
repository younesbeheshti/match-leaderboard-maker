import 'dart:ui';

import 'package:flutter/material.dart';

class Player {
  String name;
  int number;
  int score;
  int loses = 0;
  int wins = 0;
  bool isWin = false;
  Color color = Color(0xFF323232);

  Player(
      {required this.name,
      this.score = 0,
      this.isWin = false,
      this.number = 0});

  String getName() {
    return this.name;
  }

  int getScore() => this.score;

  int getLoses() => this.loses;

  int getWins() => this.wins;

  bool getIsWin() => this.isWin;

  Color getColor() => this.color;

  int getNumber() => this.number;

  void setScore(int score) => this.score = score;

  void setIsWin(bool isWin) => this.isWin = isWin;

  void setColor(Color color) => this.color = color;

  void setNumber(int number) => this.number = number;

  void incrementLoses() => this.loses++;

  void incrementWins() => this.wins++;

  void defaultColor() => this.color = Color(0xFF323232);
}
