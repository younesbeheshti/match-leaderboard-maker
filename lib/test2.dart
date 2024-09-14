import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp(true));

class MyApp extends StatefulWidget {

  // final String playerName;
  // final int playerNum;
  bool isTrue = false;

  MyApp(this.isTrue, /*{required this.playerName, required this.playerNum}*/);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool check = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left : 190.0,),
                  child: widget.isTrue ? Container(
                    height: 200,
                    width: 90,
                    color: Colors.grey[200],
                    child: SvgPicture.asset("assets/line_shape.svg"),
                  ) : Container(),
                ),
                Container(
                  color: Colors.grey[200],
                  width: 200,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue,
                          ),
                          height: 50,
                          width: 200,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("1  player one"),
                                ),
                                Checkbox(value: check, onChanged: (value) {check = value!;}),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue,
                          ),
                          height: 50,
                          width: 200,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("1  player one"),
                                ),
                                Checkbox(value: check, onChanged: (value) {check = value!;}),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
