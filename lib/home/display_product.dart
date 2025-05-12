import 'dart:convert';
import 'package:feature_app/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayProduct extends StatefulWidget {
  const DisplayProduct({super.key});

  @override
  State<DisplayProduct> createState() => _DisplayProductState();
}

class _DisplayProductState extends State<DisplayProduct> {
  List productData = [];

  Future<void> getrecord() async {
    try {
      var res = await http.get(Uri.parse(API.product));

      setState(() {
        productData = jsonDecode(res.body);
      });
    } catch (e) {
      print("Error ::" + e.toString());
    }
  }

  @override
  void initState() {
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: productData.length,
        itemBuilder: (context, index) {
          final item = productData[index];
          final id = item["itemNumber"] ?? "0";
          final imagePath = item["imageURL"] ?? "placeholder.jpg";
          final imageUrl =
              imagePath.startsWith('http')
                  ? imagePath
                  : "http://192.168.100.4/Advance_IMS/data/item_images/$id/${Uri.encodeComponent(imagePath)}";
          final itemName = item["itemName"] ?? "Item";
          final stock = item["stock"] ?? "1 pc (500gm)";
          final price = item["unitPrice"] ?? "0";

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product image
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),

                  // Name
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Price
                  Text(
                    "₱$price",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Stock
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Stock: $stock",
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
