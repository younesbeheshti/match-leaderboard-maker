import 'package:flutter/material.dart';

class NextTextFieldExample extends StatefulWidget {
  @override
  _NextTextFieldExampleState createState() => _NextTextFieldExampleState();
}

class _NextTextFieldExampleState extends State<NextTextFieldExample> {
  // Create FocusNodes for each TextField
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();

  @override
  void dispose() {
    // Dispose of the FocusNodes when no longer needed
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next TextField Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First TextField
            TextField(
              focusNode: _focusNode1,
              textInputAction: TextInputAction.next, // Display "Next" button
              onSubmitted: (value) {
                // When user taps Enter, move focus to the next TextField
                FocusScope.of(context).requestFocus(_focusNode2);
              },
              decoration: InputDecoration(labelText: 'First TextField'),
            ),
            SizedBox(height: 16),

            // Second TextField
            TextField(
              focusNode: _focusNode2,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(_focusNode3);
              },
              decoration: InputDecoration(labelText: 'Second TextField'),
            ),
            SizedBox(height: 16),

            // Third TextField
            TextField(
              focusNode: _focusNode3,
              textInputAction: TextInputAction.done, // Final TextField
              onSubmitted: (value) {
                // Optionally unfocus the last TextField
                _focusNode3.unfocus();
              },
              decoration: InputDecoration(labelText: 'Third TextField'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NextTextFieldExample(),
  ));
}

