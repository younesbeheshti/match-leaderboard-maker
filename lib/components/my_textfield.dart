import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextDirection textDirection;
  final TextStyle? hintStyle;
  final Color fillColor;
  final Color textColor;

  MyTextField({
    Key? key,
    TextEditingController? controller,
    TextDirection? textDirection,
    required this.hintText,
    required this.obscureText,
    this.hintStyle,
    this.fillColor = Colors.grey,
    this.textColor = Colors.black,
  })  : controller = controller ?? TextEditingController(),
        textDirection = textDirection ?? TextDirection.ltr,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        textDirection: textDirection,
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
            ),
          ),
          fillColor: fillColor,
          filled: true,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(color: Colors.grey[500]),
          hintTextDirection: textDirection,
        ),
      ),
    );
  }
}
