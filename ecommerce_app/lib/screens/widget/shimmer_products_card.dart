import 'package:flutter/material.dart';

class ShimmerProductsCard extends StatelessWidget {
  const ShimmerProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 150, height: 150, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(height: 20, width: 100, color: Colors.grey[300]),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Container(width: 50, height: 16, color: Colors.grey[300]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
