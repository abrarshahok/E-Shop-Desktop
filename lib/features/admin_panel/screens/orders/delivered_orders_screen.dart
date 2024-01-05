import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '/providers/order_provider.dart';
import '/features/admin_panel/widgets/orders/manage_order_item.dart';

class DeliveredOrdersScreen extends StatelessWidget {
  const DeliveredOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return orders.deliveredOrders.isEmpty
        ? notFound('No Delivered Orders!')
        : ListView.builder(
            itemCount: orders.deliveredOrders.length,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: orders.deliveredOrders[index],
              child:const ManageOrderItem(),
            ),
          );
  }
}
