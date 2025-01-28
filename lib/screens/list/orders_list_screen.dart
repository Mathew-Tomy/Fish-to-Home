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
    _getOrders();
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
                  SizedBox(height: 8),
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(orders[index].status.toString()), // Access status from individual Orders object
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          orders[index].status.toString(), // Access status from individual Orders object
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


}