import 'dart:io';

import 'package:e_shop_desktop/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/product_provider.dart';
import 'add_to_cart_buttons.dart';

class CartItems extends StatelessWidget {
  final String productId;
  final int quantity;

  const CartItems({
    super.key,
    required this.productId,
    required this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.all(20),
              child: Image.file(
                File(product.productImageLocation),
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Only ${product.productStock} item(s) in stock',
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: \$${product.productPrice}',
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AddToCartButtons(productId: productId),
          ],
        ),
      ),
    );
  }
}
