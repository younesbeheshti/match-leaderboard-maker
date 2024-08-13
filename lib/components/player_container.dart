import 'dart:ui';
import 'package:flutter/material.dart';

import '../util/dimensions.dart';

class PlayerContainer extends StatefulWidget {


  String playerName;
  int number;

  double topRadius = 0;
  double bottomRadius = 0;

  PlayerContainer({
    required this.playerName,
    required this.number,
    required this.topRadius,
    required this.bottomRadius,
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
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

    print(Dimensions.screenHeight);
    print(Dimensions.screenWidth);

    Radius _topLeft = Radius.circular(widget.topRadius);
    Radius _topRight = Radius.circular(widget.topRadius);

    Radius _bottomLeft = Radius.circular(widget.bottomRadius);
    Radius _bottomRight = Radius.circular(widget.bottomRadius);

    return Container(
      width: 280,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: _topLeft,
                bottomLeft: _bottomLeft,
              ),
              color: Color(0xFF838383),
            ),
            child: Center(
              child: Text(
                widget.number.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF252525),
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 40,
            color: Color(0xFF626262),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.playerName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD8D8D8),
                    shadows: [
                      Shadow(
                        color: Color(0xFF000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: _topRight,
                  bottomRight: _bottomRight,
                ),
                color: _color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
