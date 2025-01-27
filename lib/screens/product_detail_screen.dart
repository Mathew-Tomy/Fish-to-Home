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
import 'package:glitzy/screens/products_moredetail_screen.dart';
import 'package:glitzy/screens/top_rounded_container.dart';
class Productdetail extends StatefulWidget {


  const Productdetail({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  _ProductdetailState createState() => _ProductdetailState();
}

class _ProductdetailState extends State<Productdetail> {

  bool isLoading = true;
  List<Productsmodal> ?products = [];

  int? optionId; // Declare optionId as an int
  int quantity = 1;
  bool wishlisted = false;




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
    setState(() {
      isLoading = true;
    });
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
  // Function to extract plain text from HTML
  String removeHtmlTags(String htmlText) {
    var document = parse(htmlText);
    return parse(document.body!.text).documentElement!.text;
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text(
          'Product detail',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: wishlisted
                          ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                          : Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _addWishlist();
                        setState(() {
                          wishlisted = !wishlisted;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                // Product Image
                Image.network(
                  products![0].imageThumb.toString(),
                  fit: BoxFit.cover,
                  height: 185,
                  width: 255,
                ),

                // Product Name and Price
                ListTile(
                  title: Text(
                    products![0].productName.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Price and OnSale Price
                      Row(
                        children: [
                          // Original Price with Strikethrough
                          if (products![0].onsalePrice != null && products![0].onsalePrice != products![0].price)
                            Text(
                              '\$${products![0].price?.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough, // Strike-through original price
                              ),
                            ),
                          SizedBox(width: 8), // Space between original and sale price
                          // On Sale Price
                          if (products![0].onsalePrice != null && products![0].onsalePrice != products![0].price)
                            Text(
                              '\$${products![0].onsalePrice?.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green, // Sale price in green
                              ),
                            ),
                          // If no sale price, just show the regular price
                          if (products![0].onsalePrice == null || products![0].onsalePrice == products![0].price)
                            Text(
                              '\$${products![0].price?.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                      // Label for significant reduction if available
                      if (products![0].onsalePrice != null && products![0].onsalePrice != products![0].price)
                        Text(
                          'Discount!',
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.green),
                        ),
                    ],
                  ),
                ),

                // Product Code (Category Name)
                ListTile(
                  title: Text(
                    'Model:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    products![0].productModel.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                // Product Description
                ListTile(
                  title: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  subtitle: Text(
                    removeHtmlTags(products![0].productDetails.toString(),), // Remove HTML tags
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                // See More Details Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Productmoredetail(
                          productId: products![0].productId.toString(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "See More Detail",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),





        SizedBox(height: 15),
                _addingWidget(),

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


  Widget _addingWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: CustomColor.secondaryColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Minimum quantity is 1',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    });
                  },
                ),
                SizedBox(width: 10 * 2),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    color: CustomColor.accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10 * 2),
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: CustomColor.secondaryColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(width: 30), // Add some space between the two sections
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: products![0].stock == "In Stock" ? () => _addCart() : null, // Disable button if no stock
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: products![0].stock == "In Stock" ? CustomColor.primaryColor : Colors.grey, // Change color for no stock
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    products![0].stock == "In Stock" ? 'Add to cart' : 'Out of Stock',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  _addCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString(
        'customer_id'); // Get customer_id as a string
    // Only proceed if a valid userId exists
    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      return;
    }
    if (widget.productId == null || quantity <= 0) {
      showSnackbar('Invalid product or quantity');
      return;
    }


    String url = ApiUrl.addtocart;
    Response response = await post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        'product_id': widget.productId,
        'quantity': quantity.toString(),
        'customer_id': customerId.toString(),
      }),

    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData); // Print the response to debug

      if (responseData['status'] == true) {
        // Handle successful cart addition
        showSnackbar(responseData['message']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Cart()),
        );
      } else {
        // Handle errors in response
        showSnackbar(responseData['message']);
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
      showSnackbar('No products in cart');
    }
  }

    //wishlist
  _addWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id'); // Get customer_id as a string

    // Only proceed if a valid userId exists
    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      return;
    }

    if (widget.productId == null) {
      showSnackbar('Invalid product');
      return;
    }

    String url = ApiUrl.wishlist;

    // Sending the POST request with JSON data
    Response response = await post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        'product_id': widget.productId,
        'customer_id': customerId.toString(), // Ensure the user ID is a string
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      // Check the response data to determine success
      if (responseData['status'] == true) {
        showSnackbar('Product added to wishlist');
      } else {
        showSnackbar('Failed to add product to wishlist');
      }
    } else {
      showSnackbar('Product not added to wishlist');
      setState(() {
        wishlisted = !wishlisted;
      });
      print('HTTP Error: ${response.statusCode}');
    }
  }





}

