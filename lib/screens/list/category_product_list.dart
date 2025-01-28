import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../../../constants.dart';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Category_product_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../product_detail_screen.dart';

class CategoryProduct extends StatefulWidget {

  const CategoryProduct({Key? key, required this.categoryName, required this.categoryId}) : super(key: key);
  final String categoryName;
  final String categoryId;

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {

  bool isLoading = true;
  List<Products> ?productsCategory = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
  }
  _getProducts() async {
    String url = ApiUrl.categoryProducts + widget.categoryId;
    print('Fetching products from: $url');

    try {
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print('Response body: ${response.body}');
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['products'] != null) {
          List<dynamic> productList = responseData['products'];

          if (productList.isEmpty) {
            // Show a message if no products are found
            showSnackbar('No products available in this category.');
          } else {
            setState(() {
              productsCategory = productList
                  .map((data) => Products.fromJson(data))
                  .toList();
            });
          }
        } else {
          // Show a message if the response doesn't contain products
          showSnackbar('No products found.');
        }
      } else {
        // Handle HTTP errors
        print('Failed to fetch products. HTTP Status Code: ${response.statusCode}');
        ('Failed to fetch products. Please try again.');
      }
    } catch (error) {
      // Handle any errors during the API call
      print('Error fetching products: $error');
      showSnackbar('An error occurred while fetching products.');
    } finally {
      // Ensure loading is turned off
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            BackWidget(title: '${widget.categoryName} Products'),
            SizedBox(height: 10),
            isLoading
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : (productsCategory == null || productsCategory!.isEmpty
                ? emptyWidgetCategoryProducts(context)
                : productWidget()),
          ],
        ),
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }


  Widget emptyWidgetCategoryProducts(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or image indicating an empty state
          Icon(
            Icons.category_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          // Main message
          Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          // Subtitle message
          Text(
            'It seems there are no products available under this category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24),
          // "Browse Categories" button

        ],
      ),
    );
  }




  showSnackbar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      backgroundColor: CustomColor.primaryColor,
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      duration: Duration(seconds: 4),
    ));
  }


  Widget productWidget() {
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
      ),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Products product = productsCategory![index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Productdetail(productId: product.productId.toString()),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 5),
                        product.photo != null
                            ? Image.network(
                          product.photo.toString(),
                          width: 140,
                          height: 100,
                        )
                            : Image.asset(
                          'assets/images/noimage.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 12 * 0.5),
                        Text(
                          product.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomColor.accentColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10 * 0.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (product.onsale_price != null && product.onsale_price != product.price) ...[
                                // Original Price with Strikethrough
                                Text(
                                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8), // Space between original and sale price
                                // Sale Price
                                Text(
                                  '\$${product.onsale_price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ] else ...[
                                // Regular Price
                                Text(
                                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: productsCategory!.length,
      ),
    );
  }




}


