import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../../../constants.dart';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/SubCategory_product_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';


import '../product_detail_screen.dart';

class SubCategoryProduct extends StatefulWidget {

  const SubCategoryProduct({Key? key, required this.subcategoryName, required this.subcategoryId}) : super(key: key);
  final String subcategoryName;
  final String subcategoryId;

  @override
  _SubCategoryProductState createState() => _SubCategoryProductState();
}

class _SubCategoryProductState extends State<SubCategoryProduct> {

  bool isLoading = true;
  List<Products> ?productsCategory = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child:  ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            BackWidget( title: '${widget.subcategoryName} Products'),
            SizedBox(height: 10,),
            isLoading ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center (
                child: CircularProgressIndicator(),
              ),
            ) : productWidget(),
            // Footerwidget(),
          ],
        ),
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }
  // _getProducts() async {
  //   String url =  ApiUrl.subcategoriesById + widget.subcategoryId;
  //   print(url);
  //   Response response = await get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     final List<dynamic> productList = responseData['products'];
  //
  //     if (productList.length <= 0) {
  //       _showSnackbar('Product detail not available');
  //     } else {
  //       setState(() {
  //         // Clear the existing productsCategory list
  //         productsCategory!.clear();
  //
  //         // Parse each product and add it to the productsCategory list
  //         for (var productData in productList) {
  //           productsCategory!.add(Products.fromJson(productData));
  //         }
  //         print(productsCategory![0].name);
  //       });
  //     }
  //   } else {
  //     print('Contact admin');
  //   }
  // }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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




