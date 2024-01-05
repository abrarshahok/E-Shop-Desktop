import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_screen.dart';
import '/components/badge_widget.dart';
import '/providers/cart_provider.dart';
import '/providers/auth_provider.dart';
import '/providers/order_provider.dart';
import '../../constants/constants.dart';
import '/providers/product_provider.dart';
import 'screen/product/product_categories_screen.dart';
import '/features/user_panel/screen/cart/cart_screen.dart';
import '/features/user_panel/screen/order/user_orders_screen.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user-screen';
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
    Provider.of<ProductProvider>(context, listen: false).fetchProductsInfo();
    Provider.of<CartProvider>(context, listen: false).fetchCartItems();
    Provider.of<OrderProvider>(context, listen: false).fetchUserOrders();
    super.initState();
  }

  final _pages = const [
    ProductCategoriesScreen(),
    CartScreen(),
    UserOrdersScreen(),
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: 400,
            color: MyColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  'Welcome ${AuthProvider.currentUsername}!',
                  style: MyFonts.getFont(
                    color: MyColors.secondaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 100),
                _customTile(
                  icon: MyIcons.allProducts,
                  title: 'All Products',
                  onTap: () {
                    setState(() {
                      _currentPageIndex = 0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Consumer<CartProvider>(
                  builder: (ctx, cart, _) => BadgeWidget(
                    value: cart.itemsCount.toString(),
                    color: MyColors.primaryColor,
                    child: _customTile(
                      icon: MyIcons.cart,
                      title: 'Your Cart',
                      onTap: () {
                        setState(() {
                          _currentPageIndex = 1;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _customTile(
                  icon: MyIcons.orders,
                  title: 'Your Orders',
                  onTap: () {
                    setState(() {
                      _currentPageIndex = 2;
                    });
                  },
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
                      Navigator.of(context).pushReplacementNamed(
                        AuthScreen.routeName,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(child: _pages[_currentPageIndex]),
        ],
      ),
    );
  }
}
