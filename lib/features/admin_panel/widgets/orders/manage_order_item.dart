import 'dart:io';
import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/show_snackbar.dart';
import '/models/order_item.dart';
import '/providers/order_provider.dart';
import '/constants/constants.dart';

class ManageOrderItem extends StatefulWidget {
  const ManageOrderItem({super.key});

  @override
  State<ManageOrderItem> createState() => _ManageOrderItemState();
}

class _ManageOrderItemState extends State<ManageOrderItem> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: '0',
        child: Text(
          'Pending',
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      DropdownMenuItem(
        value: '1',
        child: Text(
          'Delivered',
          style: MyFonts.getFont(
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
    return menuItems;
  }

  bool _isExpanded = false;

  void sendNotification(String name) async {
    var client = NotificationsClient();
    await client.notify(
      'From E-Shop to $name',
      expireTimeoutMs: 10000,
      body: '$name your Order is Delivered.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderItem>(context, listen: false);
    final products = order.products;
    String formatedDateTime =
        'Order Placed on ${DateFormat('dd/MM/yyy').format(order.dateTime)} at ${DateFormat('hh:mm a').format(order.dateTime)}';
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order No#${order.id.substring(0, 7)}',
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Customer Name: ${order.customerName}',
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Customer Address: ${order.customerAddress}',
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      formatedDateTime,
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$${order.amount.toStringAsFixed(2)}',
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Status',
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<OrderItem>(
                      builder: (ctx, state, _) => DropdownButton(
                        iconEnabledColor: MyColors.primaryColor,
                        focusColor: Colors.transparent,
                        value: order.isDelivered ? '1' : '0',
                        items: dropdownItems,
                        onChanged: (status) {
                          final isDelivered = status == '0' ? false : true;
                          Provider.of<OrderProvider>(context, listen: false)
                              .changeOrderStatus(
                            orderId: order.id,
                            status: int.parse(status!),
                          )
                              .whenComplete(() {
                            state.toggleStatus(isDelivered);
                            if (isDelivered) {
                              sendNotification(order.customerName);
                            }
                            ShowSnackBar(
                              context: context,
                              label: isDelivered
                                  ? 'Status changed to Delivered.'
                                  : 'Status changed to Pending.',
                              color: MyColors.primaryColor,
                            ).show();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
            height: _isExpanded ? products.length * 85 : 0,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) => ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey[50],
                  child: Image.file(
                    File(products[index].image),
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(
                  products[index].title,
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Ordered ${products[index].quantity} item(s)',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
