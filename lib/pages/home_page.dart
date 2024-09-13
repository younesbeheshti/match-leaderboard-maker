import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/my_textfield.dart';
import 'package:match_leaderboard_maker/pages/elimination_page.dart';
import 'package:match_leaderboard_maker/pages/periodic_table.dart';
import 'package:match_leaderboard_maker/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../components/player_information.dart';
import 'double_elimination_page.dart';

class HomePage extends StatefulWidget {

  String routeName;

  HomePage({required this.routeName, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> playersName = [];
  List<Player> players = [];
  List<TextEditingController> _controllers = [];

  final _textController = TextEditingController();
  final _textController1 = TextEditingController();
  int _currentValue = 2;
  int _powNum = 1;
  bool _doShuffle = false;

  @override
  void initState() {
    super.initState();
    _textController.text = _currentValue.toString();
    _initializePlayers();
  }

  void _initializePlayers() {
    playersName = List<String>.generate(_currentValue, (index) => '');
    _controllers = List<TextEditingController>.generate(
      _currentValue,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _textController1.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _increment() {
    setState(() {
      _powNum++;
      int newValue = pow(2, _powNum).toInt();
      if (newValue > _currentValue) {
        for (int i = _currentValue; i < newValue; i++) {
          playersName.add('');
          _controllers.add(TextEditingController());
        }
      }
      _currentValue = newValue;
      _textController.text = _currentValue.toString();
    });
  }

  void _decrement() {
    setState(() {
      if (_powNum > 0) {
        _powNum--;
        int newValue = pow(2, _powNum).toInt();
        if (newValue < _currentValue) {
          playersName.removeRange(newValue, _currentValue);
          for (var i = newValue; i < _currentValue; i++) {
            _controllers[i].dispose();
          }
          _controllers.removeRange(newValue, _currentValue);
        }
        _currentValue = newValue;
        _textController.text = _currentValue.toString();
      }
    });
  }

  void _updateValue(String value) {
    setState(() {
      int newValue = int.tryParse(value) ?? _currentValue;
      int powNum = (log(newValue) / log(2)).ceil();
      if (powNum != _powNum) {
        _powNum = powNum;
        if (newValue > _currentValue) {
          for (int i = _currentValue; i < newValue; i++) {
            playersName.add('');
            _controllers.add(TextEditingController());
          }
        } else if (newValue < _currentValue) {
          playersName.removeRange(newValue, _currentValue);
          for (var i = newValue; i < _currentValue; i++) {
            _controllers[i].dispose();
          }
          _controllers.removeRange(newValue, _currentValue);
        }
        _currentValue = newValue;
        _textController.text = _currentValue.toString();
      }
    });
  }

  void _fillPlayersList() {
    players.clear();  // Clear the players list before filling it
    for (int i = 0; i < playersName.length; i++) {
      String name = _controllers[i].text.trim();
      if (name.isNotEmpty) {
        playersName[i] = name;
        players.add(Player(name: name, number: i + 1));
      }
    }
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
        backgroundColor: Colors.grey[850],
        title:
            Text("Match Leaderboard", style: TextStyle(color: Colors.orange)),
      ),
      body: Container(
        margin: EdgeInsets.all(4.0),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Getting match name
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'اسم مسابقه...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(height: 3),
                      MyTextField(
                        controller: _textController1,
                        hintText: 'اسم مسابقه را وارد کنید',
                        obscureText: false,
                        textDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        textColor: Colors.black,
                      ),

                      // Selecting number of players
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 40.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'تعداد شرکت کنندگان',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.orange,
                                        ),
                                        onPressed: _increment,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _textController,
                                          keyboardType: TextInputType.number,
                                          onSubmitted: _updateValue,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.orange,
                                        ),
                                        onPressed: _decrement,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Row with submit and randomize buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _fillPlayersList();

                                if (players.isEmpty) {
                                  // Show an error or prompt the user to enter at least one player
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please enter at least one player.')),
                                  );
                                  return;
                                }

                                // a condition to check the routename and navigate accordingly

                                if(widget.routeName == '/EliminationPage'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangeNotifierProvider(create: (_) => PlayerProvider(
                                        players: players,
                                        doShuffle: _doShuffle,
                                        isDoubleElimination: false,
                                      ),
                                      child: EliminationPage(),)
                                    ),
                                  );
                                }else if(widget.routeName == '/DoubleEliminationPage'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangeNotifierProvider(create: (_) => PlayerProvider(
                                        players: players,
                                        doShuffle: _doShuffle,
                                        isDoubleElimination: true,
                                      ),
                                        child: DoubleEliminationPage(),)

                                    ),
                                  );
                                }else if(widget.routeName == '/PeriodicPage'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PeriodicTable(
                                        players: players,
                                      ),
                                    ),
                                  );
                                }else{

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('The page is not ready yet...')),
                                  );
                                  return;

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: Text(
                                'تایید',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Row(
                              children: [
                                Text('همراه با قرعه کشی',
                                    style: TextStyle(color: Colors.orange)),
                                Checkbox(
                                  activeColor: Colors.orange,
                                  value: _doShuffle,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _doShuffle = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4),

              Divider(
                thickness: 0.5,
                color: Colors.grey[600],
              ),

              Text(
                'نام شرکت کننده ها',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
              // Getting player's names
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                height: height * 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _currentValue,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: _controllers[index],
                                  hintText: 'نام بازیکن',
                                  obscureText: false,
                                  textDirection: TextDirection.rtl,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  fillColor: Colors.grey.shade200,
                                  textColor: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "-${index + 1}",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
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
