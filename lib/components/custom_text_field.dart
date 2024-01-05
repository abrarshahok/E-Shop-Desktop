import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final bool obscureText;
  final FocusNode? focusNode;
  final int? maxLength;
  final double? width;
  
  final int? maxLines;
  final String? initialValue;
  final String? getKey;

  const CustomTextField({
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.initialValue,
    this.width,
    
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.focusNode,
    this.controller,
    this.maxLength,
    this.obscureText = false,
    this.onChanged,
    this.getKey,
  });

  InputBorder getBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        key: ValueKey(key),
        initialValue: initialValue,
        maxLines: maxLines,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 10,
          ),
          hintStyle: MyFonts.getFont(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          enabledBorder: getBorder(color: Colors.grey),
          focusedBorder: getBorder(color: Colors.grey),
          errorBorder: getBorder(color: Colors.red),
          focusedErrorBorder: getBorder(color: Colors.red),
        ),
        onChanged: onChanged,
        maxLength: maxLength,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        obscureText: obscureText,
      ),
    );
  }
}
