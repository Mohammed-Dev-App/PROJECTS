import 'package:ecommerce_app/screens/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart extends StatefulWidget {
  final List products;
  const ShoppingCart({super.key, required this.products});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    _getCartsItems();
    super.initState();
  }

  List<Map<String, dynamic>> carts_item = [];
  Future<void> _getCartsItems() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    carts_item =
        keys.where((key) => key.startsWith("product_id")).map((e) {
          final productId = e.split('_')[2];

          final quantity = prefs.getInt(e);
          final product = widget.products.firstWhere(
            (element) => element['id'].toString() == productId,
          );
          return {
            'id': productId,
            'title': product['title'],
            'image': product['image'],
            'price': product['price'],
            'quantity': quantity,
          };
        }).toList();
    setState(() {});
  }

  Future<void> updateQuantity(String productId, int new_quantity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('product_id_$productId', new_quantity);
    _getCartsItems();
  }

  Future<void> deleteQuantity(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('product_id_$productId');
    _getCartsItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Shopping Cart"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = carts_item[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      item['image'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['price'].toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  updateQuantity(
                                    item['id'],
                                    item['quantity'] - 1,
                                  );
                                },

                                icon: Icon(Icons.remove),
                              ),

                              Text("Quantity ${item['quantity'].toString()}"),

                              IconButton(
                                onPressed: () {
                                  updateQuantity(
                                    item['id'],
                                    item['quantity'] + 1,
                                  );
                                },

                                icon: Icon(Icons.add),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  deleteQuantity(item['id']);
                                },

                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: carts_item.length,
        ),
      ),
    );
  }
}
