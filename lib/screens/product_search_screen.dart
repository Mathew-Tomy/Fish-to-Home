import 'dart:convert';

import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/modals/Searchproducts_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/screens/product_detail_screen.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
class Searchproduct extends StatefulWidget {
  const Searchproduct({Key? key}) : super(key: key);

  @override
  _SearchproductState createState() => _SearchproductState();
}

class _SearchproductState extends State<Searchproduct> {

  bool isLoading = false;
  TextEditingController controller = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  String ?_searchText;
  List<Searchproducts> ?products = [];


  _SearchState (){
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = controller.text;
          products =[];
        });

        _search();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _SearchState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            BackWidget( title: 'Search Products'),
            _searchBar(),
            _productsWidget(),
          ],
        ),
      ),
      persistentFooterButtons: [
        Footerwidget(),
      ],
    );
  }

  _searchBar() {
    return Container(
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Card(
          child: new ListTile(
            title: new TextField(
              onChanged: _SearchState(),
              controller: controller,
              decoration: new InputDecoration(
                  hintText: 'Search ', border: InputBorder.none),
            ),
            trailing: _searchIcon,
            onTap: _searchPressed,

          ),
        ),
      ),
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


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        print(_searchText);
        _search();


      } else {
        this._searchIcon = new Icon(Icons.search);
        controller.clear();
        products = [];
      }
    });
  }
  void _search() async {
    setState(() {
      isLoading = true;
      products = []; // Clear any existing search results
    });

    String url = ApiUrl.search;
    print('Search URL: $url');

    Map<String, dynamic> requestBody = {
      'search': _searchText,
      'category': '', // Optionally include the category
    };

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
      );

      print('Raw Response: ${response.body}');
      print('Response Status Code: ${response.statusCode}');

      // Check for successful response (status code 200)
      if (response.statusCode == 200) {
        // Ensure response is JSON
        if (response.headers['content-type']?.contains('application/json') == true) {
          try {
            final Map<String, dynamic> responseData = json.decode(response.body);

            // Check if the response contains 'items'
            if (responseData.containsKey('items')) {
              List<dynamic> search = responseData['items'];

              if (search.isNotEmpty) {
                setState(() {
                  products = search.map((data) => Searchproducts.fromJson(data)).toList();
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
                print('No products found.');
              }
            } else {
              setState(() {
                isLoading = false;
              });
              print('Response missing "items" key: $responseData');
              print('No items found in the response.');
            }
          } catch (e) {
            print('JSON Decoding Error: $e');
            showSnackbar('Invalid server response format.');
          }
        } else {
          print('Expected JSON response, received: ${response.headers['content-type']}');
          print('Server error: Received unexpected data format.');
        }
      } 
      // else {
      //   print('HTTP Error: Status code ${response.statusCode}');
      //   showSnackbar('Server error. Please try again.');
      // }
    } catch (error) {
      print('Network Error: $error');
      showSnackbar('An error occurred. Please check your connection.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }





  _productsWidget() {
    return isLoading ? Center (
      child: CircularProgressIndicator(),
    ) :
    ListView.builder(
      itemCount: products!.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        Searchproducts result = products![index];
        return Padding(
          padding: const EdgeInsets.only(
            top:10,
            right: 10 * 0.5,
            left: 10 * 0.5,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: CustomColor.greyColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 8,
                  right: 3
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child:  result.photo!= null ? Image.network(
                            result.photo.toString(),
                            width: 100,
                            height: 100,
                          ) : Image.asset(
                            'assets/images/noimage.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.product_name.toString(),
                                style: TextStyle(

                                  color: CustomColor.accentColor,

                                ),
                              ),
                              SizedBox(height: 10 * 0.5,),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                          Icons.arrow_forward_ios_outlined
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Productdetail(productId: result.product_id.toString(), ),
                        ),
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }

}
