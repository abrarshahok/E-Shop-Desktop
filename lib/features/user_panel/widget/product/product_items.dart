import 'dart:io';
import 'package:flutter/material.dart';
import '/constants/constants.dart';
import '/features/user_panel/screen/cart/add_to_cart_screen.dart';

class ProductItems extends StatelessWidget {
  const ProductItems({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.stock,
  });
  final String id;
  final String title;
  final String image;
  final double price;
  final int stock;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            Hero(
              tag: id,
              child: Image.file(
                File(image),
                fit: BoxFit.contain,
                height: 200,
                alignment: Alignment.center,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MyFonts.getFont(
                color: MyColors.primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price \$$price',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MyFonts.getFont(
                color: MyColors.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => const AddToCartScreen(),
                  routeSettings: RouteSettings(arguments: id),
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: MyColors.secondaryColor,
              ),
              label: Text(
                'Add to Cart',
                style: MyFonts.getFont(
                  color: MyColors.secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
