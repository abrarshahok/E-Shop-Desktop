import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:e_shop_desktop/components/custom_text_field.dart';
import 'package:e_shop_desktop/models/cart_item.dart';
import 'package:e_shop_desktop/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../components/confirmation_dialogue.dart';
import '../../../../components/show_snackbar.dart';
import '../../../../constants/constants.dart';
import '../../../../providers/order_provider.dart';

class AddDeliveryInformationScreen extends StatelessWidget {
  AddDeliveryInformationScreen({super.key});
  static const routeName = '/add-delivery-info-screen';
  final fullNameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void confirmOrder({
    required double totalPrice,
    required List<CartItem> cartItems,
    required BuildContext context,
  }) {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final cart = Provider.of<CartProvider>(context, listen: false);
    ConfirmationDialogue(
        context: context,
        message: 'Do you want to Place Order?',
        onTapYes: () {
          Provider.of<OrderProvider>(context, listen: false)
              .addOrder(
                totalPrice: totalPrice,
                cartItems: cartItems,
                customerName: fullNameTextController.text,
                customerAddress: addressTextController.text,
              )
              .whenComplete(() => cart.clearCart());
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          sendNotification();
          ShowSnackBar(
            context: context,
            label: 'Order Placed Successfully.',
            color: MyColors.primaryColor,
          ).show();
        }).show();
  }

  void sendNotification() async {
    var client = NotificationsClient();
    await client.notify(
      'From E-Shop to Admin',
      body: 'You Recieved an Order from ${fullNameTextController.text}',
      expireTimeoutMs: 10000,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final double totalPrice = routeData['totalPrice'];
    final List<CartItem> cartItems = routeData['cartItems'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Delivery Inforamtion',
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Full Name',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              CustomTextField(
                hintText: 'Enter Name Here',
                width: 400,
                controller: fullNameTextController,
                validator: (name) {
                  if (name!.isEmpty) {
                    return 'This field is required!';
                  } else if (name.length < 3) {
                    return 'Please enter valid name!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Delivery Address',
                style: MyFonts.getFont(
                  color: MyColors.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              CustomTextField(
                hintText: 'Enter Address Here',
                width: 400,
                controller: addressTextController,
                validator: (address) {
                  if (address!.isEmpty) {
                    return 'This field is required!';
                  } else if (address.length < 3) {
                    return 'Please enter valid address!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => confirmOrder(
                  context: context,
                  cartItems: cartItems,
                  totalPrice: totalPrice,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Confirm',
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
      ),
    );
  }
}
