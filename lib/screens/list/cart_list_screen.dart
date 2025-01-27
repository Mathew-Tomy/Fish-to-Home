import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Cart_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/screens/checkout/address_select.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';


import '../product_detail_screen.dart';


class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}



class _CartState extends State<Cart> {

  bool isLoading = true;
  List<Products> ?productsCart = [];
  double cartTotal = 0;
  double getTotalSum() {
    double totalSum = 0.0;
    if (productsCart != null) {
      for (Products product in productsCart!) {
        totalSum += double.parse(product.total ?? '0');
      }
    }
    return totalSum;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCart();
  }




  _getCart() async {
    setState(() {
      isLoading = true; // Start loading
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

    String url = '${ApiUrl.cartProducts}/$customerId'; // API URL with customer ID
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
          List<dynamic> cart = responseData['products'] ?? [];

          if (cart.isNotEmpty) {
            setState(() {
              productsCart = cart.map((item) {
                return Products.fromJson(Map<String, dynamic>.from(item));
              }).toList();

              cartTotal = (productsCart ?? []).fold(
                0.0,
                    (sum, item) => sum + (double.tryParse(item.total ?? '0') ?? 0.0),
              );

              isLoading = false; // Stop loading
            });
          } else {
            setState(() {
              productsCart = []; // Empty cart list
              cartTotal = 0.0; // Reset cart total
              isLoading = false; // Stop loading
            });
            showSnackbar('No products in cart');
          }
        } else {
          setState(() {
            isLoading = false; // Stop loading on invalid response
          });
          showSnackbar(responseData['message'] ?? 'Failed to fetch cart data');
        }
      } else {
        print('Error: ${response.statusCode}, Body: ${response.body}');
        setState(() {
          isLoading = false; // Stop loading on HTTP error
        });
        showSnackbar('cart is empty');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false; // Stop loading on network error
      });
      showSnackbar('An error occurred. Please try again.');
    }
  }


  _updateCart(String product_id, String quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false; // Reset loading state
      });
      return;
    }

    String url = ApiUrl.cartedit;
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'product_id': product_id,
          'customer_id': customerId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          showSnackbar(responseData['message'] ?? 'Cart updated successfully');

          // Refresh the cart to show updated data
          await _getCart();
        } else {
          showSnackbar(responseData['message'] ?? 'Failed to update cart');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showSnackbar('Failed to update cart. Try again later.');
      }
    } catch (error) {
      print('Error: $error');
      showSnackbar('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state in all cases
      });
    }
  }


  _reduceupdateCart(String product_id, String quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false; // Reset loading state
      });
      return;
    }

    String url = ApiUrl.cartreduce;

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'product_id': product_id,
          'quantity': quantity,
          'customer_id': customerId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        if (responseData['status'] == true) {
          showSnackbar(responseData['message'] ?? 'Cart updated successfully');

          // Fetch the updated cart data to refresh the UI
          await _getCart();
        } else {
          showSnackbar(responseData['message'] ?? 'Failed to update cart');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showSnackbar('Failed to update cart. Try again later.');
      }
    } catch (error) {
      print('Error: $error');
      showSnackbar('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state in all cases
      });
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

        title: ListTile(title: Text('Shopping cart',style: TextStyle(color: Colors.black),),
          subtitle: productsCart!.length > 0  ? Text(
            "Total(${productsCart!.length}) Items",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ) : Text('')
          ,),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: CustomColor.accentColor,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/dashboard");

            },
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :productsCart!.length > 0 ? cartWidget() : emptyWidgetCart(context),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  Widget emptyWidgetCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add an illustration or icon for the empty cart
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: CustomColor.accentColor,
          ),
          SizedBox(height: 16),
          // Main message
          Text(
            'Your shopping cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: CustomColor.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          // Subtitle message
          Text(
            'Browse our products and add items to your cart.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24),
          // "Shop Now" button to redirect to the product page
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard'); // Redirect to your product page
            },
            icon: Icon(Icons.shopping_bag_outlined),
            label: Text('Shop Now'),
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


  cartWidget() {
    return ListView(
      children: [
        createCartList(),
        SizedBox(height: 15,),
        footer(context),


      ],
    );
  }



  footer(BuildContext context) {
    double totalSum = getTotalSum(); // Call your getTotalSum method here
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total Amount",
                  style: TextStyle(color: Colors.grey, fontSize: 15,fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  'Total: \$${totalSum.toStringAsFixed(2)}', // Format total as currency
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutAddress(
                    productsCart: productsCart,
                    totalAmount: totalSum.toStringAsFixed(2),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CustomColor.accentColor), // Set background color here
              padding: MaterialStateProperty.all(EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              )),
            ),
            child: Text(
              "Checkout",
              style: TextStyle(color: Colors.white),
            ),
          ),

          //Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }


  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        Products products = productsCart![position];
        return createCartListItem(products);
      },
      itemCount: productsCart!.length,
    );
  }

  createCartListItem(item) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Productdetail(productId: item.product_id.toString(), ),),)
          },
          child: Container(
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
                            item.product_name.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style:TextStyle(fontSize: 14),
                          ),

                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            item.product_model.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style:TextStyle(fontSize: 14),
                          ),

                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Regular Price or On-Sale Price
                            if (item.onsale_price != null && item.onsale_price != item.price) ...[
                              // Original Price with Strikethrough
                              Text(
                                '\$${item.price.toString()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough, // Strike-through for original price
                                ),
                              ),
                              SizedBox(height: 4), // Small gap between the prices
                              // Sale Price
                              Text(
                                '\$${item.onsale_price.toString()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green, // Sale price in green
                                ),
                              ),
                              // Optional Discount Label
                              Text(
                                'Discount!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green,
                                ),
                              ),
                            ] else ...[
                              // Regular Price (when no sale)
                              Text(
                                '\$${item.price.toString()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ],
                        ),

                        // Text(
                        //  ' Price : ${item.price.toString()}',
                        //   style: TextStyle(color: Colors.grey, fontSize: 14),
                        // ),

                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Text(
                              //   'Product Price : ${item.price.toString()}',
                              //   style: TextStyle(color: Colors.green),
                              // ),
                              Text(
                                'Total Price : ${item.total.toString()}',
                                style: TextStyle(color: Colors.green),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Icon(
                                        Icons.remove,
                                        size: 24,
                                        color: Colors.grey.shade700,
                                      ),
                                      onTap: () => {
                                        cartCalculationReduce(item.product_id.toString(), item.quantity.toString(), item.product_name.toString())
                                      },
                                    ),
                                    Container(
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 12, left: 12),
                                      child: Text(
                                        item.quantity.toString(),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.add,
                                        size: 24,
                                        color: Colors.grey.shade700,
                                      ),
                                      onTap: () => {
                                        cartCalculationAdd(item.product_id.toString(), item.quantity.toString(), item.product_name.toString())
                                      },
                                    )
                                  ],
                                ),
                              )
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
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: CustomColor.accentColor),
            ),
            onTap: () => {
              _confirmDelete(context, item.product_id.toString(),item.product_name.toString(),)
            },
          ),
        )
      ],
    );
  }

  cartCalculationAdd(String product_id, String quantity, String product_name) {
    print(quantity);
    int qty = int.parse(quantity);
    qty = qty + 1;

    setState(() {
      isLoading = true; // Show loading indicator
    });

    _updateCart(product_id, qty.toString()).then((_) {
      // Reset loading state and update UI only after the update completes
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      // Handle errors gracefully
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    });
  }



  cartCalculationReduce(String product_id, String quantity, String product_name) {
    print(quantity);
    int qty = int.parse(quantity);

    if (qty == 1) {
      // Confirm deletion if quantity is 1
      _confirmDelete(context, product_id, product_name);
    } else {
      // Reduce quantity if greater than 1
      qty = qty - 1;

      setState(() {
        isLoading = true;
      });

      _reduceupdateCart(product_id, qty.toString()).then((_) {
        setState(() {
          isLoading = false; // Reset loading state
        });
      }).catchError((error) {
        print('Error: $error');
        setState(() {
          isLoading = false; // Ensure loading state is reset on error
        });
      });
    }
  }


  void _confirmDelete(context,String product_id,String product_name) {
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
        _removeFromCart(product_id);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Confirm', style: TextStyle(fontSize: 18),),
      content: Text('Do you want to remove $product_name from cart ?', style: TextStyle(fontSize: 13, color:Colors.black)),
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


  _removeFromCart(String product_id) async {
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
    String url = ApiUrl.cartdelete;

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'product_id': product_id,

          'customer_id': customerId.toString(),
        }),

      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          showSnackbar(responseData['message'] ?? 'Product removed from cart successfully');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Cart()), // Refresh cart page
          );
        } else {
          showSnackbar(responseData['message'] ?? 'Failed to remove product from cart');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showSnackbar('Failed to remove product from cart. Try again later.');
      }
    } catch (error) {
      print('Error: $error');
      showSnackbar('An error occurred. Please try again.');
    }
  }


}

