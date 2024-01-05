import 'package:flutter/material.dart';
import '../constants/constants.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.child,
    required this.value,
    required this.color,
  });

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          left: 50,
          bottom: 23,
          child: value == '0'
              ? Container()
              : CircleAvatar(
                  backgroundColor: MyColors.primaryColor,
                  radius: 11,
                  child: FittedBox(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: MyFonts.getFont(
                        color: MyColors.secondaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
