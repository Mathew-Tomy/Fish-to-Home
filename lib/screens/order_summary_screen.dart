import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/order_detail_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:glitzy/screens/product_detail_screen.dart';
import 'package:glitzy/screens/product_return.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/widgets/footer_widget.dart';

class Ordersummary extends StatefulWidget {


  const Ordersummary({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  _OrdersummaryState createState() => _OrdersummaryState();
}

class _OrdersummaryState extends State<Ordersummary> {

  bool isLoading = true;
  List<Product> products = [];
  Order order = Order();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrderSummary();
  }
  _products() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // Product Table
          Table(
            columnWidths: {
              0: FlexColumnWidth(2), // Product Name
              1: FlexColumnWidth(2), // Model
              2: FlexColumnWidth(1), // Quantity
              3: FlexColumnWidth(1), // Price
              4: FlexColumnWidth(1), // Total
            },
            children: [
              TableRow(
                children: [
                  _tableHeader('Product Name'),
                  _tableHeader('Model'),
                  _tableHeader('Quantity'),
                  _tableHeader('Price'),
                  _tableHeader('Total'),
                ],
              ),
              // Display each product row
              for (var product in products)
                TableRow(
                  children: [
                    _tableCell(product.productName ?? 'N/A'),
                    _tableCell(product.productModel ?? 'N/A'),
                    _tableCell(product.quantity ?? '0'),
                    _tableCell('\$${product.price}'),
                    _tableCell('\$${product.totalPrice}'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      ),
    );
  }

// New Widget for Total Section
  _totalAmount() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sub-Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              Text('\$${order.subTotal}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: CustomColor.accentColor)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Service Charge', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              Text('\$${order.serviceAmount}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: CustomColor.accentColor)),
            ],
          ),
          SizedBox(height: 5),
          Divider(thickness: 1.5),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              Text('\$${order.totalAmount}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CustomColor.accentColor)),
            ],
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Order Summary', style: TextStyle(color: CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        children: [
          _orderIdCard(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Text('Address', style: TextStyle(fontSize: 17,
                color: Colors.grey,
                fontWeight: FontWeight.w700),),
          ),
          _address(),
          SizedBox(height: 10,),
          _products(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Divider(thickness: 1.5,),
          ),
          _totalAmount(),
          SizedBox(height: 10,),


        ],

      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  _getOrderSummary() async {
    String url = ApiUrl.orderSummary + '/${widget.orderId}';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        // Parse order data (the order object is not a list, so we access it directly)
        if (responseData.containsKey('order') && responseData['order'] is Map) {
          Map<String, dynamic> orderData = responseData['order'];
          order = Order.fromJson(orderData); // Parse order data
        } else {
          print('Order data is missing or not in the expected format');
        }

        // Parse products data (products is a list)
        if (responseData.containsKey('products') && responseData['products'] is List) {
          List<dynamic> productsData = responseData['products'];
          products.clear(); // Clear existing products list
          for (dynamic data in productsData) {
            // Ensure that each item is a map before parsing
            if (data is Map<String, dynamic>) {
              products.add(Product.fromJson(data));
            }
          }
        } else {
          print('Products data is missing or not in the expected format');
        }

      } else {
        print('Failed to load order summary: ${response.statusCode}');
        // Handle the error, show a message to the user, or retry
      }
    } catch (e) {
      print('Error fetching order summary: $e');
      // Handle the error, show a message to the user, or retry
    }
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

  sortDate(date) {
    final DateFormat formatter = DateFormat('dd-MMMM-y');
    final String formatted = formatter.format(date);
    return formatted;
  }


  _orderIdCard() {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('Order Number : ${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order date: ${formattedDate(order.orderDate!)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Payment Status: ${order.status != null ? _getStatusText(order.status) : 'N/A'}',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: order.status != null ? _getStatusColor(order.status!) : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            order.status != null ? _getStatusText(order.status!) : 'N/A',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }


// Get the status text based on order status code (1 - Pending, 2 - Delivered)
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
      case '1': // Pending
        return Colors.orange;
      case '2': // Delivered
        return Colors.green;
      case '3': // Cancelled, assuming you might use this for cancellation
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


  _address() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.customerName != null ? order.customerName!.toUpperCase() : 'N/A',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          Text(
            order.customerAddress1 != null ? '${order.customerAddress1}, ${order.customerAddress2}' : 'N/A',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          Text(
            order.customerShortAddress != null ? '${order.customerShortAddress}, ${order.zip}' : 'N/A',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          Text(
            order.customerMobile != null ? '${order.customerMobile}, ${order.customerEmail}' : 'N/A',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }




  //
  //
  //
  //
  // _paymentMethodOnline() {
  //   return ListTile(
  //     leading: Image.network(
  //       'https://glitzystudio.ca/assets/images/1601930611stripe-logo-blue.png',
  //       width: 50,
  //       height: 50,
  //     ),
  //     title: Text('Stripe'),
  //   );
  // }


}