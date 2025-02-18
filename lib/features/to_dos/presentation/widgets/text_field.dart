import 'package:flutter/material.dart';

class TodoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction? inputAction;
  const TodoTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.inputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: 1,
      textInputAction: inputAction ?? TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
