import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/best_products_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
 import 'package:fishtohome/widgets/footer_widget.dart';
import 'package:fishtohome/modals/Productdetail_modal.dart';
import '../product_detail_screen.dart';
import '../../../constants.dart';
import 'dart:ui'; // Import this for Color class

class TypeProductsScreen extends StatefulWidget {
  const TypeProductsScreen({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  _TypeProductsScreenState createState() => _TypeProductsScreenState();
}

class _TypeProductsScreenState extends State<TypeProductsScreen> {
  bool isLoading = true;
  List<Productsmodal>? products = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
  }



  void _getProducts() async {
    setState(() {
      isLoading = true;
    });

    String url = '${ApiUrl.ProductsType}/${widget.type}'; // Your API endpoint
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
          if (productList.isNotEmpty) {
            setState(() {
              isLoading = false;
              products = productList.map((data) => Productsmodal.fromJson(data)).toList();
            });
          } else {
            setState(() {
              isLoading = false;
              products = []; // Set to an empty list explicitly
            });
            showSnackbar('No products found.');
          }
        } else {
          setState(() {
            isLoading = false;
          });
          showSnackbar('Failed to load products.');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackbar('We couldn’t find any products for this type.');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showSnackbar('An error occurred while fetching products.');
      print('Error fetching products: $error');
    }
  }
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (products!.isEmpty
          ? emptyWidgetTypeProducts(context)
          : _productsList()),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  Widget emptyWidgetTypeProducts(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image for Empty State
          Icon(
            Icons.inventory_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          // Main Message
          Text(
            'No Products Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          // Subtitle Message
          Text(
            'We couldn’t find any products for this type.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24),
          // Navigate Back or Explore More

        ],
      ),
    );
  }


  Widget _productsList() {
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
              Productsmodal product = products![index];
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
                        product.imageThumb != null
                            ? Image.network(
                          product.imageThumb.toString(),
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
                          product.productName.toString(),
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
                              if (product.onsalePrice != null && product.onsalePrice != product.price) ...[
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
                                  '\$${product.onsalePrice?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ] else ...[
                                // Regular Price (if no onsale_price or equal to price)
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
        childCount: products!.length,
      ),
    );
  }





}
