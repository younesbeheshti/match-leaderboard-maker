import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/player_container.dart';
import '../util/dimensions.dart';

class EliminationPage extends StatefulWidget{
  final List<Player> players = List.generate(
    7,

    (index) => Player(name: 'Player ${index + 1}'),
  );

  final List<List<Player?>> playerList = [];
  final List<List<Player?>> losersPlayerList = [];

  EliminationPage({super.key});

  @override
  State<EliminationPage> createState() => _EliminationPageState();
}

class _EliminationPageState extends State<EliminationPage> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        createList(); // Ensure list creation triggers a UI rebuild
      });
    });
  }

  void onTap(int listIndex, int playerIndex) {
    setState(() {
      if (listIndex < widget.playerList.length - 1 &&
          playerIndex < widget.playerList[listIndex].length &&
          widget.playerList[listIndex][playerIndex] != null) {
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
    randomiseList();
    widget.playerList.add(widget.players); // Add the initial list of players
    for (int i = 1; i < rounds; i++) {
      widget.playerList.add(List<Player?>.filled(
          widget.playerList[i - 1].length ~/ 2, null)); // Add empty slots
      widget.losersPlayerList.add([]);
    }

    //use the pushToNextRound function to push the player to the next round if the player has a rest just for the first list
    for (int i = 0; i < widget.playerList[0].length; i++) {
      pushToNextRound(0, i);
    }
  }

  void addRestMatches() {
    int rounds = (log(widget.players.length) / log(2)).ceil();
    int totalMatches = pow(2, rounds).toInt() - widget.players.length;
    for (int i = 0; i < totalMatches; i++) {
      widget.players.add(Player(name: 'Rest'));
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

      int pairedIndex = playerIndex % 2 == 0 ? playerIndex + 1 : playerIndex - 1;

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
                    children: List.generate(widget.playerList.length, (index) {
                      return myContainer(
                        widget.playerList[index].length,
                        widget.playerList[index],
                            (playerIndex) => onTap(index, playerIndex),
                        manageHeight(widget.playerList.length, widget.playerList.length - index),
                      );
                    }),
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

Widget myContainer(int length, List<Player?> players, void Function(int) onTap, double _height) {
  return Container(
    // Ensure the height is managed by the parent scrolling
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        (length / 2.0).ceil(),
            (index) {
          // Check if either of the players in the pair is "Rest"
          bool isRestPair = (2 * index < players.length && players[2 * index]?.getName() == "Rest") ||
              (2 * index + 1 < players.length && players[2 * index + 1]?.getName() == "Rest");

          if (isRestPair) {
            // Show an empty container with the same dimensions
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: Dimensions.playerContainerWidth280,
                height: _height, // Adjust the height to match the total height of the original container
                color: const Color(0xFF323232), // Match the background color
              ),
            );
          } else {
            // Show the player containers as usual
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                color: const Color(0xFF323232),
                width: Dimensions.playerContainerWidth280,
                height: _height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (2 * index < players.length && players.length > 1)
                      GestureDetector(
                        onTap: players[2 * index] != null ? () => onTap(2 * index) : null,
                        child: PlayerContainer(
                          playerName: players[2 * index]?.getName() ?? "",
                          number: 2 * index + 1,
                          bottomRadius: 0,
                          topRadius: 10,
                        ),
                      ),
                    if (2 * index + 1 < players.length)
                      GestureDetector(
                        onTap: players[2 * index + 1] != null ? () => onTap(2 * index + 1) : null,
                        child: PlayerContainer(
                          playerName: players[2 * index + 1]?.getName() ?? "",
                          number: 2 * index + 2,
                          bottomRadius: 10,
                          topRadius: 0,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    ),
  );
}


Widget test() {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Row(
      children: [
        ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return;
            })
      ],
    ),
  );
}

class Player {
  final String name;

  Player({required this.name});

  String getName() => name;
}
