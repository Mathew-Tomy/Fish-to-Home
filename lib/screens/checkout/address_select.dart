import 'dart:convert';
import 'package:fishtohome/modals/Addressbook_modal.dart';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Addressbook_modal.dart';
import 'package:fishtohome/modals/Cart_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/screens/checkout/payment_method_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_address_screen.dart';
import '../add_address_screen.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
// import 'order_checkout.dart';

class CheckoutAddress extends StatefulWidget {

  const CheckoutAddress({Key? key, this.productsCart, required this.totalAmount}) : super(key: key);
  final  List<Products> ?productsCart;
  final String totalAmount;


  @override
  _CheckoutAddressState createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress> {

  bool isLoading = true;
  List<AddressData> addressData = [];
  AddressData ?selectedAddress;
  bool isLoadingButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddress();
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
        title: Text('Delivery Address',style: TextStyle(color: CustomColor.accentColor),),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColor.accentColor, // Button background color
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addaddress(),
            ),
          );
        },
        icon: Icon(
          Icons.add,
          color: Colors.white, // Icon color
        ),
        label: Text(
          "New Address",
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold, // Optional: Makes text bold for better visibility
          ),
        ),
      ),



      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Column(
        children: [
          addressbookWidget(),
          SizedBox(height: 10,),
          _proceedButton(),


        ],

      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  addressbookWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: addressData.length,
        itemBuilder: (context, index) {
          AddressData address = addressData[index];
          return Column(
            children: [
              RadioListTile<AddressData>(
                activeColor: CustomColor.primaryColor,
                value: address,
                groupValue: selectedAddress,
                onChanged: (AddressData? ind) {
                  setState(() {
                    selectedAddress = ind!;
                    print(selectedAddress!.customer_address_1);
                  });
                },
                title: Text(address.firstname.toString() + ' ' + address.lastname.toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.customer_email.toString() + ',' +
                      address.customer_address_1.toString() + ',' +
                          address.customer_address_1.toString() + ',' +
                          address.city.toString(), // Assuming this is a method call
                    ),
                    Text(
                      address.country.toString() + ',' +
                          address.zip.toString() + ',' +
                          address.state.toString() + ',' +
                          address.customer_mobile.toString(), // Assuming this is a property
                    ),
                    addressAction(address)
                  ],
                ),
              ),

            ],
          );

        });


  }
  Widget addressAction(AddressData address) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Viewaddress(address: address),
          ),
        );
      },
      child: Text(
        "Update Address / Change Address",
        style: TextStyle(fontSize: 12, color: Colors.indigo.shade700),
      ),
    );
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false; // Reset loading state
      });
      return;
    }
    String url = '${ApiUrl.addresslist}'; // Use the POST endpoint URL
    setState(() {
      isLoading = true;
      addressData = []; // Clear previous address data
    });

    try {
      // Sending POST request with the customer_id in the body
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // JSON content type
        },
        body: json.encode({
          'customer_id': customerId, // Send the customer_id in the body as JSON
        }),
      );

      print('Fetching address data from: $url');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true && responseData.containsKey('address_data')) {
          List<dynamic> addresses = responseData['address_data'];
          if (addresses.isNotEmpty) {
            setState(() {
              addressData = addresses.map((data) => AddressData.fromJson(data)).toList();
              isLoading = false; // Stop loading after successful fetch
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showSnackbar('No address available');
          }
        } else {
          setState(() {
            isLoading = false;
          });
          showSnackbar(responseData['message'] ?? 'Failed to fetch address data');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackbar('Failed to fetch addresses. HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
      setState(() {
        isLoading = false;
      });
      showSnackbar('An error occurred. Please try again.');
    }
  }


  _proceedButton() {
    return isLoadingButton
        ? Center(
      child: CircularProgressIndicator(),
    )
        : ElevatedButton(
      onPressed: () {
        if (selectedAddress == null) {
          showSnackbar('Select delivery address');
        } else if (selectedAddress!.customer_address_1 == null ||
            selectedAddress!.customer_address_1!.isEmpty ||
            selectedAddress!.customer_address_2 == null ||
            selectedAddress!.customer_address_2!.isEmpty ||
            selectedAddress!.zip == null ||
            selectedAddress!.zip!.isEmpty ||
            selectedAddress!.country == null ||
            selectedAddress!.country!.isEmpty ||
            selectedAddress!.state == null ||
            selectedAddress!.state!.isEmpty ||
            selectedAddress!.city == null ||
            selectedAddress!.city!.isEmpty) {
          showSnackbar('Please update your address');
        } else {
          // Navigate to Paymentselect page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Paymentselect(
                productsCart: widget.productsCart,
                selectedAddress: selectedAddress,
                totalAmount: widget.totalAmount,
              ),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.accentColor,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        "Proceed",
        style: TextStyle(color: Colors.white),
      ),
    );
  }





  }


