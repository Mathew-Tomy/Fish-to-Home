import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footerwidget extends StatefulWidget {
  const Footerwidget({Key? key}) : super(key: key);

  @override
  _FooterwidgetState createState() => _FooterwidgetState();
}

class _FooterwidgetState extends State<Footerwidget> {
  final List<String> routeNames = ['/dashboard', '/cart', '/wishlist', '/order']; // Define your route names
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Footer background color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Subtle shadow for depth
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconButton(Icons.home, 'Home', 0),
            _buildIconButton(Icons.shopping_cart, 'Cart', 1),
            _buildIconButton(Icons.favorite, 'Wishlist', 2),
            _buildIconButton(Icons.assignment, 'Orders', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, String label, int index) {
    bool isSelected = currentSelectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentSelectedIndex = index;
        });
        Navigator.pushNamed(context, routeNames[index]);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: isSelected ? Color(0xFF1051AB) : Colors.grey, // Highlight selected icon
            size: 28,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Color(0xFF1051AB) : Colors.grey, // Highlight selected text
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
