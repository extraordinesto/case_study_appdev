import 'dart:convert';
import 'dart:ui';
import 'package:feature_app/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanning = true;
  final MobileScannerController cameraController = MobileScannerController();
  List<Map<String, dynamic>> scannedProducts = [];

  Future<void> processTransaction(Map<String, dynamic> qrdata) async {
    try {
      final response = await http.post(
        Uri.parse(API.transaction),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(qrdata),
      );

      if (response.statusCode == 200) {
        setState(() {
          scannedProducts.add(qrdata);
        });
        final result = jsonDecode(response.body);
        _showDialog(
          'Success',
          result['message'] ?? 'Transaction successful',
          scannedItem: qrdata,
        );
      } else {
        final error = jsonDecode(response.body);
        String errorMessage = error['message'] ?? 'Something went wrong';

        if (errorMessage == 'Item already exists') {
          errorMessage = 'The item already exists in the inventory.';
        } else if (errorMessage == 'Insufficient stock') {
          errorMessage = 'Not enough stock available.';
        }

        _showDialog('Failed', errorMessage, scannedItem: qrdata);
      }
    } catch (e) {
      _showDialog('Error', 'Failed to connect to the server.\n$e');
    }
  }

  @override
  void initState() {
    super.initState();
    cameraController.start();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _showDialog(
    String title,
    String content, {
    Map<String, dynamic>? scannedItem,
  }) {
    final extraInfo =
        scannedItem != null
            ? '\n\nScanned Item:\n'
                '• Item No: ${scannedItem['itemNumber']}\n'
                '• Name: ${scannedItem['itemName']}\n'
                '• Qty: ${scannedItem['quantity']}\n'
                '• Price: ₱${scannedItem['unitPrice']}\n'
                '• Type: ${scannedItem['type']}'
            : '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(content + extraInfo),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => isScanning = true);
                  cameraController.start();
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanBoxSize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              if (!isScanning) return;
              final barcode = capture.barcodes.first;
              final raw = barcode.rawValue;

              if (raw == null) return;

              try {
                final Map<String, dynamic> parsed = Map<String, dynamic>.from(
                  jsonDecode(raw),
                );

                if (parsed.containsKey('type')) {
                  setState(() => isScanning = false);
                  cameraController.stop();
                  await processTransaction(parsed);
                } else {
                  _showDialog('Invalid QR', 'Missing transaction type.');
                }
              } catch (e) {
                _showDialog('Invalid Data', 'QR Code is not valid JSON.\n$e');
              }
            },
          ),

          // Dimmed overlay with scan box
          Center(
            child: Stack(
              children: [
                // Blur outside the box
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black54,
                      ),
                      Center(
                        child: Container(
                          width: scanBoxSize,
                          height: scanBoxSize,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Border for scan box
                Center(
                  child: Container(
                    width: scanBoxSize,
                    height: scanBoxSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
