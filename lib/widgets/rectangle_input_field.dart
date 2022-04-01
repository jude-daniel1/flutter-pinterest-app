import 'package:flutter/material.dart';
import 'package:flutter_pinterest_clone/widgets/text_field_container.dart';

class RectangularInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController textEditingController;
  const RectangularInputField(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.obscureText,
      required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        cursorColor: Colors.white,
        obscureText: obscureText,
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: hintText,
            helperStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white,
              size: 12,
            ),
            border: InputBorder.none),
      ),
    );
  }
}
