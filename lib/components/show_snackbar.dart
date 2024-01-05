import 'package:e_shop_desktop/constants/constants.dart';
import 'package:flutter/material.dart';

class ShowSnackBar {
  final BuildContext context;
  final String label;
  final Color color;
  const ShowSnackBar({
    required this.context,
    required this.label,
    required this.color,
  });
  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 500,
        content: Text(
          label,
          style: MyFonts.getFont(
            color: MyColors.secondaryColor,
            fontSize: 15,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
