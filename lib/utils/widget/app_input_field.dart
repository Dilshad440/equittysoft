import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    Key? key,
    required this.onChanged,
    this.hintText,
    this.maxLine,
    this.initialValue,
  }) : super(key: key);

  final Function(String)? onChanged;
  final String? hintText;
  final int? maxLine;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLine,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent)),
      ),
    );
  }
}
