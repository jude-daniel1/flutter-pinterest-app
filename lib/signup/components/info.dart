// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_pinterest_clone/home_screen.dart';
import 'package:flutter_pinterest_clone/login/login_screen.dart';
import 'package:flutter_pinterest_clone/widgets/account_check.dart';
import 'package:flutter_pinterest_clone/widgets/reactangular_button.dart';
import 'package:flutter_pinterest_clone/widgets/rectangle_input_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ignore: use_key_in_widget_constructors
class Credentials extends StatefulWidget {
  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final TextEditingController _emailTextController =
      TextEditingController();

  late final TextEditingController _passTextController =
      TextEditingController();

  late final TextEditingController _fullNameController =
      TextEditingController();

  File? imageFile;

  String? imageUrl;

  void _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);

    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);

    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  Future<void> _cropImage(String filePath) async {
    File? croppedImage = await ImageCropper().cropImage(sourcePath: filePath, maxHeight: 300, maxWidth: 300);

    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }
  

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Please Choose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showImageDialog();
            },
            child: CircleAvatar(
                radius: 60,
                backgroundImage: imageFile == null
                    ? const AssetImage("assets/logo1.png")
                    : Image.file(imageFile!).image),
          ),
          const SizedBox(
            height: 10,
          ),
          RectangularInputField(
            hintText: "Enter FullName",
            icon: Icons.person_add,
            obscureText: false,
            textEditingController: _fullNameController,
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
          RectangularButton(
            text: "Create Account",
            press: () async {
              if (imageFile == null) {
                Fluttertoast.showToast(msg: "Please select an Image");
                return;
              }
              try {
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('userImages')
                    .child(DateTime.now().toString() + '.jpg');
                await ref.putFile(imageFile!);
                imageUrl = await ref.getDownloadURL();
                await _auth.createUserWithEmailAndPassword(
                    email: _emailTextController.text.trim().toLowerCase(),
                    password: _passTextController.text.trim());
                final User? user = _auth.currentUser;
                final _uid = user!.uid;
                FirebaseFirestore.instance.collection("users").doc(_uid).set({
                  'id': _uid,
                  'userImage': imageUrl,
                  "name": _fullNameController.text.trim(),
                  "email": _emailTextController.text.trim(),
                  "createdAt": Timestamp.now()
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              } catch (error) {
                Fluttertoast.showToast(msg: "something went wrong!");
                //Fluttertoast.showToast(msg: error.toString());
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
            colors1: Colors.red,
            colors2: Colors.redAccent,
          ),
          AccountCheck(
              login: false,
              press: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              }),
        ],
      ),
    );
  }
}
