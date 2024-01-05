import 'dart:io';
import 'package:e_shop_desktop/components/confirmation_dialogue.dart';

import '../../../../components/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/constants/constants.dart';
import '/providers/product_provider.dart';
import '../../screens/products/add_products_screen.dart';

class ManageProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String productCategory;
  final String productImage;
  final double productPrice;
  final int productStock;

  const ManageProductCard({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productImage,
    required this.productPrice,
    required this.productStock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      elevation: 5,
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(productImage),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                productName,
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Price \$$productPrice',
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Available Items ($productStock)',
                    style: MyFonts.getFont(
                      color: MyColors.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddProductsScreen.routeName,
                arguments: {
                  'productId': productId,
                  'productName': productName,
                  'productCategory': productCategory,
                  'productImage': productImage,
                  'productPrice': productPrice.toString(),
                  'productStock': productStock.toString(),
                },
              );
            },
            icon: const Icon(
              Icons.edit,
              color: MyColors.primaryColor,
            ),
          ),
          const SizedBox(width: 30),
          IconButton(
            onPressed: () {
              ConfirmationDialogue(
                  context: context,
                  message: 'Do you want to delete this product?',
                  onTapYes: () {
                    Provider.of<ProductProvider>(context, listen: false)
                        .deleteProduct(productId)
                        .whenComplete(() {
                      Navigator.of(context).pop();
                      ShowSnackBar(
                        context: context,
                        label: 'Product Deleted Successfully',
                        color: MyColors.primaryColor,
                      ).show();
                    });
                  }).show();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
