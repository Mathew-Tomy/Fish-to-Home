import 'dart:convert';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Addressbook_modal.dart';
import 'package:fishtohome/modals/Cart_modal.dart';
import 'package:fishtohome/modals/Payment_Method_modal.dart';
import 'package:fishtohome/modals/Payment_Account_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fishtohome/screens/checkout/stripe_Payment.dart';
 // No prefix needed if there's no conflict with other imports
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard_screen.dart';

import 'package:fishtohome/widgets/footer_widget.dart';
import 'package:fishtohome/screens/checkout/stripe_service.dart';

class Ordercheckout extends StatefulWidget {

  const Ordercheckout({Key? key, this.productsCart, this.selectedAddress,required this.selectedMethod,  required this.totalAmount,  required this.secretKey,
  required this.publicKey,}) : super(key: key);
  final  List<Products> ?productsCart;
  final AddressData ?selectedAddress;
  final String selectedMethod; // Add selectedMethod here
  final String totalAmount;
  final String secretKey;
  final String publicKey;


  @override
  _OrdercheckoutState createState() => _OrdercheckoutState();
}

class _OrdercheckoutState extends State<Ordercheckout> {


  bool isLoadingButton = false;
  List productIds = [];
  // List product_option_value_id = [];
  List product_quantity = [];

  String ?products;

  String ?quantity;
  bool isLoading = true;
  bool isHomeDelivery = false; // Track Home Delivery selection
  double deliveryCharge = 7.0; // Delivery charge for Home Delivery
  double updatedTotalAmount = 0.0; // Updated total amount with delivery charge

  List<PaymentMethods>? paymentMethods = [];
  PaymentMethods ?selectedMethod;
  List<PaymentAccounts>? paymentAccounts = [];
  PaymentAccounts  ?selectedAccounts;


  // get totalAmount => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _getPayment();
    updatedTotalAmount = double.parse(widget.totalAmount); // Initialize with original total amount
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Checkout Order',
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Shipping Address',
                style: TextStyle(fontSize: 17, color: CustomColor.accentColor, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            createAddressCard(),
            SizedBox(height: 10),
            createCartList(),

            SizedBox(height: 15),
            buildHomeDeliveryOption(), // Add Home Delivery radio button
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 17, color: CustomColor.accentColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${updatedTotalAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 17, color: CustomColor.accentColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            _proceedButton(),
          ],
        ),
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  Widget buildHomeDeliveryOption() {
    return Column(
      children: [
        ListTile(
          title: Text('Home Delivery (Additional \$7)'),
          leading: Radio<bool>(
            value: true,
            groupValue: isHomeDelivery,
            onChanged: (bool? value) {
              setState(() {
                isHomeDelivery = value!;
                if (isHomeDelivery) {
                  updatedTotalAmount = double.parse(widget.totalAmount) + deliveryCharge;
                } else {
                  updatedTotalAmount = double.parse(widget.totalAmount);
                }
              });
            },
          ),
        ),
        ListTile(
          title: Text('No Home Delivery'),
          leading: Radio<bool>(
            value: false,
            groupValue: isHomeDelivery,
            onChanged: (bool? value) {
              setState(() {
                isHomeDelivery = value!;
                if (!isHomeDelivery) {
                  updatedTotalAmount = double.parse(widget.totalAmount);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget createAddressCard() {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              Text(
                "${widget.selectedAddress!.firstname!.toUpperCase()} ${widget.selectedAddress!.lastname!.toUpperCase()}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              createAddressText(widget.selectedAddress!.customer_address_1.toString(), 6),
              createAddressText(widget.selectedAddress!.customer_address_2.toString(), 6),
              createAddressText(widget.selectedAddress!.city.toString() + ',' + widget.selectedAddress!.zip.toString(), 6),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.selectedAddress!.state.toString() + ',' + widget.selectedAddress!.country.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),

                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }
  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        Products products = widget.productsCart![position];
        return createCartListItem(products);
      },
      itemCount: widget.productsCart!.length,
    );
  }

  createCartListItem(item) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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


                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget _proceedButton() {
    return isLoadingButton
        ? Center(
      child: CircularProgressIndicator(),
    )
        : GestureDetector(
      child: Container(
        height: 45,
        width: 75,
        decoration: BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Place Order',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
      onTap: () async {
        for (var i = 0; i < widget.productsCart!.length; i++) {
          product_quantity.add(widget.productsCart![i].quantity);
        }
        quantity = product_quantity.join(",");

        if (widget.selectedMethod == 'Stripe') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StripeCheckout(
                totalAmount: updatedTotalAmount.toStringAsFixed(2),
                secretKey: widget.secretKey,
                publicKey: widget.publicKey,
                isHomeDelivery: isHomeDelivery, // Pass Home Delivery selection
              ),
            ),
          );
        }
      },
    );
  }



}



