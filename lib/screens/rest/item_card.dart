import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/modals/Banner_modal.dart';
import '../modals/Headerimages_modal.dart';
import '../modals/Category_modal.dart';
import 'package:glitzy/modals/Category_product_modal.dart';
import 'package:glitzy/modals/Catalog_products_modal.dart';
import 'package:glitzy/modals/Best_products_modal.dart';
import 'package:glitzy/screens/product_detail_screen.dart';
import 'package:glitzy/screens/list/cart_list_screen.dart';
import 'package:glitzy/screens/list/best_product_list_screen.dart';
import '../modals/Feature_products_modal.dart';
import 'package:glitzy/screens/list/wishlist_products_screen.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/screens/product_search_screen.dart';
import 'package:glitzy/screens/list/category_list_screen.dart';
import 'package:glitzy/screens/list/subcategory_list_screen.dart';
import 'package:glitzy/screens/list/address_book_list_screen.dart';
import 'package:glitzy/screens/list/orders_list_screen.dart';
import 'package:glitzy/screens/list/order_return_list_screen.dart';
import 'package:glitzy/screens/list/profile_view_screen.dart';
import 'package:glitzy/screens/password_change_screen.dart';
import '../../../constants.dart';
import '../screens/list/category_product_list.dart';
import 'dart:ui'; // Import this for Color class


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;

  List<Banners> ?banners=[];
  List<HeaderImages> ?headerimages=[];
  List<BestProducts> ?bestProducts = [];
  List<Categorylistmodal> ?bestcategories= [];
  List<Products> ?productsCategory = [];
  List<FeatureProduct> featureProductsList = []; // Fetch Feature Products List
  List<CatalogProduct> catalogProductsList = []; // Fetch Feature Products List
  int _currentPage = 0;
  final PageController _pageController = PageController();
  late Timer _timer;

  get index => null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getBannersData();
    _getHeaderImagesData();
    _getBestProducts();
    _getCategoriesData();
    _getFeatureProducts();
    _getCatalogProducts();
    _getCategoryProducts();
  }



  _getBannersData() async {
    String url =  ApiUrl.slider;
    Response response = await get( // Change post to get here
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData['banners'] != null) { // Check if banners exist in the response
        List<dynamic> bannerData = responseData['banners'];
        setState(() {
          isLoading = false;
          banners = bannerData.map((banner) => Banners.fromJson(banner)).toList();
        });
      } else {
        // Handle error: banners not found in response
        print('No banners found in the response');
      }
    } else {
      // Handle error: HTTP status code other than 200
      print('Failed to fetch banners. HTTP Status Code: ${response.statusCode}');
    }
  }
  // Fetch header images
  _getHeaderImagesData() async {
    String url = ApiUrl.images;

    Response response = await get( // Change post to get here
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['products'] !=
          null) { // Check if banners exist in the response
        List<dynamic> headerimageData= responseData['products'];
        setState(() {
          isLoading = false;
          headerimages =
              headerimages = headerimageData.map((headerimage) => HeaderImages.fromJson(headerimage)).toList();
        });
      } else {
        // Handle error: banners not found in response
        print('No banners found in the response');
      }
    } else {
      // Handle error: HTTP status code other than 200
      print('Failed to fetch banners. HTTP Status Code: ${response
          .statusCode}');
    }
  }
  // Fetch Best Products List
  _getBestProducts() async {
    String url =  ApiUrl.best;
    Response response = await get( // Change post to get here
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['products'] !=
          null) { // Check if banners exist in the response

        List<dynamic> bestProductsData = responseData['products'];
        setState(() {
          isLoading = false;
          bestProducts =
              bestProducts = bestProductsData.map((bestProduct) => BestProducts.fromJson(bestProduct)).toList();
        });
      } else {
        // Handle error: banners not found in response
        print('No best products found in the response');
      }
    } else {
      // Handle error: HTTP status code other than 200
      print('Failed to fetch best products. HTTP Status Code: ${response
          .statusCode}');
    }
  }

  // Fetch Feature Products List

  _getFeatureProducts() async {
    String url = ApiUrl.hotdeals;
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['featured'] != null) {
        List<dynamic> featureProductsData = responseData['featured'];
        setState(() {
          isLoading = false;
          featureProductsList = featureProductsData.map((featureProduct) => FeatureProduct.fromJson(featureProduct)).toList();

        });
      } else {
        print('No best products found in the response');
      }
    } else {
      print('Failed to fetch best products. HTTP Status Code: ${response.statusCode}');
    }
  }

  _getCatalogProducts() async {
    String url = ApiUrl.products;
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['products'] != null) {
        List<dynamic> catalogProductsData = responseData['products'];
        setState(() {
          isLoading = false;
          catalogProductsList = catalogProductsData.map((featureProduct) => CatalogProduct.fromJson(featureProduct)).toList();

        });
      } else {
        print('No best products found in the response');
      }
    } else {
      print('Failed to fetch best products. HTTP Status Code: ${response.statusCode}');
    }
  }

  // Fetch category images
  _getCategoriesData() async {
    String url =  ApiUrl.categories;


    Response response = await get( // Change post to get here
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['products'] !=
          null) { // Check if banners exist in the response
        List<dynamic> categoryData= responseData['products'];
        setState(() {
          isLoading = false;
          bestcategories =
              bestcategories = categoryData.map((productList) => Categorylistmodal.fromJson(productList)).toList();
        });
      } else {
        // Handle error: banners not found in response
        print('No Category found in the response');
      }
    } else {
      // Handle error: HTTP status code other than 200
      print('Failed to fetch banners. HTTP Status Code: ${response
          .statusCode}');
    }
  }

  _getCategoryProducts() async {
    int categoryId = 22;
    String url = ApiUrl.categoryProducts + categoryId.toString();

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

      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productList = responseData['products'];

      if (productList.length <= 0) {
        print('No best products found in the response');
      } else {
        setState(() {
          // Clear the existing productsCategory list
          productsCategory!.clear();

          // Parse each product and add it to the productsCategory list
          for (var productData in productList) {
            productsCategory!.add(Products.fromJson(productData));
          }
          print(productsCategory![0].name);
        });
      }
    } else {
      print('Contact admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'assets/appicon.jpeg',
                width: 150,
                height: 150,
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.category,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Categories',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Categorylist(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.category,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Sub Categories',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SubCategorylist(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.storage_rounded ,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Orders',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Ordrslist(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.assignment_return_rounded,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Returns',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Returnlist(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.house,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Address Book',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Addressbook(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.lock,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Change Password',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Passwordchange(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Profile',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Profileview(),
                    ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Log out',style: TextStyle(color: Colors.black38,fontSize: 15),),
                  onTap: ()  async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.pushReplacementNamed(context, "/loginscreen");
                  },
                ),




              ],
            ),
            SizedBox(height: 85,),
            Container(
              height: 85,
              color: Colors.black,
              child: Column(
                children: [
                  SizedBox(height: 3,),
                  Center(child: Text('St. Catharines, Ontario,',style: TextStyle(color: Colors.white),)),
                  SizedBox(height: 5,),

                  Center(child: Text('Phone : +9053283119, Email : admin@glitzystudio.ca',style: TextStyle(fontSize: 12,color: Colors.white),)),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/logo.jpeg', width:75,height: 50,),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Searchproduct(),
              ),
              );
              // do something
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.deepOrangeAccent,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cart(),
                ),
              );
            },
          ),


          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.orangeAccent,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Wishlist(),
                ),
              );
            },
          ),
        ],
      ),

      body: isLoading ? Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(CustomColor.accentColor)
        ),
      ) : ListView(
        children: <Widget>[
          //
          _Banners(),
          SizedBox(height: 10,),
          // _HeaderImages(),
          _CategoryTextWidget(),
          _CategoriesImages(),
          _Typebuild(), // Include _Typebuild() widget here
          SizedBox(height: 10,),
          // _bestProductsTextWidget(),
          // _bestproductsWidget(),
          _catalogProductsTextWidget(),
          _catalogproductsWidget(),
          _featureProductsTextWidget(),
          _featureproductsWidget(),


          // Footerwidget(),
        ],
      ),
    );
  }

  // _HeaderImages() {
  //   return headerimages != null && headerimages!.isNotEmpty
  //       ? Container(
  //     height: 65,
  //     width: 80,
  //     child: CarouselSlider.builder(
  //       itemCount: headerimages!.length,
  //       options: CarouselOptions(
  //         aspectRatio: 1.0,
  //         viewportFraction: 0.12,
  //         autoPlay: true,
  //         autoPlayInterval: Duration(seconds: 3),
  //         autoPlayAnimationDuration: Duration(milliseconds: 800),
  //         autoPlayCurve: Curves.fastOutSlowIn,
  //         enlargeCenterPage: true,
  //       ),
  //       itemBuilder: (context, index, realIndex) {
  //         HeaderImages? headerImage = headerimages![index];
  //         if (headerImage != null && headerImage.photo != null) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //             child: Column(
  //               children: [
  //                 ClipOval(
  //                   child: Image.network(
  //                     headerImage.photo!,
  //                     width: 80,
  //                     height: 60,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         } else {
  //           // Handle null case by returning an empty container or other UI
  //           return Container();
  //         }
  //       },
  //     ),
  //   )
  //       : Container(); // Return an empty container if headerimages is null or empty
  // }

  _Banners() {
    return banners != null && banners!.isNotEmpty
        ? ImageSlideshow(
      width: double.infinity,
      height: 125,
      initialPage: 0,
      indicatorColor: Colors.white,
      indicatorBackgroundColor: Colors.grey,
      onPageChanged: (value) {},
      autoPlayInterval: 3000,
      isLoop: true,
      children: <Widget>[
        for (int i = 0; i < banners!.length; i++)
          Image.network(
            banners![i].photo.toString(),
            fit: BoxFit.fill,
          ),
      ],
    )
        : Container(); // Return an empty container if banners is null or empty
  }

  @override
  Widget _Typebuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTypeButton(context, 'Best', 'best'),
        _buildTypeButton(context, 'Feature', 'feature'),
        _buildTypeButton(context, 'Top', 'top'),

        _buildTypeButton(context, 'New', 'new'),
      ],
    );
  }
  Widget _buildTypeButton(BuildContext context, String label, String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TypeProductsScreen(type: type),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black, // Changed text color to black for better visibility
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _CategoryTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sarees',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          InkWell(
            child: Text(
              'See More',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProduct(
                    categoryId: 22.toString(), categoryName: '', // Pass the category ID as a string
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget _CategoriesImages() {
    if (productsCategory == null || productsCategory!.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    Timer? _timer;

    void startTimer() {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (_currentPage < (productsCategory!.length / 5).ceil() - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    }

    startTimer(); // Start the timer when the widget initializes

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200, // Adjust the height according to your needs
          child: PageView.builder(
            itemCount: (productsCategory!.length / 2).ceil(), // Display 2 products per page
            itemBuilder: (BuildContext context, int index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2;
              return Row(
                children: productsCategory!
                    .sublist(startIndex, endIndex <= productsCategory!.length ? endIndex : productsCategory!.length)
                    .map((product) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Navigate to product detail page
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productdetail(productId: product.productId.toString()),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: product.photo != null
                                      ? NetworkImage(product.photo!)
                                      : AssetImage('assets/images/noimage.png') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: kDefaultPaddin / 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                              child: Text(
                                // products is out demo list
                                '${product.name.toString()}',


                                style: TextStyle(color: kTextLightColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                              child: Text(
                                '\$${product.price ?? 0}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
  //
  // Widget _bestProductsTextWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 15.0, right: 15),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Best Offers',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //         ),
  //         InkWell(
  //           child: Text(
  //             'See More',
  //             style: TextStyle(fontSize: 15, color: Colors.grey),
  //           ),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => TypeProductsScreen(type: 'best'),
  //               ),
  //             );
  //           },
  //
  //
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // @override
  // Widget _bestproductsWidget() {
  //   if (bestProducts == null || bestProducts!.isEmpty) {
  //     return Center(child: CircularProgressIndicator());
  //   }
  //
  //   Timer? _timer;
  //
  //   void startTimer() {
  //     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //       if (_currentPage < (bestProducts!.length / 5).ceil() - 1) {
  //         _currentPage++;
  //       } else {
  //         _currentPage = 0;
  //       }
  //     });
  //   }
  //
  //   startTimer(); // Start the timer when the widget initializes
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 200, // Adjust the height according to your needs
  //         child: PageView.builder(
  //           itemCount: (bestProducts!.length / 2).ceil(), // Display 2 products per page
  //           itemBuilder: (BuildContext context, int index) {
  //             int startIndex = index * 2;
  //             int endIndex = startIndex + 2;
  //             return Row(
  //               children: bestProducts!
  //                   .sublist(startIndex, endIndex <= bestProducts!.length ? endIndex : bestProducts!.length)
  //                   .map((product) {
  //                 return Expanded(
  //                   child: GestureDetector(
  //                     onTap: () async {
  //                       // Navigate to product detail page
  //                       await Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => Productdetail(productId: product.productId.toString()),
  //                         ),
  //                       );
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Container(
  //                             height: 140,
  //                             decoration: BoxDecoration(
  //                               border: Border.all(
  //                                 color: Colors.grey.withOpacity(0.5),
  //                               ),
  //                               borderRadius: BorderRadius.circular(16),
  //                               image: DecorationImage(
  //                                 image: product.photo != null
  //                                     ? NetworkImage(product.photo!)
  //                                     : AssetImage('assets/images/noimage.png') as ImageProvider,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: kDefaultPaddin / 2),
  //                           Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
  //                             child: Text(
  //                               // products is out demo list
  //                               '${product.productName.toString()}',
  //
  //
  //                               style: TextStyle(color: kTextLightColor),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
  //                             child: Text(
  //                               '\$${product.price ?? 0}',
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }).toList(),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }


  Widget _featureProductsTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Feature Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          InkWell(
            child: Text(
              'See More',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TypeProductsScreen(type: 'feature'),
                ),
              );
            },


          ),
        ],
      ),
    );
  }


  @override
  Widget _featureproductsWidget() {
    if (featureProductsList == null || featureProductsList!.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    Timer? _timer;

    void startTimer() {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (_currentPage < (featureProductsList!.length / 5).ceil() - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    }

    startTimer(); // Start the timer when the widget initializes

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200, // Adjust the height according to your needs
          child: PageView.builder(
            itemCount: (featureProductsList!.length / 2).ceil(), // Display 2 products per page
            itemBuilder: (BuildContext context, int index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2;
              return Row(
                children: featureProductsList!
                    .sublist(startIndex, endIndex <= featureProductsList!.length ? endIndex : featureProductsList!.length)
                    .map((product) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Navigate to product detail page
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productdetail(productId: product.productId.toString()),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: product.photo != null
                                      ? NetworkImage(product.photo!)
                                      : AssetImage('assets/images/noimage.png') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: kDefaultPaddin / 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                              child: Text(
                                // products is out demo list
                                '${product.productName.toString()}',


                                style: TextStyle(color: kTextLightColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                              child: Text(
                                '\$${product.price ?? 0}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

//Catalog
  Widget _catalogProductsTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          InkWell(
            child: Text(
              'See More',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TypeProductsScreen(type: 'feature'),
                ),
              );
            },


          ),
        ],
      ),
    );
  }

  @override
  Widget _catalogproductsWidget() {
    if (catalogProductsList == null || catalogProductsList!.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    Timer? _timer;

    void startTimer() {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (_currentPage < (catalogProductsList!.length / 5).ceil() - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    }

    startTimer(); // Start the timer when the widget initializes

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200, // Adjust the height according to your needs
          child: PageView.builder(
            itemCount: (catalogProductsList!.length / 2).ceil(), // Display 2 products per page
            itemBuilder: (BuildContext context, int index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2;
              return Row(
                children: catalogProductsList!
                    .sublist(startIndex, endIndex <= catalogProductsList!.length ? endIndex : catalogProductsList!.length)
                    .map((product) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Navigate to product detail page
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productdetail(productId: product.productId.toString()),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: product.photo != null
                                      ? NetworkImage(product.photo!)
                                      : AssetImage('assets/images/noimage.png') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: kDefaultPaddin / 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                              child: Text(
                                // products is out demo list
                                '${product.productName.toString()}',


                                style: TextStyle(color: kTextLightColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                              child: Text(
                                '\$${product.price ?? 0}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}