import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:medicub_vendor/login.dart';

import 'helpers/strings.dart';

class TestScreen extends StatefulWidget {
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  /*here we have a list of OnbordingScreen which we want to have, each OnbordingScreen have a imagePath,title and an desc.
      */
  List<OnbordingData> list = [
    const OnbordingData(
      imageHeight: 450,
      image: AssetImage(
        "assets/images/intro1.png",
      ),
      titleText: Text(
        "A FREE Digital Health \nCard, Just for you!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          fontFamily: Strings.lato,
        ),
      ),
      descPadding: EdgeInsets.all(0),
      descText: Text(""),
    ),
    const OnbordingData(
      imageHeight: 450,
      // imageHeight: 400,
      // imageWidth: 400,
      image: AssetImage("assets/images/intro2.png"),
      titleText: Text(
        "Find Best Hospitals\n Nearby",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: Strings.lato,
            fontSize: 28,
            fontWeight: FontWeight.w500),
      ),
      descText: Text(""),
    ),
    OnbordingData(
        imageHeight: 450,
        image: const AssetImage("assets/images/intro3.png"),
        titleText: const Text(
          "Avail Never Imagined \nDiscounts",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: Strings.lato,
              fontSize: 28,
              fontWeight: FontWeight.w500),
        ),
        descText: MaterialButton(
          elevation: 0,
          color: const Color(0xffF89122),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: (() {}),
          child: const Text(
            "Get Your Digital Health Card Now!",
            style: TextStyle(
                color: Color(0xff000000),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: Strings.latoBold),
          ),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreen(
      gradient: LinearGradient(colors: [
        const Color(0xffF89122).withOpacity(0.22),
        const Color(0xffF89122).withOpacity(0.22),
      ]),
      onbordingDataList: list,
      colors: [Colors.white],
      pageRoute: MaterialPageRoute(builder: (context) => LoginScreen()),
      nextButton: const Text(
        "NEXT",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      lastButton: const Text(
        "Done",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      skipButton: const Text(
        "SKIP",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      selectedDotColor: Colors.orange,
      unSelectdDotColor: Colors.grey,
    );
  }
}
