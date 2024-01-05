import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ConfirmationDialogue {
  final BuildContext context;
  final String message;
  final VoidCallback onTapYes;

  ConfirmationDialogue({
    required this.context,
    required this.message,
    required this.onTapYes,
  });

  show() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        titleTextStyle: MyFonts.getFont(
          color: MyColors.secondaryColor,
          fontSize: 15,
        ),
        contentTextStyle:
            MyFonts.getFont(color: MyColors.secondaryColor, fontSize: 12),
        backgroundColor: MyColors.primaryColor,
        title: const Text('Are you sure?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'No',
              style:
                  MyFonts.getFont(color: MyColors.secondaryColor, fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: onTapYes,
            child: Text(
              'Yes',
              style:
                  MyFonts.getFont(color: MyColors.secondaryColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
