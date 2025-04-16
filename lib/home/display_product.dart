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
    // TODO: implement initState
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: productData.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(productData[index]["itemName"]),
              subtitle: Text(productData[index]["stock"]),
            ),
          );
        },
      ),
    );
  }
}
