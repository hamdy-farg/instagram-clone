import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String hintText;
  bool secure;
  IconButton? icon;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  TextEditingController textEditingController;
  CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.secure = false,
      this.icon,
      required this.validator,
      this.keyboardType});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      controller: widget.textEditingController,
      validator: widget.validator,
      obscureText: widget.secure,
      decoration: InputDecoration(
          border: InputBorder,
          focusedBorder: InputBorder,
          suffixIcon: widget.icon,
          hintText: widget.hintText,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          
        
          ),
      keyboardType: widget.keyboardType,
    );
  }
}
