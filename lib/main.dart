// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:medicub_vendor/businessverification/qr_scanner.dart';

import 'package:medicub_vendor/homescreen.dart';
import 'package:medicub_vendor/intro.dart';
import 'package:medicub_vendor/login.dart';
import 'package:medicub_vendor/my_appointment.dart';
import 'package:medicub_vendor/profile/basic_details.dart';
import 'package:medicub_vendor/profile/profile_completion.dart';
import 'package:medicub_vendor/scaned_appointments.dart';
import 'package:medicub_vendor/splash_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'businessverification/business_verification.dart';
import 'helpers/strings.dart';

int? initScreen;

// String? name;
String? user;
// String? isProfile;
String? isSessionId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  isSessionId = preferences.getString("sessionId");

  user = preferences.getString('user');

  initScreen = preferences.getInt("initScreen");

  await preferences.setInt('initScreen', 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String? name;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      // home: SplashScreen(),
      initialRoute: getRoute(),
      routes: {
        'splash': (context) => SplashScreen(),
        'myHome': (context) => const MyHomePage(),
        'login': (context) => const LoginScreen(),
        'scan': (context) => BasicDetails(),
        // 'dash': (context) => DashBoardScreen()
      },
    );
  }

  String getRoute() {
    if (user == null) {
      if (initScreen == 0 || initScreen == null) {
        return "splash";
      } else {
        return "splash";
      }
    } else {
      if (user != null && isSessionId != null) {
        return "myHome";
      } else {
        return "splash";
      }
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  String? isProfileCompleted;
  String? userActiveStatus;
  String? uniqueId;
  String? sessionId;
  Future<void> getUniqueUserId() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    setState(() {
      uniqueId = prefer.getString('user');
      sessionId = prefer.getString('sessionId');
    });
    getUser();
  }

  @override
  void initState() {
    getUniqueUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
        ),
        child: Center(
            child: Image.asset(
          "assets/images/jeevan.png",
          height: height / 4,
          width: width / 2,
        )));
  }

  Future<void> getUser() async {
    try {
      var url = 'http://jeevanraksha.co/API/p_byid';

      var data = {
        'partner_unique_id': user,
        'session_unique_id': isSessionId,
      };

      var response = await post(Uri.parse(url), body: data);

      if (response.statusCode == 200) {
        var message = response.body;

        var users = jsonDecode(message);

        var isP = users["is_profile_completed"];
        var isU = users["account_status"];

        setState(() {
          isProfileCompleted = isP;
          userActiveStatus = isU;
        });
        if (isProfileCompleted == "1" && userActiveStatus == "1") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else if ((isProfileCompleted == "1") && (userActiveStatus == "0")) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BusinessVerification()));
        } else if ((isProfileCompleted == "0") && (userActiveStatus == "0")) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else if (response.statusCode == 403) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      // Flushbar(
      //   flushbarPosition: FlushbarPosition.TOP,
      //   titleColor: Strings.kBlackcolor,
      //   messageColor: Strings.kBlackcolor,
      //   backgroundColor: Colors.white,
      //   leftBarIndicatorColor: Strings.kPrimarycolor,
      //   title: "Hey",
      //   message: "No Internet Connection",
      //   duration: const Duration(seconds: 3),
      // ).show(context);
    }
  }
}
