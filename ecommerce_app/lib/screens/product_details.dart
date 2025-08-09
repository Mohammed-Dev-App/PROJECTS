import 'package:ecommerce_app/screens/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  Future<void> addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("product_id_${widget.product['id']}", quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.product['title']} added to Cart"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: widget.product['title']),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.product['image'],
                width: double.infinity,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text(
                "\$${widget.product['price'].toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(widget.product["rating"]["rate"].toString()),
                  SizedBox(width: 4),
                  Text(
                    "\$${widget.product["rating"]["count"].toString()} reviews",
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "\$${widget.product['description'].toString()}",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      quantity--;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Text(
                    quantity.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      quantity++;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
