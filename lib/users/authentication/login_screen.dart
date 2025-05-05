import 'dart:convert';

import 'package:feature_app/api_connection/api_connection.dart';
import 'package:feature_app/components/textfield.dart';
import 'package:feature_app/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:feature_app/users/authentication/signup_screen.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUser() async {
    try {
      var res = await http.post(
        Uri.parse(API.login),
        headers: {
          "Content-Type": "application/json", // This header is necessary
        },
        body: jsonEncode({
          "username": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      if (res.statusCode == 200) {
        var resBodyOfLogIn = jsonDecode(res.body);

        if (resBodyOfLogIn['success'] == true) {
          Fluttertoast.showToast(msg: "Logged-In Successfully.");

          // User userInfo = User.fromJson(resBodyOfLogIn["userData"]);

          //save userinfo to local storage
          Future.delayed(Duration(milliseconds: 2000), () {
            Get.to(DashBoard());
          });
        } else {
          Fluttertoast.showToast(
            msg: "Incorrect Username or Password. \n\t\t\t\t\t\tTry Again.",
          );
        }
      }
    } catch (errorMsg) {
      print("Error ::" + errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: cons.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: height / 2.7,
                    child: Icon(
                      Icons.person,
                      size: 300,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  SizedBox(height: 5),

                  //Label
                  Text(
                    'Welcome to Inventory System',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  SizedBox(height: 25),

                  // Login Form
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // Email
                              MyTextField(
                                hintText: "Username",
                                validator:
                                    (val) =>
                                        val == "" ? "Please write email" : null,
                                controller: emailController,
                                prefixicon: Icon(Icons.email),
                                suffixIcon: null,
                                isObsecure: false,
                                keyboardType: null,
                                enabled: true,
                              ),

                              SizedBox(height: 10),

                              // Password
                              Obx(
                                () => MyTextField(
                                  hintText: "Password",
                                  isObsecure: isObsecure.value,
                                  validator:
                                      (val) =>
                                          val == ""
                                              ? "Please write password"
                                              : null,
                                  controller: passwordController,
                                  prefixicon: Icon(Icons.lock),
                                  suffixIcon: Obx(
                                    () => GestureDetector(
                                      onTap: () {
                                        isObsecure.value = !isObsecure.value;
                                      },
                                      child: Icon(
                                        isObsecure.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  keyboardType: null,
                                  enabled: true,
                                ),
                              ),

                              SizedBox(height: 15),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                child: Material(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        //Validate Email
                                        loginUser();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 16,
                                      ),
                                      child: Center(
                                        // Optional: to center the text
                                        child: Text(
                                          'Log In',
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
                        ),

                        SizedBox(height: 15),

                        // Don't have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                " Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
