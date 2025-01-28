import 'dart:convert';

import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Return_order_detail_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
 import 'package:intl/intl.dart';
import 'package:fishtohome/screens/product_detail_screen.dart';
import 'package:fishtohome/screens/order_summary_screen.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
class Returnsummary extends StatefulWidget {
  const Returnsummary({Key? key, required this.returnId}) : super(key: key);
  final String returnId;

  @override
  _ReturnsummaryState createState() => _ReturnsummaryState();
}

class _ReturnsummaryState extends State<Returnsummary> {
  bool isLoading = true;
  ProductsReturn? productsreturn;

  @override
  void initState() {
    super.initState();
    //_getReturnSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Return Summary', style: TextStyle(color: CustomColor.accentColor)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: CustomColor.accentColor),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: [
          _orderIdCard(),
          _products(),
          _payments(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(thickness: 1.5),
          ),
          SizedBox(height: 10.0),

        ],
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );

  }

  // _getReturnSummary() async {
  //   String url = ApiUrl.returndetail + '/${widget.returnId}';
  //   try {
  //     Response response = await get(
  //       Uri.parse(url),
  //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print(responseData);
  //
  //       if (responseData.containsKey('productsReturn') && responseData['productsReturn'] is List) {
  //         List<dynamic> returnData = responseData['productsReturn'];
  //         if (returnData.isNotEmpty) {
  //           productsreturn = ProductsReturn.fromJson(returnData[0]); // Assuming there's only one return in the list
  //         } else {
  //           print('No return data found');
  //         }
  //       } else {
  //         print('Return data is missing or not in the expected format');
  //       }
  //     } else {
  //       print('Failed to load return summary: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching return summary: $e');
  //   }
  // }

  _orderIdCard() {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('Order Transaction Number : ${productsreturn!.transactionNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(productsreturn!.dateOrdered!))}'),
            Text('Return Status: ${productsreturn!.status}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
            Text('Return Reason: ${productsreturn!.returnReason}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
            Text('Return Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(productsreturn!.createdAt!))}'),
            Text('Remmaining Price: ${productsreturn!.remainingPrice}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
            SizedBox(height: 10),
            Text('Return Quantity: ${productsreturn!.returnQty ?? 0}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(productsreturn!.status.toString()), // Access status from individual ProductsReturn object
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            productsreturn!.status.toString(), // Access status from individual ProductsReturn object
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  _payments() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            'Payment Method: ${productsreturn!.paymentMethod ?? ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Ordersummary(orderId: productsreturn!.orderId.toString()),

              ),
            );
          },
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Price: ${productsreturn!.productPrice ?? ''}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
              Text('Remaining Price: ${productsreturn!.remainingPrice?? ''}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),


            ],
          ),
        ),
      ),
    );
  }

  _products() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            'Product Name: ${productsreturn!.productName ?? ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Productdetail(productId: productsreturn!.productId.toString()),
              ),
            );
          },

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Price: ${productsreturn!.productPrice ?? ''}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
              Text('Product Color: ${productsreturn!.color ?? ''}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
              Text('Product Size: ${productsreturn!.size ?? ''}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),

            ],

          ),
        ),
      ),
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











