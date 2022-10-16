
import 'package:flutter/material.dart';

KSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$message'),
    )
  );
}