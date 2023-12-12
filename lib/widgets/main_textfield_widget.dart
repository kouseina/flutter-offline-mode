import 'package:flutter/material.dart';

class MainTextFieldWidget extends StatelessWidget {
  const MainTextFieldWidget(
      {super.key,
      required this.controller,
      required this.labelText,
      this.textInputType,
      this.obscureText});
  final TextEditingController controller;
  final String labelText;
  final TextInputType? textInputType;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        isDense: true,
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return "Required";
        return null;
      },
    );
  }
}
