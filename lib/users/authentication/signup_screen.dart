import 'dart:convert';

import 'package:feature_app/api_connection/api_connection.dart';
import 'package:feature_app/components/textfield.dart';
import 'package:feature_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:feature_app/users/authentication/login_screen.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {'username': emailController.text.trim()},
      );
      if (res.statusCode == 200) {
        // From FLutter app the connection success with API
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if (resBodyOfValidateEmail['usernameFound'] == true) {
          Fluttertoast.showToast(
            msg: 'Username is already use. Try anothe username',
          );
        } else {
          //register & save new user record to database
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // SignUp Save to database
  registerAndSaveUserRecord() async {
    User userModel = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );

      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);

        if (resBodyOfSignUp['success'] == true) {
          Fluttertoast.showToast(msg: "Sign Up Successfully.");

          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: "Error Occured. Try Again.");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
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
                      Icons.login,
                      size: 230,
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

                  // Sign Up Form
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // Name
                              MyTextField(
                                hintText: "Name",
                                controller: nameController,
                                prefixicon: Icon(
                                  Icons.person,
                                  color: Colors.black45,
                                ),
                                suffixIcon: null,
                                validator:
                                    (val) =>
                                        val == "" ? "Please write name" : null,
                                isObsecure: false,
                              ),

                              SizedBox(height: 10),

                              // Email
                              MyTextField(
                                hintText: "Email",
                                controller: emailController,
                                prefixicon: Icon(
                                  Icons.email,
                                  color: Colors.black45,
                                ),
                                suffixIcon: null,
                                validator:
                                    (val) =>
                                        val == "" ? "Please write email" : null,
                                isObsecure: false,
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
                                  prefixicon: Icon(
                                    Icons.lock,
                                    color: Colors.black45,
                                  ),
                                  suffixIcon: Obx(
                                    () => GestureDetector(
                                      onTap: () {
                                        isObsecure.value = !isObsecure.value;
                                      },
                                      child: Icon(
                                        isObsecure.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
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
                                        validateUserEmail();
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
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
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

                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                " Log In",
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
