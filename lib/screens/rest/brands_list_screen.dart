import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Homepage_modal.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'brand_product_list_screen.dart';

class Brands extends StatefulWidget {


  const Brands({Key? key,required this.dsouqBrands}) : super(key: key);

  final List<Banners> ?dsouqBrands;



  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
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
            BackWidget( title: 'Brands'),
            SizedBox(height: 10,),
            _brandsWidget(),
            Footerwidget(),


          ],
        ),
      ),
    );
  }

  _brandsWidget() {
    return   StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: widget.dsouqBrands!.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        Banners brand = widget.dsouqBrands![index];
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
                child: Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          brand.photo!= null ? Image.network(
                            brand.photo.toString(),
                            width: 100,
                            height: 100,
                          ) : Image.asset(
                            'assets/images/noimage.png',
                            width: 50,
                            height: 50,
                          ),
                          // Text(
                          //   brand.name.toString(),
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //     color: CustomColor.accentColor,
                          //     fontSize: 15,
                          //     fontWeight: FontWeight.w500
                          //   ),
                          // ),

                        ],
                      ),

                    ],
                  ),
                )
            ),
          ),
          // onTap: () {
          //   Navigator.push(context, MaterialPageRoute(
          //
          //     builder: (context) => Brandproducts(brandName: brand.name.toString(), ),
          //   ),
          //   );
          //
          // },
        );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(1),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }
}
