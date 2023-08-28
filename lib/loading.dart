import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/screen_background.jpg'),
                    fit: BoxFit.cover)),
      //color:Color.fromARGB(255, 76, 224, 226),
      child: const Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 100
        ),
      ),
    );
  }
}