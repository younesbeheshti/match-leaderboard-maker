import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/player_information.dart';
import 'package:match_leaderboard_maker/util/dimensions.dart';

class PeriodicTable extends StatefulWidget {
  List players = [
    Player(name: 'Player 1'),
    Player(name: 'Player 2'),
    Player(name: 'Player 3'),
    Player(name: 'Player 4'),
  ];

  List rounds = [];

  List roundsNames = [
    "دست اول",
    "دست دوم",
    "دست سوم",
    "دست چهارم",
    "دست پنجم",
    "دست ششم",
    "دست هفتم",
    "دست هشتم",
    "دست نهم",
    "دست دهم",
    "دست یازدهم",
    "دست دوازدهم",
    "دست سیزدهم",
    "دست چهاردهم",
    "دست پانزدهم",
    "دست شانزدهم",
    "دست هفدهم",
    "دست هجدهم",
    "دست نوزدهم",
    "دست بیستم",
    "دست بیست و یکم",
    "دست بیست و دوم",
    "دست بیست و سوم",
    "دست بیست و چهارم",
    "دست بیست و پنجم",
    "دست بیست و ششم",
    "دست بیست و هفتم",
    "دست بیست و هشتم",
    "دست بیست و نهم",
    "دست سی ام",
    "دست سی و یکم",
    "دست سی و دوم",
  ];

  PeriodicTable({super.key});

  @override
  State<PeriodicTable> createState() => _PeriodicTableState();
}

class _PeriodicTableState extends State<PeriodicTable> {
  late final int rounds;
  int round = 1;
  String _text = "مرحله بعدی";


  @override
  void initState() {
    super.initState();
    rounds = widget.players.length - 1;
  }

  void checkForNextRound() {
    int count = 0;
    for (int i = 0; i < widget.players.length; i++) {
      if (widget.players[i].getIsWin() == true) {
        count++;
        if (count == widget.players.length / 2 ) {
          saveRounds();

          round++;



          setState(() {
            var temp = widget.players[1];
            widget.players[1] = widget.players[widget.players.length - 1];
            widget.players.insert(2, temp);
            widget.players.removeAt(widget.players.length - 1);
            for (int i = 0; i < widget.players.length; i++) {
              widget.players[i].setIsWin(false);
              widget.players[i].defaultColor();


            }
          });



        }

        // else if (round == rounds) {
        //   _text = "نتایج بازی";
        // }
      }
    }
  }


  //
  void checkForResult(){

  }

  void checkForEqualBool(int playerIndex, int playerIndex2) {
    if (widget.players[playerIndex].getIsWin() == true) {
      widget.players[playerIndex].setIsWin(true);
      widget.players[playerIndex2].setIsWin(false);
    } else if (widget.players[playerIndex2].getIsWin() == true) {
      widget.players[playerIndex2].setIsWin(true);
      widget.players[playerIndex].setIsWin(false);
    }
  }

  void saveRounds() {
    Map tempRound = {};
    tempRound['round'] = round;
    tempRound['winners'] = [];
    tempRound['losers'] = [];

    for (int i = 0; i < widget.players.length; i++) {
      if (widget.players[i].getIsWin() == true) {
        tempRound['winners'].add(widget.players[i].getName());
      } else {
        tempRound['losers'].add(widget.players[i].getName());
      }
    }

    widget.rounds.add(tempRound);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light Gray background
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF3F51B5), // Indigo AppBar
        title: const Text(
          "Periodic Table",
          style: TextStyle(color: Color(0xFFFFC107)), // Amber Text
        ),
      ),
      body: Container(
        color: Color(0xFFF5F5F5), // Light Gray background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 17.5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      checkForNextRound();
                      for (int i = 0; i < widget.rounds.length; i++) {
                        print(widget.rounds[i]);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F51B5),
                        textStyle: TextStyle(fontSize: 17) // Amber Button
                        ),
                    child: Text(
                      _text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    widget.roundsNames[round - 1],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5), // Indigo Text
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  color: Color(0xFF00BCD4), // Cyan background
                  height: Dimensions.periodicTableHeightBigOneInStack,
                  width: Dimensions.screenWidth - 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    height: Dimensions.periodicTableWidthSmallOneInStack,
                    width: Dimensions.screenWidth - 10,
                    color: Color(0xFFF5F5F5), // Light Gray inner container
                    child: ListView.builder(
                      itemCount: (widget.players.length / 2).toInt(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: Dimensions
                                        .playerContainerHeightPeriodicTable,
                                    width: Dimensions
                                        .playerContainerWidthPeriodicTable,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            widget.players[index].getName(),
                                            style: const TextStyle(
                                                color: Color(
                                                    0xFF212121)), // Dark Gray Text
                                          ),
                                          Checkbox(
                                            value: widget.players[index]
                                                .getIsWin(),
                                            onChanged: (value) {
                                              setState(() {
                                                widget.players[index]
                                                    .setIsWin(value!);
                                                checkForEqualBool(
                                                    index,
                                                    widget.players.length -
                                                        1 -
                                                        index);

                                                if (widget.players[index]
                                                        .getIsWin() ==
                                                    true) {
                                                  widget.players[index]
                                                      .setColor(Colors.green);
                                                  widget.players[widget
                                                              .players.length -
                                                          1 -
                                                          index]
                                                      .setColor(Colors.red);
                                                } else {
                                                  widget.players[index]
                                                      .defaultColor();
                                                  widget.players[widget
                                                              .players.length -
                                                          1 -
                                                          index]
                                                      .defaultColor();
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: widget.players[index].getColor(),
                                    ),
                                  ),
                                  Container(
                                    height: Dimensions
                                        .playerContainerHeightPeriodicTable,
                                    width: Dimensions
                                        .playerContainerWidthPeriodicTable,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            widget.players[
                                                    widget.players.length -
                                                        1 -
                                                        index]
                                                .getName(),
                                            style: const TextStyle(
                                                color: Color(
                                                    0xFF212121)), // Dark Gray Text
                                          ),
                                          Checkbox(
                                            value: widget.players[
                                                    widget.players.length -
                                                        1 -
                                                        index]
                                                .getIsWin(),
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  widget.players[widget
                                                              .players.length -
                                                          1 -
                                                          index]
                                                      .setIsWin(value!);
                                                  checkForEqualBool(
                                                      widget.players.length -
                                                          1 -
                                                          index,
                                                      index);

                                                  if (widget.players[widget
                                                                  .players
                                                                  .length -
                                                              1 -
                                                              index]
                                                          .getIsWin() ==
                                                      true) {
                                                    widget.players[widget
                                                                .players
                                                                .length -
                                                            1 -
                                                            index]
                                                        .setColor(Colors.green);
                                                    widget.players[index]
                                                        .setColor(Colors.red);
                                                  } else {
                                                    widget.players[widget
                                                                .players
                                                                .length -
                                                            1 -
                                                            index]
                                                        .defaultColor();
                                                    widget.players[index]
                                                        .defaultColor();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: widget.players[
                                              widget.players.length - 1 - index]
                                          .getColor(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              (index == (widget.players.length / 2 - 1))
                                  ? Text("")
                                  : const Divider(
                                      color: Color(0xFF212121), thickness: 1),
                              // Dark Gray Divider
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
