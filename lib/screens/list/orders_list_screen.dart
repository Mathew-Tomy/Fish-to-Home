import 'dart:convert';

import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Order_list_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/screens/order_summary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import 'package:intl/intl.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
// import 'package:fishtohome/config/theme.dart';
class Ordrslist extends StatefulWidget {
  const Ordrslist({Key? key}) : super(key: key);

  @override
  _OrdrslistState createState() => _OrdrslistState();
}

class _OrdrslistState extends State<Ordrslist> {
  bool isLoading = true;
  List<Orders> orders = [];

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
      _getOrders();  // If logged in, fetch the order
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
      content: Text('You must log in to view your order.', style: TextStyle(fontSize: 13, color: Colors.black)),
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
  _getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? customerId = prefs.getString('customer_id'); // Get customer_id as a string

    // Only proceed if a valid userId exists
    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      return;
    }

    String url = ApiUrl.orderList + '/$customerId';

    try {
      // Start fetching orders without immediately setting loading
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ensure the response contains the status and orders
        if (responseData['status'] == true && responseData['orders'] != null) {
          List<dynamic> order = responseData['orders'];

          if (order.isEmpty) {
            // No orders found
            showSnackbar('No orders found');
          } else {
            setState(() {
              orders = order.map((data) => Orders.fromJson(data)).toList();
            });
          }
        } else {
          showSnackbar('No orders found');
        }
      } else {
        print('Failed to fetch orders. HTTP Status Code: ${response.statusCode}');
        showSnackbar('No Order Found.');
      }
    } catch (error) {
      print('Error fetching orders: $error');
      showSnackbar('An error occurred while fetching orders.');
    } finally {
      // Ensure loading is stopped after processing
      setState(() {
        isLoading = false;
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
  String formattedDate(String dateString) {
    try {
      // Parse the date with the custom format
      DateTime date = DateFormat('MM-dd-yyyy').parse(dateString);

      // Return the date in the desired format
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      print('Error parsing date: $e');
      return dateString; // Return the original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Orders',style: TextStyle(color:CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : orders !.length > 0 ?   orderWidget() : emptyWidgetOrder(),

      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }
  Widget emptyWidgetOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: CustomColor.accentColor),
          SizedBox(height: 16),
          Text(
            'No Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: CustomColor.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  //
  Widget orderWidget() {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return GestureDetector(

          child: Card(
            elevation: 6,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order date: ${formattedDate(orders[index].order_date!)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Order ID: ${formattedDate(orders[index].orderId!)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Customer Name: ${orders[index].customer_name!}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                   Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: orders[index].status != null ? _getStatusColor(orders[index].status!) : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      orders[index].status!= null ? _getStatusText(orders[index].status!) : 'N/A',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount: ${orders[index].total}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Order Price: ${orders[index].total}',
                        style: TextStyle(fontSize: 14),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            if (orders[index] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ordersummary(orderId: orders[index].orderId.toString()),
                ),
              );
            } else {
              // Handle the case where orders[index] is null
              // You can show an error message or handle it in another appropriate way
              print('Order at index $index is null.');
            }
          },
        );
      },
    );
  }
  String _getStatusText(String? status) {
    switch (status) {
      case '1':
        return 'Pending';
      case '2':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '1':  // Status '1' means 'Pending'
        return Colors.orange;
      case '2':  // Status '2' means 'Delivered'
        return Colors.green;
      case '3':  // Adding a possible 'Cancelled' status
        return Colors.red;
      default:
        return Colors.grey;
    }
  }



}
