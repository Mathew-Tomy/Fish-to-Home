import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/modals/Banner_modal.dart';
import 'package:fishtohome/screens/list/catalog_product_list.dart';
import '../data/sharedpreferences.dart';
import '../modals/Headerimages_modal.dart';
import '../modals/Category_modal.dart';
import 'package:fishtohome/modals/Category_product_modal.dart';
import 'package:fishtohome/modals/Catalog_products_modal.dart';
import 'package:fishtohome/modals/Best_products_modal.dart';
import 'package:fishtohome/screens/product_detail_screen.dart';
import 'package:fishtohome/screens/list/cart_list_screen.dart';
import 'package:fishtohome/screens/list/best_product_list_screen.dart';
import '../modals/Feature_products_modal.dart';
import 'package:fishtohome/screens/list/wishlist_products_screen.dart';
import 'package:fishtohome/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fishtohome/screens/product_search_screen.dart';
import 'package:fishtohome/screens/list/category_list_screen.dart';
//import 'package:fishtohome/screens/list/subcategory_list_screen.dart';
import 'package:fishtohome/screens/list/address_book_list_screen.dart';
import 'package:fishtohome/screens/list/orders_list_screen.dart';
//import 'package:fishtohome/screens/list/order_return_list_screen.dart';
// import 'package:fishtohome/screens/list/profile_view_screen.dart';
import 'package:fishtohome/screens/password_change_screen.dart';
import '../../../constants.dart';
import '../screens/list/category_product_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fishtohome/screens/list/horizontal_listview.dart';
import 'dart:ui';

import 'login_screen.dart'; // Import this for Color class


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  bool _isLoggedIn = false;
  Userpreferences userPreferences = Userpreferences(); // Instantiate your Userpreferences class
  List<Banners> ?banners=[];
  List<HeaderImages> ?headerimages=[];
  List<BestProducts> ?bestProducts = [];
  List<Categorylistmodal> ?bestcategories= [];
  List<Products> ?productsCategory = [];
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
   // _getBestProducts();
    _getCategoriesData();

    _getCatalogProducts();
    //_getCategoryProducts();
    _checkLoginStatus();  // Check login status when widget is initialized

  }

  Future<void> _checkLoginStatus() async {
    String? token = await userPreferences.getToken();  // Use getToken from your Userpreferences
    setState(() {
      _isLoggedIn = token != null;  // If token exists, user is logged in
    });
  }


  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all session data

    // Navigate to the login screen and clear back stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Loginscreen()),
          (Route<dynamic> route) => false,
    );
  }



  _getBannersData() async {
   setState(() {
     isLoading = true;
   });
  String url = ApiUrl.slider;  // Make sure ApiUrl.slider is correct
  try {
    Response response = await get(
      Uri.parse(url),
       headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['banners'] != null) {
        List<dynamic> bannerData = responseData['banners'];

        setState(() {
          isLoading = false;  // Assuming you set `isLoading` to true initially
          banners = bannerData.map((banner) => Banners.fromJson(banner)).toList();
        });
      } else {
        // Handle case when 'banners' key is missing or empty
        print('No banners found in the response');
        setState(() {
          isLoading = false;  // Ensure loading state is updated in case of failure
        });
      }
    } else {
      // Handle HTTP errors
      print('Failed to fetch banners. HTTP Status Code: ${response.statusCode}');
      setState(() {
        isLoading = false;  // Ensure loading state is updated in case of failure
      });
    }
  } catch (e) {
    // Handle any errors that might occur during the HTTP request (e.g., network error)
    print('Error: $e');
    setState(() {
      isLoading = false;  // Ensure loading state is updated in case of failure
    });
  }
}

  // Fetch header images
_getHeaderImagesData() async {
  setState(() {
    isLoading = true;
  });
  String url = ApiUrl.categories;  // Make sure ApiUrl.categories is correct
  try {
    // Make the GET request to fetch categories
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

       if (responseData['status'] == true && responseData['products'] != null) {
        List<dynamic> headerimageData = responseData['products'];

        setState(() {
          isLoading = false;  // Stop loading when data is fetched
          headerimages = headerimageData
              .map((headerimage) => HeaderImages.fromJson(headerimage))
              .toList();
        });
      } else {
        // Handle case when 'products' key is missing or null
        print('No header images found in the response');
        setState(() {
          isLoading = false;  // Stop loading even if no data found
        });
      }
    } else {
      // Handle HTTP errors
      print('Failed to fetch header images. HTTP Status Code: ${response.statusCode}');
      setState(() {
        isLoading = false;  // Stop loading in case of error
      });
    }
  } catch (e) {
    // Catch any exceptions (e.g., network errors)
    print('Error: $e');
    setState(() {
      isLoading = false;  // Stop loading on error
    });
  }
}



 _getCatalogProducts() async {
   setState(() {
     isLoading = true;
   });
  String url = ApiUrl.products;  // Your API endpoint
  try {
    // Make the GET request to fetch all products
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the status is true and products exist
      if (responseData['status'] == true && responseData['products'] != null) {
        List<dynamic> products = responseData['products'];

        setState(() {
          isLoading = false;
          catalogProductsList = products
              .map((productData) => CatalogProduct.fromJson(productData))
              .toList();
        });
      } else {
        print('No products found or status is false.');
      }
    } else {
      print('Failed to fetch products. HTTP Status Code: ${response.statusCode}');
    }
  } catch (error) {
    // Handle network errors or parsing errors
    print('Error fetching products: $error');
  }
}


  // Fetch category images
  _getCategoriesData() async {
    setState(() {
      isLoading = true;
    });
  String url = ApiUrl.categories;  // API URL for categories

  try {
    // Make the GET request to fetch categories
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    // Check if the response status code is 200 (success)
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);  // Decode the JSON response

      // Check if the 'status' is true and if the 'products' field is not null
      if (responseData['status'] == true && responseData['products'] != null) {
        List<dynamic> categoryData = responseData['products'];  // Extract the category data
        setState(() {
          isLoading = false;  // Stop loading once data is fetched
          bestcategories = categoryData
              .map((categoryJson) => Categorylistmodal.fromJson(categoryJson))
              .toList();  // Map the response data to Categorylistmodal objects
        });
      } else {
        print('No categories found or status is false.');
      }
    } else {
      print('Failed to fetch categories. HTTP Status Code: ${response.statusCode}');
    }
  } catch (error) {
    // Handle network or parsing errors
    print('Error fetching categories: $error');
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
                // Categories are available for both logged-in and not logged-in users
                ListTile(
                  leading: Icon(
                    Icons.category,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: const Text('Categories',
                      style: TextStyle(color: Colors.black38, fontSize: 15)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Categorylist(),
                      ),
                    );
                  },
                ),

                // Show these options only when the user is logged in
                if (_isLoggedIn) ...[
                  ListTile(
                    leading: Icon(
                      Icons.storage_rounded,
                      color: CustomColor.accentColor,
                      size: 25,
                    ),
                    title: const Text('Orders',
                        style: TextStyle(color: Colors.black38, fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ordrslist(),
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
                    title: const Text('Address Book',
                        style: TextStyle(color: Colors.black38, fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
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
                    title: const Text('Change Password',
                        style: TextStyle(color: Colors.black38, fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Passwordchange(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: CustomColor.accentColor,
                      size: 25,
                    ),
                    title: const Text('Delete Account',
                        style: TextStyle(color: Colors.black38, fontSize: 15)),

                    onTap: () => {
                      _AccountDeletion(context),
                    },
                  ),
                ],

                // Show Login or Logout based on login status
                ListTile(
                  leading: Icon(
                    _isLoggedIn ? Icons.logout : Icons.login,
                    color: CustomColor.accentColor,
                    size: 25,
                  ),
                  title: Text(
                    _isLoggedIn ? 'Log out' : 'Log in',
                    style: const TextStyle(
                        color: Colors.black38, fontSize: 15),
                  ),
                  onTap: () {
                    if (_isLoggedIn) {
                      _logout();  // If logged in, log out the user
                    } else {
                      Navigator.pushReplacementNamed(
                          context, "/loginscreen");  // Go to login screen
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 85),
            Container(
              height: 170,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey[900]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '3080 Dorchester Road, Niagara Falls, Ontario, L2J 2Z7',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.greenAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '+1 647 470 8577',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.blueAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'info@fishtohome.ca',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/logo.png', width: 75, height: 50),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Searchproduct(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Color(0xFF1051AB),
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
              color: Color(0xFF1051AB),
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
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              CustomColor.accentColor),
        ),
      )
          : Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _Banners(),
                SizedBox(height: 10),
                _categoryWidget(),
                _Typebuild(),
                SizedBox(height: 10),
                _catalogProductsTextWidget(),
                _catalogproductsWidget(),
              ],
            ),
          ),
          Footerwidget(),
        ],
      ),
    );
  }



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

  Widget _categoryWidget() {
    return Column(
      children: <Widget>[
        // Padding widget
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),

          child: Container(

            alignment: Alignment.centerLeft,
            child: Text('Categories') ,

          ),
        ),

        // Horizontal list view
       HorizontalList(),
      ],
    );
  }



  @override
  Widget _Typebuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        _buildTypeButton(context, 'Past Purchase', 'featured'),
        _buildTypeButton(context, 'Top', 'best'),

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


  // @override
  // Widget _CategoriesImages() {
  //   if (productsCategory == null || productsCategory!.isEmpty) {
  //     return Center(child: CircularProgressIndicator());
  //   }
  //
  //   Timer? _timer;
  //
  //   void startTimer() {
  //     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //       if (_currentPage < (productsCategory!.length / 5).ceil() - 1) {
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
  //
  //         height: 200, // Adjust the height according to your needs
  //         child: PageView.builder(
  //           itemCount: (productsCategory!.length / 2).ceil(), // Display 2 products per page
  //           itemBuilder: (BuildContext context, int index) {
  //             int startIndex = index * 2;
  //             int endIndex = startIndex + 2;
  //             return Row(
  //               children: productsCategory!
  //                   .sublist(startIndex, endIndex <= productsCategory!.length ? endIndex : productsCategory!.length)
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
  //                             height: 130,
  //                             decoration: BoxDecoration(
  //                               borderRadius:BorderRadius.circular(20),
  //                               // border: Border.all(
  //                               //   color: Colors.grey.withOpacity(0.5),
  //                               // ),
  //                               // borderRadius: BorderRadius.circular(16),
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
  //                               '${product.name.toString()}',
  //
  //
  //                               style: TextStyle(color: kTextLightColor),
  //                             ),
  //                           ),
  //                           // Padding(
  //                           //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
  //                           //   child: Text(
  //                           //     '\$${product.price ?? 0}',
  //                           //     style: TextStyle(fontWeight: FontWeight.bold),
  //                           //   ),
  //                           // ),
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
                  builder: (context) => CatalogProductScreen(),
                ),
              );
            },


          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget _catalogproductsWidget() {
    // if (catalogProductsList == null || catalogProductsList!.isEmpty) {
    //   return Center(child: Text('No products available')); // Message if no products
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Featured Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
          shrinkWrap: true, // Allows GridView to wrap its content
          itemCount: catalogProductsList!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two products per row
            childAspectRatio: 0.75, // Adjust aspect ratio for product cards
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 10, // Spacing between rows
          ),
          itemBuilder: (context, index) {
            final product = catalogProductsList![index];
            return GestureDetector(
              onTap: () async {
                // Navigate to product detail page
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Productdetail(productId: product.productId.toString()),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          image: DecorationImage(
                            image: product.photo != null
                                ? NetworkImage(product.photo!)
                                : AssetImage('assets/images/noimage.png')
                            as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display product name
                          Text(
                            product.productName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),

                          // Display price or onsale_price
                          if (product.onsale_price != null && product.onsale_price! > 0) ...[
                            // Original Price with strikethrough
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(height: 4),
                            // On-Sale Price
                            Text(
                              '\$${product.onsale_price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ] else ...[
                            // Regular Price when no onsale_price
                            Text(
                              '\$${product.price ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _AccountDeletion(context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('No', style: TextStyle(color: Colors.green)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text('Yes', style: TextStyle(color: Colors.green)),
      onPressed: () {
        Navigator.pop(context); // Close the dialog before starting the process
        _removeAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Confirm', style: TextStyle(fontSize: 18)),
      content: Text('Do you want to remove your account ?', style: TextStyle(fontSize: 13, color: Colors.black)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _removeAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      // Show an alert to the user that they are not logged in
      _showMessage('User not logged in', Colors.red);
      setState(() {
        isLoading = false;
      });
      return;
    }

    String url = ApiUrl.accountDelete;
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'customer_id': customerId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          // Account removed successfully
          _showMessage(responseData['message'] ?? 'Account deleted successfully', Colors.green);

          // Clear user data and navigate to login page
          await prefs.clear();
          Navigator.pushReplacementNamed(context, '/loginscreen');
        } else {
          _showMessage(responseData['message'] ?? 'Account deletion failed', Colors.red);
        }
      } else {
        _showMessage('Failed to remove account. Please try again.', Colors.red);
      }
    } catch (error) {
      _showMessage('An error occurred. Please try again.', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }


}
