import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/order_provider.dart';
import '../../widget/order/user_order_items.dart';
import '/constants/constants.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  Future? futureOrders;

  Future getFutureOrders() {
    return Provider.of<OrderProvider>(context, listen: false).fetchUserOrders();
  }

  @override
  void initState() {
    futureOrders = getFutureOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: orderData.itemCount <= 0
          ? notFound('No orders added yet!')
          : FutureBuilder(
              future: futureOrders,
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: orderData.allOrders.length,
                  itemBuilder: (ctx, index) => UserOrderItems(
                    order: orderData.allOrders[index],
                  ),
                );
              },
            ),
    );
  }
}
