import 'dart:io';
import 'package:e_shop_desktop/components/show_snackbar.dart';
import 'package:e_shop_desktop/handlers/state_handler.dart';
import '/providers/product_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '/components/custom_text_field.dart';
import '../../../../constants/constants.dart';

class AddProductsScreen extends StatefulWidget {
  static const routeName = 'add-product-screen';
  const AddProductsScreen({super.key});
  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  File? productImage;
  String? productId;
  void _startPickingImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      return;
    }
    File pickedImage = File(result.files.single.path!);
    setState(() => productImage = pickedImage);
  }

  final _formKey = GlobalKey<FormState>();
  final _productInfo = {
    'productName': '',
    'productCategory': 'iphone',
    'productPrice': '',
    'productStock': '',
  };
  void _submitInfo() {
    final isValidated = _formKey.currentState!.validate();
    if (!isValidated) {
      return;
    }
    if (productImage == null) {
      return;
    }
    _formKey.currentState!.save();
    if (productId == null) {
      Provider.of<ProductProvider>(context, listen: false)
          .addProduct(
        productId: const Uuid().v1(),
        productName: _productInfo['productName']!,
        productCategory: _productInfo['productCategory']!,
        productImageLocation: productImage!.path,
        productPrice: double.parse(_productInfo['productPrice']!),
        productStock: int.parse(_productInfo['productStock']!),
      )
          .whenComplete(() {
        Navigator.of(context).pop();
        ShowSnackBar(
          context: context,
          label: 'Product Added Successfully',
          color: MyColors.primaryColor,
        ).show();
      });
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(
        productId: productId!,
        productName: _productInfo['productName']!,
        productCategory: _productInfo['productCategory']!,
        productImageLocation: productImage!.path,
        productPrice: double.parse(_productInfo['productPrice']!),
        productStock: int.parse(_productInfo['productStock']!),
      )
          .whenComplete(() {
        Navigator.of(context).pop();
        ShowSnackBar(
          context: context,
          label: 'Product Updated Successfully',
          color: MyColors.primaryColor,
        ).show();
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: "iphone",
        child: Text(
          "Iphone",
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 15,
          ),
        ),
      ),
      DropdownMenuItem(
        value: "macbook",
        child: Text(
          "MacBook",
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 15,
          ),
        ),
      ),
      DropdownMenuItem(
        value: "laptop",
        child: Text(
          "Laptop",
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 15,
          ),
        ),
      ),
      DropdownMenuItem(
        value: "android",
        child: Text(
          "Android",
          style: MyFonts.getFont(
            color: MyColors.primaryColor,
            fontSize: 15,
          ),
        ),
      ),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    final modalData = ModalRoute.of(context)?.settings.arguments;
    if (modalData != null) {
      final productDataToBeUpdated = modalData as Map<String, dynamic>;
      _productInfo['productName'] = productDataToBeUpdated['productName'];
      _productInfo['productCategory'] =
          productDataToBeUpdated['productCategory'];
      _productInfo['productPrice'] = productDataToBeUpdated['productPrice'];
      _productInfo['productStock'] = productDataToBeUpdated['productStock'];
      productImage = File(productDataToBeUpdated['productImage']);
      productId = productDataToBeUpdated['productId'];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MyColors.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  productId == null ? 'Add Product' : 'Update Product',
                  style: MyFonts.getFont(
                    color: MyColors.primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name',
                        style: MyFonts.getFont(
                          color: MyColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomTextField(
                        initialValue: _productInfo['productName'],
                        hintText: 'Enter Name Here',
                        width: 500,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onSaved: (name) {
                          _productInfo['productName'] = name!;
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Product Category',
                        style: MyFonts.getFont(
                          color: MyColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Consumer<StateHandler>(
                        builder: (ctx, state, _) => DropdownButton(
                          iconEnabledColor: MyColors.primaryColor,
                          focusColor: Colors.transparent,
                          value: _productInfo['productCategory'],
                          items: dropdownItems,
                          onChanged: (category) {
                            _productInfo['productCategory'] = category!;
                            state.onDropDownValueChanged();
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Price \$',
                                style: MyFonts.getFont(
                                  color: MyColors.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              CustomTextField(
                                initialValue: _productInfo['productPrice'],
                                hintText: 'Enter Price Here',
                                width: 240,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                                onSaved: (price) {
                                  _productInfo['productPrice'] = price!;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Stock',
                                style: MyFonts.getFont(
                                  color: MyColors.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              CustomTextField(
                                initialValue: _productInfo['productStock'],
                                hintText: 'Enter Stock Here',
                                width: 240,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                                onSaved: (stock) {
                                  _productInfo['productStock'] = stock!;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Text(
                      'Product Image',
                      style: MyFonts.getFont(
                        color: MyColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 232,
                      decoration: ShapeDecoration(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: productImage == null
                          ? Text(
                              'Image Here!',
                              style: MyFonts.getFont(
                                color: MyColors.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                productImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 400,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: MyColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        onPressed: _startPickingImage,
                        child: Text(
                          'Pick Image',
                          style: MyFonts.getFont(
                            color: MyColors.secondaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: 952,
              height: 42,
              decoration: ShapeDecoration(
                color: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextButton(
                onPressed: _submitInfo,
                child: Text(
                  'Submit',
                  style: MyFonts.getFont(
                    color: MyColors.secondaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
