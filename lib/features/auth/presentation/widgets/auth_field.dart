import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final bool showPassword;
  final TextInputAction? inputAction;
  final VoidCallback? obsecureOnTap;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.showPassword = false,
    this.inputAction,
    this.obsecureOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: isObscureText
            ? GestureDetector(
                onTap: obsecureOnTap,
                child: showPassword
                    ? const Icon(Icons.lock_open)
                    : const Icon(Icons.no_encryption_gmailerrorred_outlined),
              )
            : null,
      ),
      textInputAction: inputAction ?? TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
      obscureText: showPassword,
    );
  }
}
