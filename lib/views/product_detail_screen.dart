import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Image.asset(product.imageUrl),
          SizedBox(height: 10),
          Text(product.description),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Proses penjualan, tambahkan logika total jual di sini
            },
            child: Text('Tambah ke Keranjang'),
          ),
        ],
      ),
    );
  }
}
