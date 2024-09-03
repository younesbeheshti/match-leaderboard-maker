import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:match_leaderboard_maker/components/bracket_generator.dart';

import '../components/player_information.dart';
import '../util/dimensions.dart';

class DoubleEliminationPage extends StatefulWidget {
  List<Player> players = [];

  final List<List<Player?>> playerList = [];
  final List<List<Player?>> losersPlayerList = [];

  final bool doShuffle;

  DoubleEliminationPage(
      {required this.players, required this.doShuffle, super.key});

  @override
  State<DoubleEliminationPage> createState() => _DoubleEliminationPageState();
}

class _DoubleEliminationPageState extends State<DoubleEliminationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        createList(); // Populate player lists after the first frame is rendered
      });
    });
  }

  int addLosserPlayerCount = 2;
  bool isDone = false;
  bool listAdded = false;

  //ontap function for players in playerList and if they lose, they will be moved to the lossers bracket
  void onTap(int listIndex, int playerIndex) {
    setState(() {
      if (listIndex < widget.playerList.length &&
          playerIndex < widget.playerList[listIndex].length &&
          widget.playerList[listIndex][playerIndex] != null) {
        Player? winner, loser;

        if (playerIndex.isEven) {
          winner = widget.playerList[listIndex][playerIndex];

          // Check if the next index is within bounds
          if (playerIndex + 1 < widget.playerList[listIndex].length) {
            loser = widget.playerList[listIndex][playerIndex + 1];
          } else {
            loser = null;
          }
        } else {
          winner = widget.playerList[listIndex][playerIndex];

          // Check if the previous index is within bounds
          if (playerIndex - 1 >= 0) {
            loser = widget.playerList[listIndex][playerIndex - 1];
          } else {
            loser = null;
          }
        }


        if (loser!.getName() == widget.playerList[listIndex][0]!.getName() && (listIndex == widget.playerList.length - 1) && !listAdded) {
          setState(() {
            widget.playerList.add(List<Player?>.filled(2, null));
            widget.playerList[listIndex+1][0] = (winner);
            widget.playerList[listIndex+1][1] = (loser);
            listAdded = true;
          });
          return;
        }

        //if (winner == null || loser == null) return;

        // Move the winner to the next round in the winner's bracket
        if (listIndex < widget.playerList.length - 1) {
          int targetIndex = (playerIndex / 2).floor();
          widget.playerList[listIndex + 1][targetIndex] = winner;
        }

        // Move the loser to the losers' bracket
        int losersRoundIndex = listIndex;
        if (listIndex == 0) {
          while (addLosserPlayerCount < widget.losersPlayerList[0].length &&
              widget.losersPlayerList[0][addLosserPlayerCount]?.getName() ==
                  "Rest") {
            addLosserPlayerCount++;
          }
          if (addLosserPlayerCount < widget.losersPlayerList[0].length) {
            widget.losersPlayerList[0][addLosserPlayerCount] = loser;
            addLosserPlayerCount++;
          }
        } else {
          if (listIndex == widget.playerList.length - 2 && !isDone) {
            widget.losersPlayerList[listIndex + 1][1] = loser;
            isDone = true;
            return;
          }
          int i = widget.losersPlayerList[losersRoundIndex].length - 1;
          while (i >= 0 &&
              (widget.losersPlayerList[losersRoundIndex][i] != null ||
                  widget.losersPlayerList[losersRoundIndex][i]?.getName() ==
                      "Rest")) {
            i--;
          }
          if (i >= 0) {
            widget.losersPlayerList[losersRoundIndex][i] = loser;
          }
        }

        print("Winner: ${winner!.getName()}, Loser: ${loser!.getName()}");
      }
    });
  }

  // ontap for losers in losersPlayerList if they win in the losers bracket, they will push to the next round
  void onLoserTap(int listIndex, int playerIndex) {
    setState(() {
      if (listIndex < widget.losersPlayerList.length &&
          playerIndex < widget.losersPlayerList[listIndex].length &&
          widget.losersPlayerList[listIndex][playerIndex] != null) {
        if (listIndex == widget.losersPlayerList.length - 1) {
          widget.playerList[listIndex][1] =
              (widget.losersPlayerList[listIndex][playerIndex]);
        } else {
          int targetIndex = (playerIndex / 2).floor();
          widget.losersPlayerList[listIndex + 1][targetIndex] =
              widget.losersPlayerList[listIndex][playerIndex];
        }
      }
    });
  }

  void createList() {
    int rounds = (log(widget.players.length) / log(2)).ceil();

    addRestMatches();

    if (widget.doShuffle) {
      randomiseList();
    }

    widget.playerList.add(widget.players); // Add the initial list of players
    for (int i = 1; i <= rounds; i++) {
      if (i != rounds) {
        widget.playerList.add(List<Player?>.filled(
            widget.playerList[i - 1].length ~/ 2, null)); // Add empty slots
      } else {
        widget.playerList.add(List<Player?>.filled(2, null));
      }

      // create loser bracket with the 2 times of size of the playerList

      widget.losersPlayerList
          .add(List<Player?>.filled(widget.playerList[i - 1].length, null));

      if (i == rounds) {
        widget.losersPlayerList.add(List<Player?>.filled(
            widget.playerList[i - 1].length, null)); // Add empty slots
      }

      // add Rest players to the first round of the loser bracket Two in between

      if (i == 1) {
        int count = 2;
        int count2 = 0;

        for (int j = 0; j < widget.losersPlayerList[0].length; j++) {
          if (count > 0) {
            widget.losersPlayerList[0][j] = Player(name: "Rest", number: 0);
            count--;
            count2 = 2; // Reset count2 to 2 every time a replacement occurs
          } else if (count2 > 0) {
            count2--;
            if (count2 == 0) {
              count = 2; // Reset count to 2 after count2 reaches 0
            }
          }
        }
      }
    }

    if (widget.playerList[0].last?.getName() == "Rest") {
      for (int i = 0; i < widget.playerList[0].length; i++) {
        pushToNextRound(0, i);
      }
    }
  }

  void addRestMatches() {
    int rounds = (log(widget.players.length) / log(2)).ceil();
    int totalMatches = pow(2, rounds).toInt() - widget.players.length;
    for (int i = 0; i < totalMatches; i++) {
      widget.players.add(Player(name: 'Rest', number: 0));
    }

    print("total matches: ${widget.players.length}");
  }

  void randomiseList() {
    widget.players.shuffle();

    // Ensure no two "Rest" players are adjacent
    for (int i = 0; i < widget.players.length - 1; i++) {
      if (widget.players[i].getName() == "Rest" &&
          widget.players[i + 1].getName() == "Rest") {
        // Find the next non-Rest player to swap with
        for (int j = i + 2; j < widget.players.length; j++) {
          if (widget.players[j].getName() != "Rest") {
            // Swap positions to avoid adjacent "Rest" players
            Player temp = widget.players[i + 1];
            widget.players[i + 1] = widget.players[j];
            widget.players[j] = temp;
            break;
          }
        }
      }
    }
  }

  void pushToNextRound(int listIndex, int playerIndex) {
    if (listIndex < widget.playerList.length - 1 &&
        playerIndex < widget.playerList[listIndex].length) {
      int pairedIndex =
          playerIndex % 2 == 0 ? playerIndex + 1 : playerIndex - 1;

      // Ensure pairedIndex is within valid range
      if (pairedIndex < 0 ||
          pairedIndex >= widget.playerList[listIndex].length) {
        return; // Exit early if pairedIndex is out of bounds
      }

      if (widget.playerList[listIndex][playerIndex] != null &&
          widget.playerList[listIndex][playerIndex]!.getName() == "Rest" &&
          widget.playerList[listIndex][pairedIndex] != null &&
          widget.playerList[listIndex][pairedIndex]!.getName() == "Rest") {
        int abovePlayerIndex = (playerIndex / 2).floor() - 1;

        // Ensure abovePlayerIndex is within valid range
        if (abovePlayerIndex >= 0 &&
            abovePlayerIndex < widget.playerList[listIndex + 1].length &&
            widget.playerList[listIndex + 1][abovePlayerIndex] == null) {
          setState(() {
            widget.playerList[listIndex + 1][abovePlayerIndex] =
                widget.playerList[listIndex - 1][abovePlayerIndex * 2];
          });
        }

        return;
      }

      if ((widget.playerList[listIndex][playerIndex] != null &&
              widget.playerList[listIndex][playerIndex]!.getName() == "Rest") ||
          (widget.playerList[listIndex][pairedIndex] != null &&
              widget.playerList[listIndex][pairedIndex]!.getName() == "Rest")) {
        int targetIndex = (playerIndex / 2).floor();

        setState(() {
          if (widget.playerList[listIndex][playerIndex]!.getName() != "Rest") {
            widget.playerList[listIndex + 1][targetIndex] =
                widget.playerList[listIndex][playerIndex];
          } else {
            widget.playerList[listIndex + 1][targetIndex] =
                widget.playerList[listIndex][pairedIndex];
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF323232),
      appBar: AppBar(
        title: Text("Double Elimination"),
        centerTitle: true,
        backgroundColor: Color(0xFF323232),
      ),
      body: widget.players.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              // This makes the whole page scrollable vertically
              child: Container(
                 // Adjust this width as necessary
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Make the entire column scrollable horizontally
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Text("Winners Bracket"),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              widget.playerList.length,
                              (index) {
                                return Flexible(
                                  fit: FlexFit.loose,
                                  child: BracketGenerator(
                                    length: widget.playerList[index].length,
                                    players: widget.playerList[index],
                                    onTap: (playerIndex) =>
                                        onTap(index, playerIndex),
                                    height: manageHeight(
                                      widget.playerList.length,
                                      widget.playerList.length - index,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Text("Losers Bracket"),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              widget.losersPlayerList.length,
                              (index) {
                                return Flexible(
                                  fit: FlexFit.loose,
                                  child: BracketGenerator(
                                    length:
                                        widget.losersPlayerList[index].length,
                                    players: widget.losersPlayerList[index],
                                    onTap: (playerIndex) =>
                                        onLoserTap(index, playerIndex),
                                    height: manageHeight(
                                      widget.losersPlayerList.length,
                                      widget.losersPlayerList.length - index,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

double manageHeight(int length, int index) {
  // Set a base size for the container height
  double defaultSize = Dimensions.playerContainerHeight40 + 10;

  // Calculate height based on the number of rounds left
  for (int i = index; i <= length; i++) {
    defaultSize *= 2; // Increase the height for each round
  }

  // Print statements for debugging (can be removed in production)
  print("manageHeight: $defaultSize");

  // Return the calculated size
  return defaultSize;
}
