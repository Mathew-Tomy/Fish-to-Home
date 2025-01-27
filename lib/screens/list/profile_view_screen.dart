import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Profile_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:glitzy/screens/dashboard_screen.dart';

class Profileview extends StatefulWidget {
  const Profileview({Key? key}) : super(key: key);

  @override
  _ProfileviewState createState() => _ProfileviewState();
}



class _ProfileviewState extends State<Profileview> {
  List<Customer> customer = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getProfile();
  }


  bool isLoading = true;

  var _formKey = GlobalKey<FormState>();


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

  // _getProfile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
  //   String url = ApiUrl.profile + '/$userId';
  //   print(url);
  //   Response response = await get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     print(responseData);
  //     List<dynamic> address = responseData['customer'];
  //
  //     if (address.length > 0) {
  //       for (Map<String, dynamic> data in address) {
  //         customer.add(Customer.fromJson(data));
  //       }
  //     } else {
  //       showSnackbar('No address available');
  //     }
  //   } else {
  //     print('Contact admin');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Profile Page',style: TextStyle(color: CustomColor.accentColor),),
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

  Widget addressbookWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: customer.length,
        itemBuilder: (context, index) {
          Customer profile = customer[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 16), // Adding space here
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profile.image ?? ''),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${profile.firstname!.toUpperCase()} ${profile.lastname!.toUpperCase()}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '${profile.email!.toLowerCase()}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(),
                ),
          const SizedBox(height: 16), // Adding space here

                Text(
                  '${profile.telephone!}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {},
                      heroTag: 'Order Count',
                      elevation: 0,

          label: Text("Order Count ${profile.orders.toString()}"),

          icon: const Icon(Icons.shopping_bag),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton.extended(
                      onPressed: () {},
                      heroTag: 'mesage',
                      elevation: 0,
                      backgroundColor: Colors.red,
                      label: Text("Return Count ${profile.returns.toString()}"),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Adding space here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {},
                      heroTag: 'Cart Count',
                      elevation: 0,

                      label: Text("Cart Count ${profile.cart.toString()}"),

                      icon: const Icon(Icons.shopping_bag),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton.extended(
                      onPressed: () {},
                      heroTag: 'mesage',
                      elevation: 0,
                      backgroundColor: Colors.red,
                      label: Text("Wishlist Count ${profile.wishlist.toString()}"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}









