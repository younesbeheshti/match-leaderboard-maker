import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  int _numOfPlayers = 0;

  void setNumOfPlayers(int count) {
    setState(() {
      _numOfPlayers = count;
    });
    print("the players > ${_numOfPlayers}");
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;

    final width = currentWidth / 3;
    final height = currentHeight / 5;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Match leaderBoard"),
      ),
      body: Container(
        margin: EdgeInsets.all(0),
        color: Colors.grey[300],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // getting match name
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                margin: EdgeInsets.all(5),
                height: height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10),
                        child: Text(
                          "Match Name:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Match Name..',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //to selecting number of players
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.yellow,
                ),
                margin: EdgeInsets.all(5),
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => setNumOfPlayers(4),
                          child: Text("4 Players"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => setNumOfPlayers(8),
                          child: Text("8 Players"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => setNumOfPlayers(16),
                          child: Text("16 Players"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => setNumOfPlayers(32),
                          child: Text("32 Players"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //getting player's names
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.purple,
                ),
                margin: EdgeInsets.all(5),
                height: height,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
