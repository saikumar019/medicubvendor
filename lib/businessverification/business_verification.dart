import 'package:flutter/material.dart';

import 'package:medicub_vendor/helpers/strings.dart';

class BusinessVerification extends StatefulWidget {
  const BusinessVerification({super.key});

  @override
  State<BusinessVerification> createState() => _BusinessVerificationState();
}

class _BusinessVerificationState extends State<BusinessVerification> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffF3F4F4),
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(33.0),
              bottomRight: Radius.circular(33.0),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Strings.kPrimarycolor,
          automaticallyImplyLeading: false,
          title: const Text(
            "Business Verification",
            style: TextStyle(
                color: Strings.kBlackcolor,
                fontWeight: FontWeight.w700,
                fontFamily: Strings.lato,
                fontSize: 18),
          ),
          toolbarHeight: height / 10,
          elevation: 2,
          shadowColor: Strings.kBlackcolor.withOpacity(0.16),
        ),
        body: Column(
          children: [
            SizedBox(
              height: height / 6,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 9),
              child: Center(child: Image.asset("assets/images/business.png")),
            ),
            SizedBox(
              height: height / 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 9),
              child: const Center(
                child: Text(
                  "Pls Wait for Us to Verify your Business very soon Our Executive will be Calling",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Strings.kBlackcolor,
                      fontWeight: FontWeight.w700,
                      fontFamily: Strings.lato,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
