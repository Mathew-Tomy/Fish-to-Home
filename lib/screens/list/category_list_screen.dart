import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Category_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'category_product_list.dart';

class Categorylist extends StatefulWidget {
  const Categorylist({Key? key}) : super(key: key);

  @override
  _CategorylistState createState() => _CategorylistState();
}

class _CategorylistState extends State<Categorylist> {

  bool isLoading = true;
  List<Categorylistmodal> _categorys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryAPI();
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

  _categoryAPI() async {
    String url = ApiUrl.categories;
    print('Fetching categories from: $url');

    try {
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic>? productList = responseData['products'];

        if (productList != null && productList.isNotEmpty) {
          setState(() {
            _categorys = productList.map((data) => Categorylistmodal.fromJson(data)).toList();
            print('First category name: ${_categorys![0].names}');
          });
        } else {
          // Display a message if no products are found
          showSnackbar('Product details not available.');
        }
      } else {
        print('Failed to fetch categories. HTTP Status Code: ${response.statusCode}');
        showSnackbar('Failed to fetch categories. Please try again later.');
      }
    } catch (error) {
      print('Error fetching categories: $error');
      showSnackbar('An error occurred while fetching categories.');
    } finally {
      // Ensure the loading state is updated, regardless of the outcome
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Category',style: TextStyle(color: Colors.black),),
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
        Categorylistmodal cat = _categorys[index];
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
                  image: DecorationImage(
                    image: NetworkImage(cat.photo.toString()), // Assuming photo contains the image URL
                    fit: BoxFit.cover,
                  ),
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
                  builder: (context) => CategoryProduct(
                    categoryId: cat.category_id.toString(),
                    categoryName: cat.names.toString(),
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
