import 'package:e_shop_desktop/features/admin_panel/widgets/orders/manage_order_item.dart';
import 'package:e_shop_desktop/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/constants.dart';

class AllOrdersScreen extends StatelessWidget {
  const AllOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return orders.allOrders.isEmpty
        ? notFound('No Orders Found!')
        : ListView.builder(
            itemCount: orders.itemCount,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: orders.allOrders[index],
              child: const ManageOrderItem(),
            ),
          );
  }
}
