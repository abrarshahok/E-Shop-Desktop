import 'package:e_shop_desktop/components/confirmation_dialogue.dart';
import 'package:e_shop_desktop/components/show_snackbar.dart';
import 'package:e_shop_desktop/features/user_panel/screen/order/add_delivery_info_screen.dart';
import 'package:e_shop_desktop/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../models/cart_item.dart';
import '../../../../providers/cart_provider.dart';

class PlaceOrder extends StatelessWidget {
  final CartProvider cart;
  final List<CartItem> cartValues;

  const PlaceOrder({
    super.key,
    required this.cart,
    required this.cartValues,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Total Bill',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.total.toStringAsFixed(2)}',
                    style: MyFonts.getFont(
                      color: MyColors.secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.grey[800],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    AddDeliveryInformationScreen.routeName,
                    arguments: {
                      'totalPrice': cart.total,
                      'cartItems': cart.cartItems.values.toList(),
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Place Order',
                style: MyFonts.getFont(
                  color: MyColors.secondaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
