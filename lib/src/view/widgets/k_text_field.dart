import 'package:flutter/material.dart';

class KTextField extends StatelessWidget {
  const KTextField({Key? key, required this.controller, required this.hintText}) : super(key: key);
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder()
      ),
    );
  }
}
