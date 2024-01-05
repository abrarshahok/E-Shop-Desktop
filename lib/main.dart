import 'package:e_shop_desktop/features/user_panel/screen/order/add_delivery_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import '/constants/constants.dart';
import '/handlers/state_handler.dart';
import '/providers/order_provider.dart';
import '/providers/cart_provider.dart';
import '/providers/auth_provider.dart';
import '/features/auth/auth_screen.dart';
import '/providers/product_provider.dart';
import '/features/user_panel/user_screen.dart';
import '/features/admin_panel/admin_screen.dart';
import '/features/user_panel/screen/product/product_screen.dart';
import 'features/admin_panel/screens/products/add_products_screen.dart';
import '/features/admin_panel/screens/products/manage_products_screen.dart';

void main() async {
  sqfliteFfiInit();
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1440, 900),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => StateHandler(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.grey,
            ),
          ),
          home: (auth.isAuth)
              ? (AuthProvider.currentUserRole == 'admin')
                  ? const AdminScreen()
                  : const UserScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, futureSnapshot) {
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: MyColors.primaryColor,
                        ),
                      );
                    }
                    return const AuthScreen();
                  },
                ),
          routes: {
            AdminScreen.routeName: (context) => const AdminScreen(),
            UserScreen.routeName: (context) => const UserScreen(),
            AddProductsScreen.routeName: (context) => const AddProductsScreen(),
            AuthScreen.routeName: (context) => const AuthScreen(),
            ProductScreen.routeName: (context) => const ProductScreen(),
            ManageProductsScreen.routeName: (context) =>
                const ManageProductsScreen(),
            AddDeliveryInformationScreen.routeName: (context) =>
                AddDeliveryInformationScreen(),
          },
        ),
      ),
    );
  }
}
