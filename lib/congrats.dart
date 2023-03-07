import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:medicub_vendor/helpers/strings.dart';
import 'package:medicub_vendor/homescreen.dart';

class BusinessVerificationScreen extends StatefulWidget {
  String? name;
  String? usrUniqueId;
  BusinessVerificationScreen({super.key, this.name, this.usrUniqueId});

  @override
  State<BusinessVerificationScreen> createState() =>
      _BusinessVerificationScreenState();
}

class _BusinessVerificationScreenState
    extends State<BusinessVerificationScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Strings.kBackgroundcolor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height / 20,
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 20, top: 10),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: Strings.kWhitecolor,
          //         borderRadius: BorderRadius.circular(0.6)),
          //     child: IconButton(
          //       icon: Icon(
          //         Icons.arrow_back,
          //         size: 30,
          //       ),
          //       color: Strings.kIconcolor,
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(
            height: height / 4,
          ),
          Center(
            child: Image.asset(
              "assets/images/conformed.png",
              height: height / 5.0,
              width: width / 1.3,
            ),
          ),
          SizedBox(
            height: height / 80,
          ),
          Center(
            child: Text(
              "Congrats!!",
              style: TextStyle(
                  color: Strings.kSecondarycolor,
                  fontFamily: Strings.lato,
                  fontWeight: FontWeight.w700,
                  fontSize: 21),
            ),
          ),
          SizedBox(
            height: height / 80,
          ),
          Center(
            child: Text(
              "You have Got FREE Digital Health Card \nyou Have Successfully Registered",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Strings.kSecondarycolor,
                  fontFamily: Strings.lato,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
