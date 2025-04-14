import 'package:feature_app/users/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:feature_app/theme/darkmode.dart';
import 'package:feature_app/theme/lightmode.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feature AppDev',
      home: LoginScreen(),
      theme: lightmode,
      darkTheme: darkmode,
    );
  }
}
