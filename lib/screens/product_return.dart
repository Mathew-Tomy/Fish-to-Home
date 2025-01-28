import 'dart:convert';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
class Productreturn extends StatefulWidget {
  const Productreturn({Key? key, required this.productId, required this.orderId, required this.orderProductId, required this.quantity, required this.optionId,required this.product}) : super(key: key);
  final String productId;
  final String orderId;
  final String orderProductId;
  final String quantity;
  final String optionId;
  final String product;


  @override
  _ProductreturnState createState() => _ProductreturnState();
}

var border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(width: 1, color: Colors.grey));

class _ProductreturnState extends State<Productreturn> {




  // List<ReturnReasons> returnReasons =[];
  bool isLoading = true;

  String quantity = '';
  String? reasonForReturn;


  bool isLoadingButton = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getReasons();
    quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Return product',
          style: TextStyle(color: CustomColor.accentColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: CustomColor.accentColor),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              'Product Information',
              style: TextStyle(
                fontSize: 17,
                color: CustomColor.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              child: TextFormField(
                readOnly: true,
                initialValue: widget.product,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  labelText: "Product",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              margin: EdgeInsets.only(left: 5, right: 5, top: 20),
            ),
            Container(
              child: TextFormField(
                initialValue: widget.quantity,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  labelText: "Quantity",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onSaved: (value) {
                  quantity = value ?? '';
                },
              ),
              margin: EdgeInsets.only(left: 5, right: 5, top: 20),
            ),
            SizedBox(height: 15),
            Container(
              child: TextFormField(
                initialValue: reasonForReturn,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  labelText: "Return Reason",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    reasonForReturn = value;
                  });
                },
              ),
              margin: EdgeInsets.only(left: 5, right: 5, top: 20),
            ),
            SizedBox(height: 25),
            continueWidget(context),
          ],
        ),
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }
  continueWidget(BuildContext context) {
    return Center(
      child: isLoadingButton ? Center(
        child: CircularProgressIndicator(),
      ) :  ElevatedButton(
        child: const Text('Return product'),
        onPressed: () {

          setState(() {
            isLoadingButton = true;
          });
         // _returnProduct();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.accentColor, // background
          // foreground
        ),
      ),
    );
  }


  // _returnProduct() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
  //   String url = ApiUrl.returnAPI;
  //   print(url);
  //
  //   try {
  //     Response response = await post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body: {
  //         //'order_id': widget.orderId,
  //         //'product_id': widget.product,
  //         //  'customer_id': userId.toString(),
  //         'order_product_id': widget.orderProductId,
  //         // 'return_reason': reasonForReturn.toString(),
  //         'return_reason': reasonForReturn ?? '', // Use null check operator
  //         'quantity': quantity.toString(),
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       //String responseData = response.body;
  //       print(responseData);
  //       if (responseData['success'] == true) {
  //         setState(() {
  //           isLoadingButton = false;
  //         });
  //         _showMyDialog(responseData['message']);
  //       } else {
  //         print('Error: ${responseData['message']}');
  //       }
  //     } else {
  //       print('Error: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error decoding response: $e');
  //     // Handle the error appropriately (e.g., display an error message)
  //   }
  // }

  Future<void> _showMyDialog(msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Dashboard()), (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
