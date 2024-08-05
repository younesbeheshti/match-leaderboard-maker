import 'package:flutter/material.dart';

class PeriodicTable extends StatefulWidget {
  List players = [
    ["player 1", false],
    ["player 2", false],
    ["player 3", false],
    ["player 4", false],
    ["player 5", false],
    ["player 6", false],
    ["player 7", false],
    ["player 8", false],
    ["player 9", false],
    ["player 10", false],
  ];

  PeriodicTable({super.key});

  @override
  State<PeriodicTable> createState() => _PeriodicTableState();
}

class _PeriodicTableState extends State<PeriodicTable> {


  void doChanges() {
    setState(() {
      var temp = widget.players[1];
      widget.players[1] = widget.players[widget.players.length - 1];
      widget.players.insert(2, temp);
      widget.players.removeAt(widget.players.length - 1);
      for (int i = 0; i < widget.players.length; i++) {
        widget.players[i][1] = false;
      }
    });
  }

  void checkForNextRound() {
    int count = 0;
    for (int i = 0; i < widget.players.length; i++) {
      if (widget.players[i][1] == true) {
        count++;
        if (count == widget.players.length / 2) {
          doChanges();
        }
      }
    }
    print(count);
  }

  void checkForEqualBool(int playerIndex, int playerIndex2) {

    if (widget.players[playerIndex][1] == true) {
      widget.players[playerIndex2][1] = false;
    }else if (widget.players[playerIndex2][1] == true) {
      widget.players[playerIndex][1] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              height: 605,
              width: 305,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.5, top: 2.5),
              child: Container(
                height: 600,
                width: 300,
                color: Colors.grey[300],
                child: ListView.builder(
                  itemCount: (widget.players.length / 2).toInt(),
                  itemBuilder: (BuildContext context, int index) {

                    checkForEqualBool(index, widget.players.length - 1 - index);

                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(widget.players[index][0]),
                                  Checkbox(
                                    value: widget.players[index][1],
                                    onChanged: (value) {
                                      setState(() {
                                      widget.players[index][1] = value!;
                                      });
                                      checkForNextRound();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.blue,
                          ),
                          Container(
                            height: 50,
                            width: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(widget.players[
                                      widget.players.length - 1 - index][0]),
                                  Checkbox(
                                    value: widget.players[
                                        widget.players.length - 1 - index][1],
                                    onChanged: (value) {
                                      setState(() {
                                        widget.players[widget.players.length -
                                            1 -
                                            index][1] = value!;
                                      });
                                      checkForNextRound();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
