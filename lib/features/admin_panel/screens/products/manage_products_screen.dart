import 'package:e_shop_desktop/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/custom_text_field.dart';
import '../../../../constants/constants.dart';
import '../../../../providers/product_provider.dart';
import '../../widgets/products/manage_product_card.dart';
import 'add_products_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  static const routeName = '/manage-product-screen';
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  Future? _futureProducts;
  Future? getFutureProducts() {
    return Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsInfo();
  }

  @override
  void initState() {
    _futureProducts = getFutureProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modalData = ModalRoute.of(context)?.settings.arguments;
    final productInfoMap = modalData as Map<String, dynamic>;
    final Categories category = productInfoMap['category'];
    final title = productInfoMap['title'];
    final product = Provider.of<ProductProvider>(context);
    final productsInfo = product.getCategoryProducts(category);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage $title',
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Search Products',
            width: 500,
            onChanged: (value) {
              product.searchProduct(value!.trim(), category.name);
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: (productsInfo.isEmpty)
                ? notFound('Products not found!')
                : FutureBuilder(
                    future: _futureProducts,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: MyColors.primaryColor,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: productsInfo.length,
                        itemBuilder: (ctx, index) => ManageProductCard(
                          productId: productsInfo[index].productId,
                          productName: productsInfo[index].productName,
                          productCategory:
                              productsInfo[index].productCategory.name,
                          productImage:
                              productsInfo[index].productImageLocation,
                          productPrice: productsInfo[index].productPrice,
                          productStock: productsInfo[index].productStock,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: MyColors.secondaryColor,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AddProductsScreen.routeName);
        },
      ),
    );
  }
}
