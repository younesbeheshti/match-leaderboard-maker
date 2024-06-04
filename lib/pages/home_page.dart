import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:match_leaderboard_maker/components/my_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> playersName = [];
  List<TextEditingController> _controllers = [];

  final _textController = TextEditingController();
  final _textController1 = TextEditingController();
  int _currentValue = 2;
  bool _isChecked = false;

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
      _currentValue++;
      _textController.text = _currentValue.toString();
      playersName.add(''); // Add a new empty string for the new player
      _controllers.add(TextEditingController()); // Add a new TextEditingController for the new player
    });
  }

  void _decrement() {
    setState(() {
      if (_currentValue > 0) {
        // Prevent negative values
        _currentValue--;
        _textController.text = _currentValue.toString();
        playersName.removeLast(); // Remove the last player
        _controllers.removeLast().dispose(); // Remove and dispose the last TextEditingController
      }
    });
  }

  void _updateValue(String value) {
    setState(() {
      int newValue = int.tryParse(value) ?? _currentValue;
      if (newValue != _currentValue) {
        if (newValue > _currentValue) {
          playersName.addAll(List<String>.generate(newValue - _currentValue, (index) => ''));
          _controllers.addAll(List<TextEditingController>.generate(
            newValue - _currentValue,
                (index) => TextEditingController(),
          ));
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

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;

    final width = currentWidth / 3;
    final height = currentHeight / 5;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text("Match Leaderboard"),
      ),
      body: Container(
        margin: EdgeInsets.all(4.0),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // getting match name
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
                            color: Colors.deepPurple,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      MyTextField(
                        controller: _textController1,
                        hintText: 'اسم مسابقه را وارد کنید',
                        obscureText: false,
                        textDirection: TextDirection.rtl,
                      ),

                      //to selecting number of players
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40.0),
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
                                    color: Colors.deepPurple,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[100],
                                    // Background color of the container
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.deepPurple,
                                        ),
                                        onPressed: _increment,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _textController,
                                          keyboardType: TextInputType.number,
                                          onSubmitted: _updateValue,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.deepPurple,
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

                      //row has buttons for submit and randomise
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple, // background color
                              ),
                              child: Text(
                                'تایید',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Row(
                              children: [
                                Text('بدون قرعه کشی', style: TextStyle(color: Colors.deepPurple)),
                                Checkbox(
                                  activeColor: Colors.deepPurple,
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value ?? false;
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

              SizedBox(
                height: 4,
              ),

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
                  color: Colors.deepPurple,
                ),
              ),
              //getting player's names
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurple[50],
                ),
                height: height*2,
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
                                child: TextField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'نام بازیکن',
                                    hintStyle: TextStyle(color: Colors.deepPurple),
                                    hintTextDirection: TextDirection.rtl,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    playersName[index] = value;
                                  },
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text("-${index+1}", style: TextStyle(color: Colors.deepPurple)),
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
