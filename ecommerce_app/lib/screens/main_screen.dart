import 'package:ecommerce_app/screens/pages/home_page.dart';
import 'package:ecommerce_app/screens/pages/shopping_cart.dart';
import 'package:ecommerce_app/screens/pages/users_list.dart';
import 'package:ecommerce_app/services/ecommerce_service.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController = PageController(initialPage: 0);
  int _selected_index = 0;
  List<dynamic> _products = [];
  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  void fetchProducts() async {
    EcommerceService ecommerceService = EcommerceService();
    _products = await ecommerceService.fetchProducts();
    setState(() {
      _products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected_index,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Users List",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selected_index = index;
            pageController.jumpToPage(index);
          });
        },
      ),
      body: PageView(
        controller: pageController,
        children: [
          HomePage(products: _products),
          ShoppingCart(products: _products),
          UsersList(),
        ],
      ),
    );
  }
}
