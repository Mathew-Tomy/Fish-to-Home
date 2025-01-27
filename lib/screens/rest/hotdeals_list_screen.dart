import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Hotdeal_products_modal.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../product_detail_screen.dart';

class Hotdealslist extends StatefulWidget {

  const Hotdealslist({Key? key, this.productsHotdeal}) : super(key: key);

  final  List<ProductsHotdeal> ?productsHotdeal;

  @override
  _HotdealslistState createState() => _HotdealslistState();
}

class _HotdealslistState extends State<Hotdealslist> {
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
            BackWidget( title: 'Hot Deals'),
            SizedBox(height: 10,),
            _hotDealswidget(),
            Footerwidget(),
          ],
        ),
      ),
    );
  }

  _hotDealswidget(){
    return   StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: widget.productsHotdeal!.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        ProductsHotdeal product = widget.productsHotdeal![index];
        return GestureDetector(

          child: Padding(
            padding: EdgeInsets.all(5),
            child:  Container(
                height: 200,
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 5,),
                        product.photo!= null ? Image.network(
                          product.photo.toString(),
                          width: 100,
                          height: 100,
                        ) : Image.asset(
                          'assets/images/noimage.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 12 * 0.5,),
                        Text(
                          product.productName.toString(),
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
                                    '${product.price} ',
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
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Productdetail(productId: product.productId.toString(), ),
            ),
            );

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
