import 'package:e_shop_desktop/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/order_provider.dart';
import '/features/admin_panel/widgets/orders/manage_order_item.dart';

class PendingOrdersScreen extends StatelessWidget {
  const PendingOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return orders.pendingOrders.isEmpty
        ? notFound('No Pending Orders!')
        : ListView.builder(
            itemCount: orders.pendingOrders.length,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: orders.pendingOrders[index],
              child: const ManageOrderItem(),
            ),
          );
  }
}
