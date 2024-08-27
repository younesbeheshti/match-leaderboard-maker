import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:match_leaderboard_maker/components/bracket_generator.dart';

import '../components/player_container.dart';
import '../components/player_information.dart';
import '../util/dimensions.dart';

class EliminationPage extends StatefulWidget {
  List<Player> players = [];

  final List<List<Player?>> playerList = [];
  final List<List<Player?>> losersPlayerList = [];

  final bool doShuffle;

  EliminationPage({required this.players, required this.doShuffle, super.key});

  @override
  State<EliminationPage> createState() => _EliminationPageState();
}

class _EliminationPageState extends State<EliminationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        createList(); // Populate player lists after the first frame is rendered
      });
    });
  }

  void onTap(int listIndex, int playerIndex) {
    setState(() {
      if (listIndex < widget.playerList.length - 1 &&
          playerIndex < widget.playerList[listIndex].length &&
          widget.playerList[listIndex][playerIndex] != null) {
        if (playerIndex.isEven) {
          widget.playerList[listIndex][playerIndex]?.isWin = true;
          widget.playerList[listIndex][playerIndex + 1]?.isWin = false;
        } else if (playerIndex.isOdd) {
          widget.playerList[listIndex][playerIndex]?.isWin = true;
          widget.playerList[listIndex][playerIndex - 1]?.isWin = false;
        }

        // Move the player to the next round
        int targetIndex = (playerIndex / 2).floor();
        widget.playerList[listIndex + 1][targetIndex] =
            widget.playerList[listIndex][playerIndex];
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
      widget.playerList.add(List<Player?>.filled(
          widget.playerList[i - 1].length ~/ 2, null)); // Add empty slots
      widget.losersPlayerList.add([]);
    }

    //use the pushToNextRound function to push the player to the next round if the player has a rest just for the first list
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

      if (widget.playerList[listIndex][playerIndex] != null &&
          widget.playerList[listIndex][playerIndex]!.getName() == "Rest" &&
          pairedIndex >= 0 &&
          pairedIndex < widget.playerList[listIndex].length &&
          widget.playerList[listIndex][pairedIndex] != null &&
          widget.playerList[listIndex][pairedIndex]!.getName() == "Rest") {
        int abovePlayerIndex = (playerIndex / 2).floor() - 1;

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
      body: widget.playerList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              // This makes the whole page scrollable vertically
              child: Container(
                width: 1200, // Adjust this width as necessary
                child: Row(
                  children: [
                    // Wrap the entire content in a Flexible or Expanded widget to avoid overflow
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            widget.playerList.length,
                            (index) {
                              return BracketGenerator(
                                length : widget.playerList[index].length,
                                players: widget.playerList[index],
                                onTap: (playerIndex) => onTap(index, playerIndex),
                                height: manageHeight(widget.playerList.length,
                                    widget.playerList.length - index),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Widget myContainer(int length, List<Player?> players, void Function(int) onTap,
//     double _height) {
//   return Container(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(
//         (length / 2.0).ceil(),
//         (index) {
//           bool isRestPair = (2 * index < players.length &&
//                   players[2 * index]?.getName() == "Rest") ||
//               (2 * index + 1 < players.length &&
//                   players[2 * index + 1]?.getName() == "Rest");
//
//           if (isRestPair) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Container(
//                 margin: EdgeInsets.zero,
//                 padding: EdgeInsets.zero,
//                 width: Dimensions.playerContainerWidth280,
//                 height: _height,
//                 color: const Color(0xFF323232),
//               ),
//             );
//           } else {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Container(
//                 margin: EdgeInsets.zero,
//                 padding: EdgeInsets.zero,
//                 color: const Color(0xFF323232),
//                 width: Dimensions.playerContainerWidth280 +
//                     Dimensions.playerContainerHeight40,
//                 height: _height,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (players.length == 1)
//                       ClickablePlayerContainer(
//                         playerName: players[0]?.getName() ?? "",
//                         number: players[0]?.getNumber() ?? 1,
//                         bottomRadius: 10,
//                         topRadius: 10,
//                         onTap: () => onTap(0),
//                       ),
//                     if (2 * index < players.length && players.length > 1)
//                       ClickablePlayerContainer(
//                         playerName: players[2 * index]?.getName() ?? "",
//                         number:
//                             players[2 * index]?.getNumber() ?? 2 * index + 1,
//                         bottomRadius: 0,
//                         topRadius: 10,
//                         onTap: () {
//                           onTap(2 * index);
//                         },
//                       ),
//                     if (2 * index + 1 < players.length)
//                       ClickablePlayerContainer(
//                         playerName: players[2 * index + 1]?.getName() ?? "",
//                         number: players[2 * index + 1]?.getNumber() ??
//                             2 * index + 2,
//                         bottomRadius: 10,
//                         topRadius: 0,
//                         onTap: () => onTap(2 * index + 1),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     ),
//   );
// }

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
