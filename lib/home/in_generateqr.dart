// Add this import at the top
import 'dart:convert';

import 'package:feature_app/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InGenerateQRCodePage extends StatefulWidget {
  @override
  _GenerateQRCodePageState createState() => _GenerateQRCodePageState();
}

class _GenerateQRCodePageState extends State<InGenerateQRCodePage> {
  final TextEditingController itemNumberController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController imageURLController = TextEditingController();

  String? qrData;
  String transactionType = 'IN';
  List<Map<String, String>> products = [];

  void addProductToList() {
    final item = {
      "itemNumber": itemNumberController.text,
      "itemName": itemNameController.text,
      "discount": discountController.text,
      "stock": stockController.text,
      "unitPrice": unitPriceController.text,
      "status": statusController.text,
      "description": descriptionController.text,
      "imageURL": imageURLController.text,
      "type": transactionType,
    };

    if (item.values.any((val) => val.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    } else {
      setState(() {
        products.add(item);
        // Clear form after adding
        itemNumberController.clear();
        itemNameController.clear();
        discountController.clear();
        stockController.clear();
        unitPriceController.clear();
        statusController.clear();
        descriptionController.clear();
        imageURLController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (qrData == null) ...[
              MyTextField(
                hintText: "Item Number",
                controller: itemNumberController,
                prefixicon: null,
                suffixIcon: null,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                enabled: true,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Item Name",
                controller: itemNameController,
                prefixicon: null,
                suffixIcon: null,
                keyboardType: null,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                enabled: true,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value:
                    statusController.text.isEmpty
                        ? null
                        : statusController.text,
                hint: Text("Select status"),
                onChanged: (String? newValue) {
                  setState(() {
                    statusController.text = newValue!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items:
                    <String>['Active', 'Disable'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Description",
                controller: descriptionController,
                prefixicon: null,
                suffixIcon: null,
                keyboardType: null,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                enabled: true,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Discount %",
                controller: discountController,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                prefixicon: null,
                suffixIcon: null,
                enabled: true,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Quantity",
                controller: stockController,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                prefixicon: null,
                suffixIcon: null,
                enabled: true,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Unit Price",
                controller: unitPriceController,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                prefixicon: null,
                suffixIcon: null,
                enabled: true,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Image URL",
                controller: imageURLController,
                validator: (val) => val == "" ? "Required" : null,
                isObsecure: false,
                keyboardType: null,
                prefixicon: null,
                suffixIcon: null,
                enabled: true,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: addProductToList,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (products.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              qrData = jsonEncode({"products": products});
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Generate QR Code',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 20),

              if (products.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product["itemName"]!),
                        subtitle: Text(
                          "Qty: ${product["stock"]} - Price: ${product["unitPrice"]}",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              products.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
            ] else ...[
              Center(
                child: QrImageView(
                  data: qrData!,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        qrData = null; // Reset the QR data
                        products.clear(); // Clear the product list
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Center(
                        child: Text(
                          'Back to Form',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
