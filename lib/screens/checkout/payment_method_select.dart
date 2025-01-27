import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/modals/Cart_modal.dart';
import 'package:glitzy/modals/Payment_Method_modal.dart';
import 'package:glitzy/modals/Payment_Account_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'order_checkout.dart';

class Paymentselect extends StatefulWidget {
  const Paymentselect({Key? key, this.productsCart, this.selectedAddress, required this.totalAmount}) : super(key: key);

  final  List<Products> ?productsCart;
  final AddressData ?selectedAddress;
  final String totalAmount;


  @override
  _PaymentselectState createState() => _PaymentselectState();
}

class _PaymentselectState extends State<Paymentselect> {

  bool isLoading = true;
  List<PaymentMethods>? paymentMethods = [];
  List<PaymentAccounts>? paymentAccounts = [];
  PaymentMethods ?selectedMethod;
  PaymentAccounts ?selectedAccount;
  bool isLoadingButton = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPayment();
    _getPaymentAccount();
  }

  _getPayment() async {
    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      // Define the API URL
      String url = ApiUrl.paymentMethod;
      print(url);

      // Make the GET request
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        // Check if payment_methods exists and is not null
        if (responseData.containsKey('payment_methods') &&
            responseData['payment_methods'] != null) {
          List<dynamic> methods = responseData['payment_methods'];

          if (methods.isNotEmpty) {
            // Populate paymentMethods list
            setState(() {
              paymentMethods!.addAll(
                methods.map((data) => PaymentMethods.fromJson(data)),
              );
            });
          } else {
            showSnackbar('No payment methods available.');
          }
        } else {
          showSnackbar('No payment methods found in the response.');
        }
      } else {
        print('Failed to fetch payment methods. Status code: ${response.statusCode}');
        showSnackbar('Failed to fetch payment methods. Please try again.');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
      showSnackbar('An error occurred. Please try again.');
    } finally {
      // Ensure loading state is reset
      setState(() {
        isLoading = false;
      });
    }
  }

  _getPaymentAccount() async {
    setState(() {
      isLoading = true; // Set loading state
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false; // Reset loading state
      });
      return;
    }
    try {
      // Define the API URL
      String url = '${ApiUrl.paymentAccount}/$customerId';
      print(url);

      // Make the GET request
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        // Check if payment_methods exists and is not null
        if (responseData.containsKey('payment_account') &&
            responseData['payment_account'] != null) {
          List<dynamic> methods = responseData['payment_account'];

          if (methods.isNotEmpty) {
            // Populate paymentMethods list
            setState(() {
              paymentAccounts!.addAll(
                methods.map((data) => PaymentAccounts.fromJson(data)),
              );
            });
          } else {
            showSnackbar('No payment methods available.');
          }
        } else {
          showSnackbar('No payment methods found in the response.');
        }
      } else {
        print('Failed to fetch payment methods. Status code: ${response.statusCode}');
        showSnackbar('Failed to fetch payment methods. Please try again.');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
      showSnackbar('An error occurred. Please try again.');
    } finally {
      // Ensure loading state is reset
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Payment Method',style: TextStyle(color: CustomColor.accentColor),),
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
      ) : Column(
        children: [
          paymentWidget(),
          SizedBox(height: 10,),
          _proceedButton(),

        ],

      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
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

  paymentWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: paymentMethods!.length,
        itemBuilder: (context, index) {
          PaymentMethods pay = paymentMethods![index];
          return RadioListTile<PaymentMethods>(
            activeColor: CustomColor.primaryColor,
            value: pay,
            groupValue: selectedMethod,
            onChanged: (PaymentMethods ?ind) => setState(() => {
              selectedMethod = ind!,
              print(selectedMethod!.name),
            }),
            title: Text(pay.name.toString()),
          );
        });
  }

  _proceedButton() {
    return isLoadingButton
        ? Center(
      child: CircularProgressIndicator(),
    )
        : ElevatedButton(
      onPressed: () {
        if (selectedMethod == null) {
          showSnackbar('Select payment method');
        } else {
          setState(() {
            isLoadingButton = true;
          });
          _savePaymentMethodAndProceed(); // Updated function
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.accentColor,
        padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      child: Text(
        "Proceed",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

// Function to save payment method and proceed to the next page
  _savePaymentMethodAndProceed() async {


    // Get the payment account based on the customer's selected city
    // Check if the payment account has valid keys
    PaymentAccounts? selectedAccount = paymentAccounts?.isNotEmpty ?? false ? paymentAccounts!.first : null;
    if (selectedAccount == null || selectedAccount.secret_key == null || selectedAccount.public_key == null) {
      showSnackbar('No valid payment account found for this customer.');
      return;
    }

    setState(() {
      isLoadingButton = true;
    });

    // Save the selected payment method to SharedPreferences or database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('paymentMethod', selectedMethod?.name ?? '');

    // Navigate to the next page (Ordercheckout) with the selected payment method
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ordercheckout(
          productsCart: widget.productsCart,
          selectedAddress: widget.selectedAddress,
          selectedMethod: selectedMethod?.name ?? '',
          totalAmount: widget.totalAmount,
          secretKey: selectedAccount.secret_key ?? '',
          publicKey: selectedAccount.public_key ?? '',
        ),
      ),
    );
  }



}
