import 'dart:math';

import 'package:flutter/material.dart';

import '../components/player_information.dart';

class PlayerProvider extends ChangeNotifier {
  List<Player> players = [];

  List<List<Player?>> playerList = [];
  List<List<Player?>> losersPlayerList = [];

  bool doShuffle;
  bool doSeeding;
  bool isDoubleElimination;

  int addLoserPlayerCount = 0;
  bool isDone = false;
  bool listAdded = false;

  PlayerProvider({
    required this.players,
    required this.doShuffle,
    required this.isDoubleElimination,
    required this.doSeeding,
  }) {
    createList();
  }

  int moveToNextList = 0;

  //ontap function for players in playerList and if they lose, they will be moved to the lossers bracket
  void onTap(int listIndex, int playerIndex) {
    if (listIndex < playerList.length &&
        playerIndex < playerList[listIndex].length &&
        playerList[listIndex][playerIndex] != null) {
      Player? winner, loser;

      if (playerIndex.isEven) {
        winner = playerList[listIndex][playerIndex];

        // Check if the next index is within bounds
        if (playerIndex + 1 < playerList[listIndex].length) {
          loser = playerList[listIndex][playerIndex + 1];
        } else {
          loser = null;
        }
      } else {
        winner = playerList[listIndex][playerIndex];

        // Check if the previous index is within bounds
        if (playerIndex - 1 >= 0) {
          loser = playerList[listIndex][playerIndex - 1];
        } else {
          loser = null;
        }
      }

      // Move the winner to the next round in the winner's bracket
      if (listIndex < playerList.length - 1) {
        int targetIndex = (playerIndex / 2).floor();
        playerList[listIndex + 1][targetIndex] = winner;
      }

      if (isDoubleElimination) {
        if (loser!.getName() == playerList[listIndex][0]!.getName() &&
            (listIndex == playerList.length - 1) &&
            !listAdded) {
          playerList.add(List<Player?>.filled(2, null));

          playerList[listIndex + 1][0] = (loser);
          playerList[listIndex + 1][1] = (winner);
          listAdded = true;

          notifyListeners();
          return;
        }


        // Move the loser to the losers' bracket
        int losersRoundIndex = listIndex;
        if (listIndex == 0) {
          if (addLoserPlayerCount < losersPlayerList[0].length) {
            losersPlayerList[0][addLoserPlayerCount] = loser;
            addLoserPlayerCount++;
          }
        } else {


          // int lstIndex = losersRoundIndex + moveToNextList;
          int lstIndex = 2 * listIndex - 1;
          int i = losersPlayerList[lstIndex].length - 1;


          while (losersPlayerList[lstIndex][i] != null) {
            i -= 2;
          }
          losersPlayerList[lstIndex][i] = loser;


        }

        print("Winner: ${winner!.getName()}, Loser: ${loser.getName()}");
      }
    }
    notifyListeners();
  }

  void onLoserTap(int listIndex, int playerIndex) {
    if (!(listIndex < losersPlayerList.length &&
        playerIndex < losersPlayerList[listIndex].length &&
        losersPlayerList[listIndex][playerIndex] != null)){
      notifyListeners();
      return;
    }

    if (listIndex == losersPlayerList.length - 1) {
      playerList[playerList.length - 1][1] = (losersPlayerList[listIndex][playerIndex]);
      notifyListeners();
      return;
    }
    int targetIndex;
    if(listIndex % 2 == 0){
      targetIndex = (playerIndex) - playerIndex % 2;
    } else {
      targetIndex = (playerIndex / 2).floor();
    }
    losersPlayerList[listIndex + 1][targetIndex] = (losersPlayerList[listIndex][playerIndex]);
    notifyListeners();
  }

  void createList() {
    int rounds = (log(players.length) / log(2)).ceil();

    print("rounds: $rounds");

    addRestMatches();

    if (doShuffle) {
      randomiseList();
    }

    if(doSeeding){
      seedPlayers();
    }

    playerList.add(players); // Add the initial list of players
    for (int i = 0; i <= rounds; i++) {
      if (i == rounds - 1 && isDoubleElimination) {
        playerList.add(List<Player?>.filled(
            playerList[i].length, null)); // Add empty slots
        break;

      }

      playerList.add(List<Player?>.filled(playerList[i].length ~/ 2, null));


    }

    if (playerList[0].last?.getName() == "Rest") {
      for (int i = 0; i < playerList[0].length; i++) {
        pushToNextRound(0, i);
      }
    }

    if (isDoubleElimination) {



      for (int j = 1; j < rounds; j++) {
        int len = pow(2, rounds - j).toInt();
        losersPlayerList.add(List.filled(len, null));
        losersPlayerList.add(List.filled(len, null));

      }
    }

    notifyListeners();
  }

  void addRestMatches() {
    int rounds = (log(players.length) / log(2)).ceil();
    int totalMatches = pow(2, rounds).toInt() - players.length;
    for (int i = 0; i < totalMatches; i++) {
      players.add(Player(name: 'Rest', number: 0));
    }

    print("total matches: ${players.length}");

    notifyListeners();
  }

  //function to seed the players
  void seedPlayers() {
    int len = 4;
    int listLen = players.length;
    int start = 0;
    Player temp;
    if(players.length > 4) {
      while (start < listLen) {
        for (int i = start; i < len; i++) {
          temp = players[i];
          players[i] = players[listLen - i -1];
          players[listLen - i  -1] = temp;
        }
        start += 4;
        len +=4;
      }

    }else {

      for (int i = 0; i < listLen; i++) {
        temp = players[i];
        players[i] = players[listLen - i - 1];
        players[listLen - i - 1] = temp;
      }
    }

    notifyListeners();
  }


  void randomiseList() {
    players.shuffle();

    // Ensure no two "Rest" players are adjacent
    for (int i = 0; i < players.length - 1; i++) {
      if (players[i].getName() == "Rest" &&
          players[i + 1].getName() == "Rest") {
        // Find the next non-Rest player to swap with
        for (int j = i + 2; j < players.length; j++) {
          if (players[j].getName() != "Rest") {
            // Swap positions to avoid adjacent "Rest" players
            Player temp = players[i + 1];
            players[i + 1] = players[j];
            players[j] = temp;
            break;
          }
        }
      }
    }
    notifyListeners();
  }

  void pushToNextRound(int listIndex, int playerIndex) {
    if (listIndex < playerList.length - 1 &&
        playerIndex < playerList[listIndex].length) {
      int pairedIndex =
          playerIndex % 2 == 0 ? playerIndex + 1 : playerIndex - 1;

      // Ensure pairedIndex is within valid range
      if (pairedIndex < 0 || pairedIndex >= playerList[listIndex].length) {
        notifyListeners();
        return; // Exit early if pairedIndex is out of bounds
      }

      if (playerList[listIndex][playerIndex] != null &&
          playerList[listIndex][playerIndex]!.getName() == "Rest" &&
          playerList[listIndex][pairedIndex] != null &&
          playerList[listIndex][pairedIndex]!.getName() == "Rest") {
        int abovePlayerIndex = (playerIndex / 2).floor() - 1;

        // Ensure abovePlayerIndex is within valid range
        if (abovePlayerIndex >= 0 &&
            abovePlayerIndex < playerList[listIndex + 1].length &&
            playerList[listIndex + 1][abovePlayerIndex] == null) {
          playerList[listIndex + 1][abovePlayerIndex] =
              playerList[listIndex - 1][abovePlayerIndex * 2];
        }
        notifyListeners();

        return;
      }

      if ((playerList[listIndex][playerIndex] != null &&
              playerList[listIndex][playerIndex]!.getName() == "Rest") ||
          (playerList[listIndex][pairedIndex] != null &&
              playerList[listIndex][pairedIndex]!.getName() == "Rest")) {
        int targetIndex = (playerIndex / 2).floor();

        if (playerList[listIndex][playerIndex]!.getName() != "Rest") {
          playerList[listIndex + 1][targetIndex] =
              playerList[listIndex][playerIndex];
        } else {
          playerList[listIndex + 1][targetIndex] =
              playerList[listIndex][pairedIndex];
        }
      }
    }

    notifyListeners();
  }
}
