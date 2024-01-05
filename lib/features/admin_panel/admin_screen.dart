import 'package:e_shop_desktop/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/badge_widget.dart';
import '/features/auth/auth_screen.dart';
import '/constants/constants.dart';
import '../../providers/auth_provider.dart';
import 'screens/products/add_products_screen.dart';
import 'widgets/products/admin_product_categories.dart';
import '/features/admin_panel/screens/orders/manage_orders_screen.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = '/admin-screen';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Widget _customTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 50,
        width: 60,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          icon,
          color: MyColors.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: MyFonts.getFont(
          color: MyColors.secondaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).fetchAllOrdersForAdmin();
    super.initState();
  }

  final _allScreens = const [
    AdminProductCategoriesScreen(),
    ManageOrdersScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: MyColors.primaryColor,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  'E Shop',
                  style: MyFonts.getFont(
                    color: MyColors.secondaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                _customTile(
                  icon: MyIcons.manageProducts,
                  title: 'Manage Products',
                  onTap: () => setState(() => currentIndex = 0),
                ),
                const SizedBox(height: 30),
                Consumer<OrderProvider>(
                  builder: (ctx, order, _) => BadgeWidget(
                    value: order.pendingOrders.length.toString(),
                    color: MyColors.primaryColor,
                    child: _customTile(
                      icon: MyIcons.orders,
                      title: 'Manage Orders',
                      onTap: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                    ),
                  ),
                ),
                const Spacer(),
                _customTile(
                  icon: MyIcons.user,
                  title: 'Logout',
                  onTap: () {
                    final auth =
                        Provider.of<AuthProvider>(context, listen: false);
                    auth.logout();
                    if (!auth.isAuth) {
                      Navigator.of(context)
                          .pushReplacementNamed(AuthScreen.routeName);
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(child: _allScreens[currentIndex])
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: MyColors.primaryColor,
              child: const Icon(
                Icons.add,
                color: MyColors.secondaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddProductsScreen.routeName);
              },
            )
          : null,
    );
  }
}
