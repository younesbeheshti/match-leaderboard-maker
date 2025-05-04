import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:match_leaderboard_maker/provider/player_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../components/player_information.dart';
import '../components/bracket_generator.dart';
import '../util/dimensions.dart';

class EliminationPage extends StatefulWidget {
  final String routeName;
  final String matchName;

  EliminationPage(
      {required this.routeName, required this.matchName, super.key});

  @override
  State<EliminationPage> createState() => _EliminationPageState();
}

class _EliminationPageState extends State<EliminationPage> {
  // Separate GlobalKey for RepaintBoundary
  GlobalKey _repaintBoundaryKey = GlobalKey();

  Future<void> _captureAndSave() async {
    try {
      // Ensure the widget is fully rendered before capturing
      await Future.delayed(Duration(milliseconds: 100));

      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // First, calculate the size of the widget
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      var image = await boundary.toImage(pixelRatio: pixelRatio);

      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the captured image to the gallery
      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 100, name: widget.matchName);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void _showDefinitionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hint"),
          content: Text("This button performs ScreenShot action when clicked."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF323232),
      appBar: AppBar(
        title: Text(widget.routeName),
        centerTitle: true,
        backgroundColor: Color(0xFF323232),
        actions : [
          GestureDetector(
            onLongPress: _showDefinitionDialog,
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed : _captureAndSave,
            ),
          ),
        ]
      ),
      body: provider.players.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RepaintBoundary(
        key: _repaintBoundaryKey, // Use the repaintKey here
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20.0),

          minScale: 0.1,
          maxScale: 4.0,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildBracketSection(provider, "Winners Bracket",
                  provider.playerList, provider.onTap),
            ),
          ),
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
                  height: manageHeight(
                      bracketList.length, bracketList.length - index),
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
