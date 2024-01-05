import 'package:e_shop_desktop/components/custom_text_field.dart';
import 'package:e_shop_desktop/constants/constants.dart';
import 'package:e_shop_desktop/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/product_provider.dart';
import '../../widget/product/product_items.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/products-screen';
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future? _futureProducts;
  Future getFutureProducts() {
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
    final product = modalData as Map<String, dynamic>;
    final Categories category = product['category'];
    final title = product['title'];
    final productData = Provider.of<ProductProvider>(context);
    final products = productData.getCategoryProducts(category);

    return Scaffold(
      appBar: appBar(title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: CustomTextField(
              hintText: 'Search Products',
              onChanged: (value) {
                productData.searchProduct(value!.trim(), category.name);
              },
            ),
          ),
          if (products.isEmpty)
            notFound('Products not found!')
          else
            FutureBuilder(
              future: _futureProducts,
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  );
                }

                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (ctx, index) => ProductItems(
                      id: products[index].productId,
                      title: products[index].productName,
                      image: products[index].productImageLocation,
                      price: products[index].productPrice,
                      stock: products[index].productStock,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
