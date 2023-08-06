import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String labelText;
  final ValueChanged<String> onChanged;

  TextInput({required this.labelText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
