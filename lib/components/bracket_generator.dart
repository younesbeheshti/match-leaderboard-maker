import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/player_container.dart';
import 'package:match_leaderboard_maker/components/player_information.dart';

import '../util/dimensions.dart';

class BracketGenerator extends StatelessWidget {
  final int length;
  final List<Player?> players;
  final void Function(int) onTap;
  final double height;

  BracketGenerator({
    Key? key,
    required this.length,
    required this.players,
    required this.onTap,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          (length / 2.0).ceil(),
              (index) {
            bool isRestPair = (2 * index < players.length &&
                players[2 * index]?.getName() == "Rest") ||
                (2 * index + 1 < players.length &&
                    players[2 * index + 1]?.getName() == "Rest");

            if (isRestPair) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  width: Dimensions.playerContainerWidth280,
                  height: height,
                  color: const Color(0xFF323232),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  color: const Color(0xFF323232),
                  width: Dimensions.playerContainerWidth280 +
                      Dimensions.playerContainerHeight40,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (players.length == 1)
                        ClickablePlayerContainer(
                          playerName: players[0]?.getName() ?? "",
                          number: players[0]?.getNumber() ?? 1,
                          bottomRadius: 10,
                          topRadius: 10,
                          onTap: () => onTap(0),
                        ),
                      if (2 * index < players.length && players.length > 1)
                        ClickablePlayerContainer(
                          playerName: players[2 * index]?.getName() ?? "",
                          number: players[2 * index]?.getNumber() ??
                              2 * index + 1,
                          bottomRadius: 0,
                          topRadius: 10,
                          onTap: () {
                            onTap(2 * index);
                          },
                        ),
                      if (2 * index + 1 < players.length)
                        ClickablePlayerContainer(
                          playerName: players[2 * index + 1]?.getName() ?? "",
                          number: players[2 * index + 1]?.getNumber() ??
                              2 * index + 2,
                          bottomRadius: 10,
                          topRadius: 0,
                          onTap: () => onTap(2 * index + 1),
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
}
