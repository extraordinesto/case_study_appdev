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

  String? qrData;
  String transactionType = 'IN'; // default

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
              MyTextField(
                hintText: "Item Number",
                controller: itemNumberController,
                prefixicon: null,
                suffixIcon: null,
                validator: (val) => val == "" ? "Please write name" : null,
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
                validator: (val) => val == "" ? "Please write name" : null,
                isObsecure: false,
                keyboardType: null,
                enabled: true,
              ),

              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
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
                  items:
                      <String>['Active', 'Disable'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(height: 10),

              MyTextField(
                hintText: "Description",
                controller: descriptionController,
                prefixicon: null,
                suffixIcon: null,
                validator:
                    (val) => val == "" ? "Please write description" : null,
                isObsecure: false,
                keyboardType: null,
                enabled: true,
              ),

              SizedBox(height: 10),

              MyTextField(
                hintText: "Discount %",
                controller: discountController,
                prefixicon: null,
                suffixIcon: null,
                validator: (val) => val == "" ? "Please write discount" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                enabled: true,
              ),

              SizedBox(height: 10),

              MyTextField(
                hintText: "Quantity",
                controller: stockController,
                prefixicon: null,
                suffixIcon: null,
                validator: (val) => val == "" ? "Please write quantity" : null,
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
                validator:
                    (val) => val == "" ? "Please write Unit Price" : null,
                isObsecure: false,
                keyboardType: TextInputType.number,
                enabled: true,
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: Material(
                  color:
                      Theme.of(context).colorScheme.primary, // Set button color
                  borderRadius: BorderRadius.circular(8), // Set border radius
                  child: InkWell(
                    onTap: () {
                      final itemNumber = itemNumberController.text;
                      final itemName = itemNameController.text;
                      final status = statusController.text;
                      final description = descriptionController.text;
                      final discount = discountController.text;
                      final stock = stockController.text;
                      final unitPrice = unitPriceController.text;

                      if (itemNumber.isNotEmpty &&
                          itemName.isNotEmpty &&
                          status.isNotEmpty &&
                          description.isNotEmpty &&
                          discount.isNotEmpty &&
                          stock.isNotEmpty &&
                          unitPrice.isNotEmpty) {
                        setState(() {
                          qrData = jsonEncode({
                            "itemNumber": itemNumber,
                            "itemName": itemName,
                            "discount": discount,
                            "stock": stock,
                            "unitPrice": unitPrice,
                            "status": status,
                            "description": description,
                            "type": transactionType,
                          });
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill in all fields"),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
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
                        itemNumberController.clear(); // Clear item number
                        itemNameController.clear(); // Clear item name
                        statusController.clear(); // Clear status
                        descriptionController.clear(); // Clear description
                        discountController.clear(); // Clear discount
                        stockController.clear(); // Clear quantity
                        unitPriceController.clear(); // Clear unit price
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
