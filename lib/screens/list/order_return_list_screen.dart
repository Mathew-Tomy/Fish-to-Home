import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Return_order_detail_modal.dart';
import 'package:glitzy/modals/Returns_modal.dart';
import 'package:glitzy/screens/return_summary_screen.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Returnlist extends StatefulWidget {
  const Returnlist({Key? key}) : super(key: key);

  @override
  _ReturnlistState createState() => _ReturnlistState();
}



class _ReturnlistState extends State<Returnlist> {

  bool isLoading = true;
  List<Returns> returns = [];
  List<ProductsReturn> productsReturn =[];
  bool isLoadingDetail = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getReturns();
  }




  // _getReturns() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
  //
  //   String url =  ApiUrl.returnList+ '/$userId';
  //   Response response = await get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //
  //       isLoading = false;
  //     });
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     print(responseData);
  //     List<dynamic> data = responseData['returns'];
  //
  //     if(data.length > 0){
  //       for (Map data in data) {
  //         returns.add(Returns.fromJson(data));
  //       }
  //
  //
  //
  //
  //     } else {
  //       //showSnackbar('No products in cart');
  //     }
  //
  //
  //
  //   } else {
  //     print('Contact admin');
  //   }
  // }

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
        title: Text('Returns',style: TextStyle(color:CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :   returnWidget(),
      // Footerwidget()
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  //
  Widget returnWidget() {
    return ListView.builder(
      itemCount: returns.length,
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
                    'Return date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(returns[index].dateAdded!))}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Order id: ${returns[index].orderId!}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Products: ${returns[index].name.toString()}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Return Reason: ${returns[index].return_reason.toString()}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(returns[index].status.toString()), // Access status from individual Orders object
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          returns[index].status.toString(), // Access status from individual Orders object
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
            if (returns[index] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Returnsummary(returnId: returns[index].returnId.toString()),
                ),
              );
            } else {
              // Handle the case where orders[index] is null
              // You can show an error message or handle it in another appropriate way
              print('Return at index $index is null.');
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