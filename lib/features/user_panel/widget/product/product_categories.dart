import 'package:e_shop_desktop/constants/constants.dart';
import 'package:flutter/material.dart';
import '/models/product.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({
    super.key,
    required this.title,
    required this.image,
    required this.category,
    required this.onTap,
  });
  final String title;
  final String image;
  final Categories category;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      shadowColor: Colors.black,
      child: GridTile(
        footer: Container(
          height: 40,
          width: double.infinity,
          color: Colors.grey[800],
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: MyFonts.getFont(
              color: MyColors.secondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
