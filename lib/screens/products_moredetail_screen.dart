import 'dart:convert';
import '../../../constants.dart';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Productdetail_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart'; // Import HTML parser
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:glitzy/screens/list/category_product_list.dart';
import 'package:glitzy/screens/list/subcategory_product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/widgets/footer_widget.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'list/cart_list_screen.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:glitzy/screens/top_rounded_container.dart';
class Productmoredetail extends StatefulWidget {


  const Productmoredetail({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  _ProductdetailState createState() => _ProductdetailState();
}

class _ProductdetailState extends State<Productmoredetail> {

  bool isLoading = true;
  List<Productsmodal> ?products = [];





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.productId);
    _getProduct();
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

  _getProduct() async{
    String url =  ApiUrl.productdetail + '/${widget.productId}';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Check if the status is true and products exist
        if (responseData['status'] == true && responseData['products'] != null) {
          List<dynamic> productslist = responseData['products'];
          setState(() {
            isLoading = false;
            products = productslist
                .map((productData) => Productsmodal.fromJson(productData))
                .toList();
          });
        } else {
          print('No products found or status is false.');
        }
      } else {
        print('Failed to fetch products. HTTP Status Code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or parsing errors
      print('Error fetching products: $error');
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text(
          'More Detail',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: [
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                // Product image
                Image.network(
                  products![0].imageThumb.toString(),
                  fit: BoxFit.cover,
                  height: 135,
                  width: 255,
                ),
                // Product Name & Price Section
                ListTile(
                  title: Text(
                    products![0].productName.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      children: [
                        if (products![0].onsalePrice != null && products![0].onsalePrice != products![0].price)
                          TextSpan(
                            text: 'Price: \$${products![0].onsalePrice?.toStringAsFixed(2)} ',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red),
                          ),
                        if (products![0].onsalePrice != null && products![0].onsalePrice != products![0].price)
                          TextSpan(
                            text: '\$${products![0].price?.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey, decoration: TextDecoration.lineThrough),
                          ),
                        if (products![0].onsalePrice == null || products![0].onsalePrice == products![0].price)
                          TextSpan(
                            text: 'Price: \$${products![0].price?.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                      ],
                    ),
                  ),
                ),
                // Available info
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        'Available',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            products![0].productModel.toString(),
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Categories and Subcategories
                ListTile(
                  title: Text(
                    'Categories:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    products![0].categoryName.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProduct(
                          categoryId: products![0].categoryId.toString(),
                          categoryName: products![0].categoryName.toString(),
                        ),
                      ),
                    );
                  },
                ),

                // Product Details (Rendering HTML Content)
                ListTile(
                  title: Text(
                    'Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Html(
                    data: products![0].specification.toString(),
                    style: {
                      'body': Style(fontSize: FontSize(15.0)), // Adjust the font size as needed
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }
}








