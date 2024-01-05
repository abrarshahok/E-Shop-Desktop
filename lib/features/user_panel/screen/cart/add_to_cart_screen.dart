import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/show_snackbar.dart';
import '/constants/constants.dart';
import '/providers/product_provider.dart';
import '../../widget/cart/add_to_cart_buttons.dart';

class AddToCartScreen extends StatelessWidget {
  const AddToCartScreen({super.key});
  static const routeName = '/add-to-cart-screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 150,
                width: 200,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.file(
                    File(product.productImageLocation),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                '\$${product.productPrice}',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const Divider(color: MyColors.primaryColor, thickness: 0.3),
          Row(
            children: [
              Text(
                'Item(s) available in stock',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                '${product.productStock}',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const Divider(color: MyColors.primaryColor, thickness: 0.3),
          Row(
            children: [
              Text(
                'Quantity',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              AddToCartButtons(productId: productId),
            ],
          ),
          const Divider(color: MyColors.primaryColor, thickness: 0.3),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              ShowSnackBar(
                context: context,
                label: 'Item added to cart successfully.',
                color: MyColors.primaryColor,
              ).show();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add to Cart',
              style: MyFonts.getFont(
                color: MyColors.secondaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
