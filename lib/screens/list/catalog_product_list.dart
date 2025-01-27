import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Catalog_products_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants.dart';
import '../product_detail_screen.dart';
import 'dart:ui'; // Import this for Color class
import 'package:glitzy/modals/Category_modal.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
class CatalogProductScreen extends StatefulWidget {


  const CatalogProductScreen({Key? key}) : super(key: key);

  @override
  _CatalogProductScreenState createState() => _CatalogProductScreenState();
}

class _CatalogProductScreenState extends State<CatalogProductScreen> {
  bool isLoading = true;
  List<CatalogProduct> catalogProductsList = [];
  List<Categorylistmodal> _categorys = [];
  // Define variables to store the price range


  @override
  void initState() {
    super.initState();
    _getProducts();
    _categoryAPI();

  }

  _getProducts() async {
    String url =  ApiUrl.products;
    print(url);
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productList = responseData['products'];

      if (productList.length <= 0) {
        _showSnackbar('Product detail not available');
      } else {
        setState(() {
          catalogProductsList.clear();
          for (var productData in productList) {
            catalogProductsList.add(CatalogProduct.fromJson(productData));
          }
        });
      }
    } else {
      print('Contact admin');
    }
  }
  _categoryAPI() async {
    String url =  ApiUrl.categories;
    print(url);
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },


    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productList = responseData['products'];
      print(responseData);
      if (productList.length <= 0) {
        _showSnackbar('Product detail not available');
      } else {
        setState(() {
          _categorys = productList.map((data) => Categorylistmodal.fromJson(data)).toList();
          print(_categorys![0].names);
        });
      }



    } else {
      print('Contact admin');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: kSecondaryColor.withOpacity(0.1),
          height: MediaQuery.of(context).size.height,
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              BackWidget(title: ' Products'),
              SizedBox(height: 10,),
              isLoading ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center (
                  child: CircularProgressIndicator(),
                ),
              ) :

              productWidget(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }


  Widget productWidget() {
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          CatalogProduct product = catalogProductsList![index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Productdetail(
                    productId: product.productId.toString(),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                border: Border.all(color: Colors.black.withOpacity(0.5)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: product.photo != null
                            ? Image.network(
                          product.photo!,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.productName.toString()}',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        if (product.onsale_price != null && product.onsale_price != product.price) ...[
                          Text(
                            '\$${product.price}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${product.onsale_price}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Text(
                          //   'Save ${(100 - (double.parse(product.onsale_price as String) / double.parse(product.price as String)) * 100).toStringAsFixed(0)}%',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     fontStyle: FontStyle.italic,
                          //     color: Colors.green,
                          //   ),
                          // ),
                        ],

                        SizedBox(height: 4),
                        Text(
                          '\$${product.price ?? 0}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: catalogProductsList!.length,
      ),
    );
  }







}