import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/provider/player_provider.dart';
import 'package:provider/provider.dart';
import '../components/player_information.dart';
import '../components/bracket_generator.dart';
import '../util/dimensions.dart';

class EliminationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF323232),
      appBar: AppBar(
        title: Text("Double Elimination"),
        centerTitle: true,
        backgroundColor: Color(0xFF323232),
      ),
      body: provider.players.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildBracketSection(provider, "Winners Bracket", provider.playerList, provider.onTap),
        ),
      ),
    );
  }

  Widget _buildBracketSection(
      PlayerProvider provider,
      String title,
      List<List<Player?>> bracketList,
      void Function(int, int) onTapCallback,
      ) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(title),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            bracketList.length,
                (index) {
              return Flexible(
                fit: FlexFit.loose,
                child: BracketGenerator(
                  length: bracketList[index].length,
                  players: bracketList[index],
                  onTap: (playerIndex) => onTapCallback(index, playerIndex),
                  height: manageHeight(bracketList.length, bracketList.length - index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

double manageHeight(int length, int index) {
  double defaultSize = Dimensions.playerContainerHeight40 + 10;
  for (int i = index; i <= length; i++) {
    defaultSize *= 2;
  }
  return defaultSize;
}
