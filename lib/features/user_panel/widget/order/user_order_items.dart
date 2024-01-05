import 'dart:io';
import 'package:e_shop_desktop/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/order_item.dart';

class UserOrderItems extends StatefulWidget {
  final OrderItem order;
  const UserOrderItems({super.key, required this.order});

  @override
  State<UserOrderItems> createState() => _UserOrderItemsState();
}

class _UserOrderItemsState extends State<UserOrderItems> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final products = widget.order.products;
    String formatedDateTime =
        'Purchased on ${DateFormat('dd/MM/yyy').format(widget.order.dateTime)} at ${DateFormat('hh:mm a').format(widget.order.dateTime)}';
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  '\$${widget.order.amount.toStringAsFixed(2)}',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.order.isDelivered ? 'Recieved' : 'Pending',
                  style: MyFonts.getFont(
                    color: widget.order.isDelivered
                        ? Colors.green
                        : MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${widget.order.customerName}',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Delivery Address: ${widget.order.customerAddress}',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatedDateTime,
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
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
            height: _isExpanded ? products.length * 80 : 0,
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
                  'Purchased ${products[index].quantity} item(s)',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 12,
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
