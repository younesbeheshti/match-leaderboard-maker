import 'package:flutter/material.dart';
import '../util/dimensions.dart';



class ClickablePlayerContainer extends StatefulWidget {
  final String playerName;
  final int number;
  final double topRadius;
  final double bottomRadius;
  final void Function() onTap;

  ClickablePlayerContainer({
    required this.playerName,
    required this.number,
    required this.topRadius,
    required this.bottomRadius,
    required this.onTap,
  });

  @override
  _ClickablePlayerContainerState createState() => _ClickablePlayerContainerState();
}

class _ClickablePlayerContainerState extends State<ClickablePlayerContainer> {

  bool _isClicked = false;


  void toggleClicked() {
    setState(() {
      _isClicked = !_isClicked;
      print(_isClicked);
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: toggleClicked,
      child: PlayerContainer(
        playerName: widget.playerName,
        number: widget.number,
        topRadius: widget.topRadius,
        bottomRadius: widget.bottomRadius,
        isClicked: _isClicked,
        color: _isClicked ? Color(0xFFF37329) : Color(0xFF626262),
      ),
    );
  }
}


class PlayerContainer extends StatelessWidget {
  final String playerName;
  final int number;
  final bool isClicked;
  final double topRadius;
  final double bottomRadius;
  final Color color;

  const PlayerContainer({
    required this.playerName,
    required this.number,
    required this.topRadius,
    required this.bottomRadius,
    required this.isClicked,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Radius _topLeft = Radius.circular(topRadius);
    Radius _topRight = Radius.circular(topRadius);
    Radius _bottomLeft = Radius.circular(bottomRadius);
    Radius _bottomRight = Radius.circular(bottomRadius);

    return Container(
      width: Dimensions.playerContainerWidth280,
      height: Dimensions.playerContainerHeight40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Dimensions.playerContainerHeight40,
            height: Dimensions.playerContainerHeight40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: _topLeft,
                bottomLeft: _bottomLeft,
              ),
              color: Color(0xFF838383),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: Dimensions.font18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF252525),
                ),
              ),
            ),
          ),
          Container(
            width: Dimensions.playerContainerWidth200,
            height: Dimensions.playerContainerHeight40,
            color: Color(0xFF626262),
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.playerContainerLeftPadding8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  playerName,
                  style: TextStyle(
                    fontSize: Dimensions.font18,
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
          Container(
            width: Dimensions.playerContainerHeight40,
            height: Dimensions.playerContainerHeight40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: _topRight,
                bottomRight: _bottomRight,
              ),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
