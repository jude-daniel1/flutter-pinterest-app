// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_pinterest_clone/forgot_password/forget_password_screen.dart';
import 'package:flutter_pinterest_clone/home_screen.dart';
import 'package:flutter_pinterest_clone/signup/signup_screen.dart';
import 'package:flutter_pinterest_clone/widgets/account_check.dart';
import 'package:flutter_pinterest_clone/widgets/reactangular_button.dart';
import 'package:flutter_pinterest_clone/widgets/rectangle_input_field.dart';

// ignore: use_key_in_widget_constructors
class Credentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final TextEditingController _emailTextController =
      TextEditingController();
  late final TextEditingController _passTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/logo1.png"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RectangularInputField(
            hintText: "Enter EMail",
            icon: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailTextController,
          ),
          const SizedBox(
            height: 30.0 / 2,
          ),
          RectangularInputField(
            hintText: "Enter Password",
            icon: Icons.lock,
            obscureText: true,
            textEditingController: _passTextController,
          ),
          const SizedBox(
            height: 30.0 / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgetPasswordScreen()));
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
          RectangularButton(
            text: "Login",
            press: () async {
              try {
                await _auth.signInWithEmailAndPassword(
                    email: _emailTextController.text.trim().toLowerCase(),
                    password: _passTextController.text.trim());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              } catch (error) {
                Fluttertoast.showToast(msg: "email or password incorrect");
                // Fluttertoast.showToast(msg: error.toString());
              }
            },
            colors1: Colors.red,
            colors2: Colors.redAccent,
          ),
          AccountCheck(
              login: true,
              press: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()));
              }),
        ],
      ),
    );
  }
}
