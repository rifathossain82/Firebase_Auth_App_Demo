import 'package:flutter/material.dart';

class KButton extends StatelessWidget {
  const KButton({Key? key, required this.onPressed, required this.title}) : super(key: key);
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('$title'),
    );
  }
}
