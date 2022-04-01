import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  const HeadText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0 / 2),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          const Text(
            "Welcome to Pinterst Clone",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Create Account",
            style: TextStyle(
                fontSize: 36,
                color: Colors.white30,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
