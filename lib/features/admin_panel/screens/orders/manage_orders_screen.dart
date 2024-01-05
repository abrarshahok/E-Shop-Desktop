import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/order_provider.dart';
import '/constants/constants.dart';
import '/features/admin_panel/screens/orders/all_orders_screen.dart';
import '/features/admin_panel/screens/orders/delivered_orders_screen.dart';
import '/features/admin_panel/screens/orders/pending_orders_screen.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen>
    with SingleTickerProviderStateMixin {
  Widget customContainer({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: 200,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: MyColors.primaryColor,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              subtitle,
              style: MyFonts.getFont(
                color: MyColors.secondaryColor,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final allOrders = orderProvider.allOrders;
    final deliveredOrders = orderProvider.deliveredOrders;
    final pendingOrders = orderProvider.pendingOrders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Orders',
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customContainer(
                        title: 'Total Earning',
                        subtitle: '\$${orderProvider.earningInAccount}',
                      ),
                      customContainer(
                        title: 'Pending Earning',
                        subtitle: '\$${orderProvider.pendingEarning}',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customContainer(
                        title: 'Total Orders',
                        subtitle: '${allOrders.length}',
                      ),
                      customContainer(
                        title: 'Pending Orders',
                        subtitle: '${pendingOrders.length}',
                      ),
                      customContainer(
                        title: 'Delivered Orders',
                        subtitle: '${deliveredOrders.length}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      thickness: 0.3,
                      height: 0.1,
                    ),
                  ),
                  TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        child: Text(
                          'All Orders',
                          style: MyFonts.getFont(
                            color: MyColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Pending Orders',
                          style: MyFonts.getFont(
                            color: MyColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Delivered Orders',
                          style: MyFonts.getFont(
                            color: MyColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            AllOrdersScreen(),
            PendingOrdersScreen(),
            DeliveredOrdersScreen(),
          ],
        ),
      ),
    );
  }
}
