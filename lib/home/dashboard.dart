import 'package:feature_app/home/display_product.dart';
import 'package:feature_app/home/generateqr.dart';
import 'package:feature_app/home/scan.dart';
import 'package:feature_app/users/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final RxInt _indexNumber = 0.obs;

  final List<Map<String, dynamic>> _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Products",
      "widget": DisplayProduct(),
    },
    {
      "active_icon": Icons.qr_code_scanner,
      "non_active_icon": Icons.qr_code_scanner_outlined,
      "label": "Scan",
      "widget": ScanProduct(),
    },
    {
      "active_icon": Icons.qr_code,
      "non_active_icon": Icons.qr_code_outlined,
      "label": "QR Code",
      "widget": GenerateQRCodePage(),
    },
    {
      "active_icon": Icons.logout,
      "non_active_icon": Icons.logout_outlined,
      "label": "Logout",
      "widget": null, // will be handled manually
    },
  ];

  void _handleNavigation(int index, BuildContext context) {
    if (_navigationButtonsProperties[index]['label'] == 'Logout') {
      // Logout logic
      Get.defaultDialog(
        titlePadding: EdgeInsets.only(top: 15),
        title: "Confirm Logout",
        backgroundColor: Theme.of(context).colorScheme.background,
        confirmTextColor: Theme.of(context).colorScheme.onSecondary,
        middleText: "Are you sure you want to logout?",
        confirm: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextButton(
            onPressed: () {
              Future.delayed(Duration(milliseconds: 1000), () {
                Get.to(LoginScreen()); // or your logout route
              });
            },
            child: Text(
              "Yes",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
        cancel: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "No",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
      );
    } else {
      _indexNumber.value = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          final current = _navigationButtonsProperties[_indexNumber.value];
          return current['widget'] ?? Container(); // fallback for logout
        }),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _indexNumber.value,
          onTap: (value) => _handleNavigation(value, context),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Theme.of(context).colorScheme.onSecondary,
          unselectedItemColor: Theme.of(context).colorScheme.onTertiary,
          backgroundColor: Theme.of(context).colorScheme.background,
          items: List.generate(_navigationButtonsProperties.length, (index) {
            final item = _navigationButtonsProperties[index];
            return BottomNavigationBarItem(
              icon: Icon(item['non_active_icon']),
              activeIcon: Icon(item['active_icon']),
              label: item['label'],
            );
          }),
        ),
      ),
    );
  }
}
