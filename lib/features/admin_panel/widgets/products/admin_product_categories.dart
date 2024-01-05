import 'package:e_shop_desktop/features/admin_panel/screens/products/manage_products_screen.dart';
import 'package:flutter/material.dart';
import '../../../user_panel/widget/product/product_categories.dart';
import '/constants/constants.dart';
import '../../../../../models/product.dart';

class AdminProductCategoriesScreen extends StatelessWidget {
  const AdminProductCategoriesScreen({super.key});
  final List<Map<String, dynamic>> _categories = const [
    {
      'title': 'IPhones',
      'image': MyImages.iphone,
      'category': Categories.iphone,
    },
    {
      'title': 'MacBooks',
      'image': MyImages.macbook,
      'category': Categories.macbook,
    },
    {
      'title': 'Laptops',
      'image': MyImages.laptop,
      'category': Categories.laptop,
    },
    {
      'title': 'Android Phones',
      'image': MyImages.android,
      'category': Categories.android,
    },
  ];

  Widget myContainer(String imageLocation) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imageLocation,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Products',
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(50),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _categories.length,
        itemBuilder: (ctx, index) => ProductCategories(
          title: _categories[index]['title'],
          image: _categories[index]['image'],
          category: _categories[index]['category'],
          onTap: () {
            Navigator.of(context).pushNamed(
              ManageProductsScreen.routeName,
              arguments: {
                'title': _categories[index]['title'],
                'category': _categories[index]['category'],
              },
            );
          },
        ),
      ),
    );
  }
}
