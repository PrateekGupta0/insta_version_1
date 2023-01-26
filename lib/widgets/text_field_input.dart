import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass; // is password or not
  final String hinttext;
  final TextInputType textInputType;
  const TextFieldInput(
      {Key? key,
      required this.textInputType,
      required this.textEditingController,
      required this.hinttext,
      this.isPass=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hinttext,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: textInputType,
      obscureText: isPass, //password
    );
  }
}
