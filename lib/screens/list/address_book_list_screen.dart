import 'dart:convert';

import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Addressbook_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
import '../add_address_screen.dart';
import '../view_address_screen.dart';

class Addressbook extends StatefulWidget {
  const Addressbook({Key? key}) : super(key: key);

  @override
  _AddressbookState createState() => _AddressbookState();
}

class _AddressbookState extends State<Addressbook> {
  
  bool isLoading = true;
  List<AddressData> addressData = [];


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






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Address book',style: TextStyle(color: CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : addressbookWidget(),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  addressbookWidget() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        AddressData address = addressData[position];
        return  Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.grey.shade200)),
              padding: EdgeInsets.only(left: 12, top: 8, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${address.firstname!.toUpperCase()} ${address.lastname!.toUpperCase()}",
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(16))),
                        child: Text(
                          "HOME",
                          style: TextStyle(
                              color: Colors.indigoAccent.shade200, fontSize: 8),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${address.customer_email!}",
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(16))),
                        // child: Text(
                        //   "HOME",
                        //   style: TextStyle(
                        //       color: Colors.indigoAccent.shade200, fontSize: 8),
                        // ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${address.customer_mobile!}",
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(16))),
                        // child: Text(
                        //   "HOME",
                        //   style: TextStyle(
                        //       color: Colors.indigoAccent.shade200, fontSize: 8),
                        // ),
                      )
                    ],
                  ),


                  createAddressText(
                      address.customer_short_address.toString(), 16),
                  createAddressText(address.customer_address_1.toString() + ',' + address.customer_address_2.toString(), 6),
                  createAddressText(address.city.toString() + ',' + address.country.toString(), 6),
                  SizedBox(
                    height: 6,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: address.zip.toString() + ',' + address.state.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
                      // TextSpan(
                      //     text: "02222673745",
                      //     style:TextStyle(color: Colors.black, fontSize: 12)),
                    ]),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 1,
                    width: double.infinity,
                  ),
                  addressAction(address)
                ],
              ),
            ),
          ),
        );
      },
      itemCount: addressData.length,
    );

  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style:TextStyle(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }

  addressAction(address) {
    return Container(
      child: Row(
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Viewaddress(address: address,),
              ),
              );
            },
            child: Text(
              "Edit / Change",
              style:TextStyle(fontSize: 12, color: Colors.indigo.shade700),
            ),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 3,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          Spacer(
            flex: 3,
          ),

          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
   //


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
                Navigator.pop(context);
                setState(() {
                  isLoading = true;
                  addressData = [];
                });

                _getAddress();
              },
            ),
          ],
        );
      },
    );
  }
}
