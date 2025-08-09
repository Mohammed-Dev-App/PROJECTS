import 'package:ecommerce_app/screens/product_details.dart';
import 'package:ecommerce_app/screens/widget/custom_appbar.dart';
import 'package:ecommerce_app/screens/widget/product_card.dart';
import 'package:ecommerce_app/screens/widget/shimmer_products_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  final List<dynamic> products;
  const HomePage({super.key, required this.products});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> cateogries = [
    'All',
    "men's clothing",
    "women's clothing",
    "electronics",
    "jewelery",
  ];
  String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "E-commerce App"),
      body: Column(
        children: [
          SizedBox(height: 15),
          widget.products.isEmpty
              ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder:
                        (context, index) => GestureDetector(
                          onTap: () {
                            selectedCategory = cateogries[index];
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.deepPurple),
                            ),
                            width: 100,
                          ),
                        ),
                  ),
                ),
              )
              : SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cateogries.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = cateogries[index];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedCategory == cateogries[index]
                                  ? Colors.deepPurple
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepPurple),
                        ),
                        child: Text(
                          cateogries[index],
                          style: TextStyle(
                            color:
                                selectedCategory == cateogries[index]
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child:
                  widget.products.isEmpty
                      ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ShimmerProductsCard();
                          },
                        ),
                      )
                      : ListView.builder(
                        itemCount: widget.products.length,
                        itemBuilder: (context, index) {
                          final product = widget.products[index];
                          if (selectedCategory == 'All' ||
                              selectedCategory == product['category']) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetails(
                                        product: widget.products[index],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: ProductCard(
                                product: widget.products[index],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
