import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final TextDirection? textDirection;


  MyTextField({
    Key? key,
    TextEditingController? controller,
    TextDirection? textDirection,
    required this.hintText,
    required this.obscureText,
  }) : controller = controller ?? TextEditingController(),
  textDirection = textDirection ?? TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(textDirection: textDirection,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
          hintTextDirection: textDirection,
        ),
      ),
    );
  }
}
