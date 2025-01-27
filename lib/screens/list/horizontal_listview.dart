import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:glitzy/modals/Category_modal.dart';
import 'category_product_list.dart';
import 'package:glitzy/restAPI/API.dart';
class HorizontalList extends StatefulWidget {
  const HorizontalList({Key? key}) : super(key: key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  bool isLoading = true;
  List<Categorylistmodal> _categorys = [];

  @override
  void initState() {
    super.initState();
    _categoryAPI();
  }

  _categoryAPI() async {
    // Start API call without setting the loading state globally
    String url = ApiUrl.categories;
    print(url);

    try {
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> productList = responseData['products'];

        if (productList.isNotEmpty) {
          setState(() {
            _categorys = productList
                .map((data) => Categorylistmodal.fromJson(data))
                .toList();
            print('First category name: ${_categorys![0].names}');
          });
        } else {
          print('Product detail not available');
        }
      } else {
        print('Contact admin');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    } finally {
      // Ensure loading state is false regardless of success or error
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0, // Adjust height as needed
      child: isLoading
          ? Center(child: CircularProgressIndicator()) // Visual loading indicator
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categorys.length,
        itemBuilder: (context, index) {
          Categorylistmodal cat = _categorys[index];
          return CategoryItem(
            category: cat,
            onTap: () {
              // Navigate to CategoryProduct screen when category is tapped
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
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Categorylistmodal category;
  final VoidCallback onTap;

  const CategoryItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 15),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30, // Adjust size as needed
              backgroundImage: NetworkImage(category.photo.toString()),
            ),
            SizedBox(height: 4), // Add some spacing
            Text(category.names.toString(), style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}