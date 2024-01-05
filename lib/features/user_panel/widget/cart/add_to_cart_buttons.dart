import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/constants/constants.dart';
import '/components/confirmation_dialogue.dart';
import '../../../../components/show_snackbar.dart';
import '../../../../providers/cart_provider.dart';
import '/providers/product_provider.dart';

class AddToCartButtons extends StatelessWidget {
  const AddToCartButtons({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (cart.cartItems[productId]!.quantity == 1) {
              ConfirmationDialogue(
                context: context,
                message: 'Do you want to remove this item from cart?',
                onTapYes: () {
                  cart.removeItem(productId: productId);
                  Navigator.of(context).pop();
                  ShowSnackBar(
                    context: context,
                    label: 'Item removed from cart.',
                    color: MyColors.primaryColor,
                  ).show();
                },
              ).show();
              return;
            }
            cart.removeItem(productId: productId);
          },
          icon: const Icon(Icons.remove),
          color: MyColors.primaryColor,
        ),
        Container(
          height: 40,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: MyColors.primaryColor,
            ),
          ),
          child: Consumer<CartProvider>(
            builder: (context, cart, child) => FittedBox(
              child: Text(
                '${cart.cartItems[productId]?.quantity ?? 0}',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            int cartItemQuantity = cart.cartItems[productId]?.quantity ?? 0;
            if (product.productStock <= cartItemQuantity) {
              return;
            }
            cart.addItem(
              productId: productId,
              title: product.productName,
              imageUrl: product.productImageLocation,
              price: product.productPrice,
            );
          },
          icon: const Icon(Icons.add),
          color: MyColors.primaryColor,
        ),
      ],
    );
  }
}
