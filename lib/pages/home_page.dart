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
  List<FocusNode> _focusNodes = [];

  late String matchName;

  final _textController = TextEditingController();
  final _textController1 = TextEditingController();
  final _focusNode = FocusNode();
  int _currentValue = 2;
  int _powNum = 1;
  bool _doShuffle = false;
  bool _doSeeding = false;

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
    _focusNodes = List<FocusNode>.generate(
      _currentValue,
      (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _textController1.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
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
          _focusNodes.add(FocusNode());
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
            _focusNodes[i].dispose();
          }
          _controllers.removeRange(newValue, _currentValue);
          _focusNodes.removeRange(newValue, _currentValue);
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
            _focusNodes.add(FocusNode());
          }
        } else if (newValue < _currentValue) {
          playersName.removeRange(newValue, _currentValue);
          for (var i = newValue; i < _currentValue; i++) {
            _controllers[i].dispose();
            _focusNodes[i].dispose();
          }
          _controllers.removeRange(newValue, _currentValue);
          _focusNodes.removeRange(newValue, _currentValue);
        }
        _currentValue = newValue;
        _textController.text = _currentValue.toString();
      }
    });
  }

  void _fillPlayersList() {
    players.clear();
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
      backgroundColor: Color(0xFF323232), // Darker Gray Background
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF323232), // Darker Gray
        title: Text(
          "Match Leaderboard",
          style: TextStyle(color: Color(0xFFF37329)), // Bright Orange
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(4.0),
        color: Color(0xFF323232), // Medium Gray
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                            color: Color(0xFFF37329), // Bright Orange
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(height: 3),
                      MyTextField(
                        focusNode: _focusNode,
                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_focusNodes[0]);
                        },
                        textInputAction: TextInputAction.next,
                        controller: _textController1,
                        hintText: 'اسم مسابقه را وارد کنید',
                        obscureText: false,
                        textDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: Color(0xFF626262)),
                        // Medium Gray
                        fillColor: Color(0xFF838383),
                        // Lighter Gray for number box
                        textColor: Color(0xFF252525), // Almost black for text
                      ),
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
                                    color: Color(0xFFF37329), // Bright Orange
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF838383), // Lighter Gray
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Color(
                                              0xFFF37329), // Bright Orange
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
                                              color: Color(0xFF252525)),
                                          // Almost black for text
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Color(
                                              0xFFF37329), // Bright Orange
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
                      widget.routeName != "/PeriodicPage"
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _fillPlayersList();

                                      matchName = _textController1.text.trim();

                                      if (players.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Please enter at least one player.'),
                                          ),
                                        );
                                        return;
                                      }

                                      switch (widget.routeName) {
                                        case "/EliminationPage":
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                      create: (_) => PlayerProvider(
                                                        players: players,
                                                        doShuffle: _doShuffle,
                                                        isDoubleElimination: false,
                                                        doSeeding: _doSeeding,
                                                      ),
                                                      child: EliminationPage(
                                                        routeName: "Elimination",
                                                        matchName: matchName,
                                                      ),
                                                    ),
                                              ),
                                            );
                                            break;
                                          }
                                        case "/DoubleEliminationPage": {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                    create: (_) => PlayerProvider(
                                                      players: players,
                                                      doShuffle: _doShuffle,
                                                      isDoubleElimination: true,
                                                      doSeeding: _doSeeding,
                                                    ),
                                                    child: DoubleEliminationPage(
                                                      routeName: "Double Elimination",
                                                    ),
                                                  ),
                                            ),
                                          );
                                          break;
                                        }
                                        case "/PeriodicPage": {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PeriodicTable(
                                                players: players,
                                              ),
                                            ),
                                          );
                                          break;
                                        }
                                        default: {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'The page is not ready yet...'),
                                            ),
                                          );
                                          return;
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(0xFFF37329), // Bright Orange
                                    ),
                                    child: Text(
                                      'تایید',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(
                                            0xFFD8D8D8), // Light Gray for text
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text('همراه با قرعه کشی',
                                              style: TextStyle(
                                                  color: Color(0xFFF37329))),
                                          // Bright Orange
                                          Checkbox(
                                            activeColor: Color(0xFFF37329),
                                            // Bright Orange
                                            value: _doShuffle,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _doShuffle = value ?? false;
                                                // _doSeeding = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('سیدبندی',
                                              style: TextStyle(
                                                  color: Color(0xFFF37329))),
                                          // Bright Orange
                                          Checkbox(
                                            activeColor: Color(0xFFF37329),
                                            // Bright Orange
                                            value: _doSeeding,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _doSeeding = value ?? false;
                                                // _doShuffle = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _fillPlayersList();

                                    if (players.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please enter at least one player.'),
                                        ),
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PeriodicTable(
                                          players: players,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(0xFFF37329), // Bright Orange
                                  ),
                                  child: Text(
                                    'تایید',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(
                                          0xFFD8D8D8), // Light Gray for text
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4),
              Divider(
                thickness: 0.5,
                color: Color(0xFF626262), // Medium Gray
              ),
              Text(
                'نام شرکت کننده ها',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFFF37329), // Bright Orange
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF3E3E3E), // Lighter Gray
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
                                textInputAction: index != _focusNodes.length ? TextInputAction.next : TextInputAction.done,
                                focusNode: _focusNodes[index],
                                onSubmitted: (value) {
                                  if (index + 1 < _focusNodes.length) {
                                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                  } else {
                                    FocusScope.of(context).unfocus(); // Remove focus if it's the last field
                                  }
                                },
                                controller: _controllers[index],
                                hintText: 'نام بازیکن',
                                obscureText: false,
                                textDirection: TextDirection.rtl,
                                hintStyle:
                                TextStyle(color: Color(0xFF626262)),
                                // Medium Gray
                                fillColor: Color(0xFF838383),
                                // Lighter Gray
                                textColor: Color(
                                    0xFF252525), // Almost black for text
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "-${index + 1}",
                              style: TextStyle(
                                  color: Color(0xFFF37329)), // Bright Orange
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
