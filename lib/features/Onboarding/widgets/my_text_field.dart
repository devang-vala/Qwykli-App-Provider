import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String? hintText;
  final String labelText;
  final TextEditingController controller;
  final TextInputType? type;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLength;
  final AutovalidateMode? autovalidateMode;

  const MyTextfield({
    super.key,
    this.hintText,
    required this.labelText,
    required this.controller,
    this.validator,
    this.type,
    this.onChanged,
    this.maxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: labelText,
      textField: true,
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        maxLength: maxLength,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          counterText: "", // hides character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 0.1),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
