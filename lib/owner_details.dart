import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:flutter_pinterest_clone/home_screen.dart';
import 'package:flutter_pinterest_clone/widgets/reactangular_button.dart';

// ignore: must_be_immutable
class OwnerDetails extends StatefulWidget {
  String img;
  String userImg;
  String name;
  DateTime date;
  String docId;
  String userId;
  int downloads;
  OwnerDetails(
      {required this.img,
      required this.userImg,
      required this.name,
      required this.date,
      required this.docId,
      required this.userId,
      required this.downloads,
      Key? key})
      : super(key: key);

  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  int? total;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.red,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              iconSize: 22,
                              tooltip: 'Back to Home',
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen()));
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Image.network(
                          widget.img,
                          width: MediaQuery.of(context).size.width,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Owner Information',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.userImg,
                          ),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Uploaded by: " + widget.name,
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat("dd MMMM, yyyy - hh:mm a")
                      .format(widget.date)
                      .toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      "" + widget.downloads.toString(),
                      style: const TextStyle(
                          fontSize: 28.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: RectangularButton(
                      text: "Download",
                      press: (){
                        downloadImage();
                      },
                      colors1: Colors.green,
                      colors2: Colors.lightGreen),
                ),
                FirebaseAuth.instance.currentUser!.uid == widget.userId
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child: RectangularButton(
                            text: "Delete",
                            press: () {
                              FirebaseFirestore.instance
                                  .collection("wallpaper")
                                  .doc(widget.docId)
                                  .delete()
                                  .then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen()));
                              });
                            },
                            colors1: Colors.green,
                            colors2: Colors.lightGreen),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }


  downloadImage() async {
    try {
          // var imageId = await ImageDownloader.downloadImage(widget.img);
          //  if (imageId == null) {
          //         return;
          //   }
          Fluttertoast.showToast(msg: "Image Saved to Gallery");
          total = widget.downloads + 1;
          FirebaseFirestore.instance.collection("wallpaper").doc(widget.docId).update({'downloads': total}).then((value) {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const HomeScreen()));
        });
      } on PlatformException catch (e) {
          print(e);
    }
  }
}
