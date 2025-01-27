import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/SubCategory_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'subcategory_product_list.dart';

class SubCategorylist extends StatefulWidget {
  const SubCategorylist({Key? key}) : super(key: key);

  @override
  _SubCategorylistState createState() => _SubCategorylistState();
}

class _SubCategorylistState extends State<SubCategorylist> {

  bool isLoading = true;
  List<SubCategorylistmodal> _categorys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _categoryAPI();
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

  // _categoryAPI() async {
  //   String url =  ApiUrl.subcategories;
  //   print(url);
  //   Response response = await get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //
  //
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     final List<dynamic> productList = responseData['products'];
  //     print(responseData);
  //     if (productList.length <= 0) {
  //       showSnackbar('Product detail not available');
  //     } else {
  //       setState(() {
  //         _categorys = productList.map((data) => SubCategorylistmodal.fromJson(data)).toList();
  //         print(_categorys![0].names);
  //       });
  //     }
  //
  //
  //
  //   } else {
  //     print('Contact admin');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sub Category',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : _categoryWidget(),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  _categoryWidget() {
    return ListView.separated(
      itemCount: _categorys.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        SubCategorylistmodal cat = _categorys[index];
        return ListTile(
          title: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  color: Colors.blue.shade200,

                ),
              ),
              SizedBox(width: 10), // Add spacing between image and text
              Text(cat.names.toString()),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoryProduct(
                    subcategoryId: cat.subcategory_id.toString(),
                    subcategoryName: cat.names.toString(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }



}
