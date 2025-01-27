import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Brandproducts_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';

import '../product_detail_screen.dart';

class Brandproducts extends StatefulWidget {

  const Brandproducts({Key? key, required this.brandName}) : super(key: key);
  final String brandName;

  @override
  _BrandproductsState createState() => _BrandproductsState();
}

class _BrandproductsState extends State<Brandproducts> {

  bool isLoading = true;
  List<Brandproductsmodal>  _brandProducts=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
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

  _getProducts() async {
    String url =  ApiUrl.manufacturer + '&name=${widget.brandName.toString()}';
    print(url);
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },

    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final List<dynamic> responseData = json.decode(response.body);
      print(responseData);
      if(responseData.length <= 0){
        showSnackbar('No products to show');
      } else {
        setState(() {
          for (Map data in responseData) {
            _brandProducts.add(Brandproductsmodal.fromJson(data));
          }
        });
      }
    } else {
      print('Contact admin');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        color: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            BackWidget( title: '${widget.brandName} products'),
            SizedBox(height: 10,),
            _products(),
            Footerwidget(),

          ],
        ),
      ),
    );
  }

  _products() {
    return   StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: _brandProducts.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        Brandproductsmodal product = _brandProducts[index];
        return GestureDetector(

          child: Padding(
            padding: EdgeInsets.all(5),
            child:  Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        product.photo!= null ? Image.network(
                          product.photo.toString(),

                        ) : Image.asset(
                          'assets/images/noimage.png',
                          width: 50,
                          height: 50,
                        ),

                        Text(
                          product.slug.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomColor.accentColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10 * 0.5,
                            right: 10 * 0.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${product.name} ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),
                                  ),


                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                )
            ),
          ),
          onTap: () {


          },
        );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(1),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }
}
