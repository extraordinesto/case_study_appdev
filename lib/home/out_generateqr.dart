import 'dart:convert';
import 'package:feature_app/api_connection/api_connection.dart';
import 'package:feature_app/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class OutGenerateQRCodePage extends StatefulWidget {
  @override
  _GenerateQRCodePageState createState() => _GenerateQRCodePageState();
}

class _GenerateQRCodePageState extends State<OutGenerateQRCodePage> {
  TextEditingController customerIDController = TextEditingController();
  TextEditingController itemNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();

  String? qrData;
  String transactionType = 'OUT';
  String? selectedCustomer;
  String? selectedItem;

  List customerData = [];
  List itemData = [];
  List<Map<String, String>> products = []; // List to store multiple products

  Future<void> getrecord() async {
    try {
      var customerRes = await http.get(Uri.parse(API.customer));
      var itemRes = await http.get(Uri.parse(API.product));

      setState(() {
        customerData = jsonDecode(customerRes.body);
        itemData = jsonDecode(itemRes.body);
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

  void addProductToList() {
    final item = {
      "itemNumber": itemNumberController.text,
      "itemName": itemNameController.text,
      "discount": discountController.text,
      "quantity": quantityController.text,
      "unitPrice": unitPriceController.text,
      "customerID": customerIDController.text,
      "customerName": customerNameController.text,
      "type": transactionType,
    };

    if (item.values.any((val) => val.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    } else {
      setState(() {
        products.add(item); // Add the product to the list
        itemNumberController.clear();
        itemNameController.clear();
        discountController.clear();
        quantityController.clear();
        unitPriceController.clear();
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
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (qrData == null) ...[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Customer Name',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value:
                    selectedCustomer?.isNotEmpty == true
                        ? selectedCustomer
                        : null,
                items:
                    customerData.map<DropdownMenuItem<String>>((customer) {
                      final name = customer['fullName'] ?? 'Unnamed';
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCustomer = value ?? '';
                    customerNameController.text = selectedCustomer!;

                    // Find the selected customer by fullName and get the ID
                    final selectedCustomerData = customerData.firstWhere(
                      (customer) => customer['fullName'] == selectedCustomer,
                      orElse: () => null,
                    );

                    if (selectedCustomerData != null) {
                      customerIDController.text =
                          selectedCustomerData['customerID'].toString();
                    }
                  });
                },
              ),

              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Item Name',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: selectedItem?.isNotEmpty == true ? selectedItem : null,
                items:
                    itemData.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['itemName'],
                        child: Text(item['itemName']),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value ?? '';
                    itemNameController.text = selectedItem!;

                    // Find the selected item
                    final selectedItemData = itemData.firstWhere(
                      (item) => item['itemName'] == selectedItem,
                      orElse: () => null,
                    );

                    if (selectedItemData != null) {
                      discountController.text =
                          selectedItemData['discount'].toString();
                      unitPriceController.text =
                          selectedItemData['unitPrice'].toString();
                      itemNumberController.text =
                          selectedItemData['itemNumber'].toString();
                    }
                  });
                },
              ),

              SizedBox(height: 10),

              MyTextField(
                hintText: "Discount %",
                controller: discountController,
                prefixicon: null,
                suffixIcon: null,
                validator:
                    (val) => val == "" ? "Please write description" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                enabled: false,
              ),

              SizedBox(height: 10),

              MyTextField(
                hintText: "Quantity",
                controller: quantityController,
                prefixicon: null,
                suffixIcon: null,
                validator: (val) => val == "" ? "Please write discount" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                enabled: true,
              ),

              SizedBox(height: 10),

              MyTextField(
                hintText: "Unit Price",
                controller: unitPriceController,
                prefixicon: null,
                suffixIcon: null,
                validator: (val) => val == "" ? "Please write quantity" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                enabled: false,
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: addProductToList, // Add product to list
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
                          "Qty: ${product["quantity"]} - Price: ${product["unitPrice"]}",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              products.removeAt(
                                index,
                              ); // Remove product from the list
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
                        qrData = null;
                        products.clear();
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
