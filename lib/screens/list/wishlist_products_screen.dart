import 'dart:convert';

import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Wishlist_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
import '../product_detail_screen.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

  bool isLoading = true;
  List<Products> products= [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginAndFetchCart();
  }
// Check if user is logged in, if not, show login alert
  void _checkLoginAndFetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      _showLoginAlert();  // Show login alert if not logged in
    } else {
      _getWishlist(); // If logged in, fetch the wishlist
    }
  }

  // Show login alert if the user is not logged in
  void _showLoginAlert() {
    // Set up the buttons
    Widget cancelButton = TextButton(
      child: Text('Cancel', style: TextStyle(color: Colors.red)),
      onPressed: () {
        Navigator.pop(context);  // Close the alert dialog
        Navigator.pushNamed(context, '/dashboard');  // Navigate to login screen
      },
    );
    Widget loginButton = TextButton(
      child: Text('Login', style: TextStyle(color: Colors.green)),
      onPressed: () {
        Navigator.pop(context);  // Close the dialog and navigate to the login screen
        Navigator.pushNamed(context, '/loginscreen');  // Navigate to login screen
      },
    );

    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Login Required', style: TextStyle(fontSize: 18)),
      content: Text('You must log in to view your wishlists.', style: TextStyle(fontSize: 13, color: Colors.black)),
      actions: [
        cancelButton,
        loginButton,
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  _getWishlist() async {
    setState(() {
      isLoading = true; // Start loading
      products = []; // Clear any existing wishlist data
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false; // Stop loading if no customer ID
      });
      return;
    }

    String url = '${ApiUrl.wishlistProducts}/$customerId'; // Construct the API URL
    try {
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true && responseData.containsKey('products')) {
          List<dynamic> fav = responseData['products'] ?? [];

          if (fav.isNotEmpty) {
            setState(() {
              products = fav.map((item) {
                return Products.fromJson(Map<String, dynamic>.from(item));
              }).toList();
              isLoading = false; // Stop loading after successful fetch
            });
          } else {
            setState(() {
              isLoading = false; // Stop loading when wishlist is empty
            });
            showSnackbar('No products in wishlist');
          }
        } else {
          setState(() {
            isLoading = false; // Stop loading if response is invalid
          });
          showSnackbar(responseData['message'] ?? 'Failed to fetch wishlist data');
        }
      } else {
        print('Error: ${response.statusCode}, Body: ${response.body}');
        setState(() {
          isLoading = false; // Stop loading on HTTP error
        });
        showSnackbar('Wishlist is Empty');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false; // Stop loading on network error
      });
      showSnackbar('An error occurred. Please try again.');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Wishlist',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      // body: isLoading ? Center(
      //   child: CircularProgressIndicator(),
      // ) : _wishlistWidget(),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :products !.length > 0 ?   _wishlistWidget() :  emptyWidgetWishlist(context),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }
  Widget emptyWidgetWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add an illustration or icon for the empty wishlist
          Icon(
            Icons.favorite_border,
            size: 100,
            color: CustomColor.accentColor,
          ),
          SizedBox(height: 16),
          // Main message
          Text(
            'Your Wishlist is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: CustomColor.accentColor,
            ),
          ),
          SizedBox(height: 8),
          // Subtitle message
          Text(
            'Save your favorite items to your wishlist.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24),
          // "Browse Products" button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard'); // Redirect to product page
            },
            icon: Icon(Icons.shopping_bag_outlined),
            label: Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: CustomColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _wishlistWidget(){
    return ListView(
      children: [
        createWishlist(),
      ],
    );
  }

  createWishlist() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        Products wishlist = products[position];
        return createwishListItem(wishlist);
      },
      itemCount: products.length,
    );
  }

  createwishListItem(item) {
    return GestureDetector(
      onTap: () => {
      Navigator.push(context, MaterialPageRoute(
      builder: (context) => Productdetail(productId: item.productId.toString(), ),),)
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.blue.shade200,
                      image: DecorationImage(
                          image: NetworkImage(item.photo.toString())
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            item.productName.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style:TextStyle(fontSize: 14),
                          ),
                        ),


                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.onsalePrice != null && item.onsalePrice > 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price : \$${double.tryParse(item.price.toString())?.toStringAsFixed(2) ?? '0.00'}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough, // Strike-through original price
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Sale Price : \$${double.tryParse(item.onsalePrice.toString())?.toStringAsFixed(2) ?? '0.00'}',
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  'Price : \$${double.tryParse(item.price.toString())?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 100,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10, top: 8),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.redAccent),
              ),
              onTap: () => {
                _confirmDelete(context, item.productId.toString(),item.productName.toString(),)
              },
            ),
          )
        ],
      ),
    );
  }

  void _confirmDelete(context,String productId,String productName) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('No', style: TextStyle(color: Colors.green)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text('Yes', style: TextStyle(color:  Colors.green)),
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        _removeFromwishlist(productId);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Confirm', style: TextStyle(fontSize: 18),),
      content: Text('Do you want to remove $productName from wishlist ?', style: TextStyle(fontSize: 13, color:Colors.black)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _removeFromwishlist(String productId) async {
    Navigator.pop(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false; // Reset loading state
      });
      return;
    }
    String url =  ApiUrl.wishlistremove;
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'product_id': productId,
          'customer_id': customerId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          showSnackbar(responseData['message'] ??
              'Product removed from Wishlist successfully');
          // Fetch updated wishlist after successful removal
          await _getWishlist();
        } else {
          showSnackbar(responseData['message'] ?? 'Product removal failed');
        }
      } else {
        print('HTTP Error: ${response.statusCode}, Body: ${response.body}');
        showSnackbar('Failed to remove product. Contact admin.');
      }
    } catch (error) {
      print('Error: $error');
      showSnackbar('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false; // Stop loading in all cases
      });
    }
  }

}
