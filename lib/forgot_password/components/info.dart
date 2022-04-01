// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_pinterest_clone/login/login_screen.dart';
import 'package:flutter_pinterest_clone/widgets/account_check.dart';
import 'package:flutter_pinterest_clone/widgets/reactangular_button.dart';
import 'package:flutter_pinterest_clone/widgets/rectangle_input_field.dart';

// ignore: use_key_in_widget_constructors
class Credentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final TextEditingController _emailTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              "assets/forget.png",
              width: 250.0,
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
          RectangularButton(
            text: "Send Link",
            press: () async {
              try {
                await _auth.sendPasswordResetEmail(
                    email: _emailTextController.text.trim());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              } catch (error) {
                Fluttertoast.showToast(msg: error.toString());
              }
            },
            colors1: Colors.red,
            colors2: Colors.redAccent,
          ),
          AccountCheck(
              login: true,
              press: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              }),
        ],
      ),
    );
  }
}
