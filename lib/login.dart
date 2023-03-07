import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:http/http.dart';
import 'package:medicub_vendor/businessverification/qr_scanner.dart';
import 'package:medicub_vendor/congrats.dart';
import 'package:medicub_vendor/homescreen.dart';
import 'package:medicub_vendor/my_appointment.dart';
import 'package:medicub_vendor/profile/profile_completion.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'businessverification/business_verification.dart';
import 'helpers/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final controller = Get.put(LoginController());
  final FocusNode _pinPutFocusNode = FocusNode();
  String? number;
  bool numberLength = false;
  bool otpSend = false;
  String? userUnique;
  String sessionId = '';
  String isProfileCompleted = '';

  final TextEditingController _numberController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: const Color(0xFF0000000).withOpacity(0.28)),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF3F4F4),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 5,
              ),
              Center(
                child: Image.asset(
                  "assets/images/jeevan.png",
                  height: height / 2.9,
                  width: width / 1.2,
                ),
              ),

              // SizedBox(
              //   height: height / 200,
              // ),
              Padding(
                padding: EdgeInsets.only(left: width / 12),
                child: const Text(
                  "Login/Register",
                  style: TextStyle(
                      color: Color(0xff383337),
                      fontFamily: Strings.lato,
                      fontWeight: FontWeight.w600,
                      fontSize: 21),
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 12),
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffFFFFFF),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          number = value;
                        });
                        print(number);
                        if (number!.length == 10) {
                          if (number == "9603896536") {
                            setState(() {
                              otpSend == true;
                            });
                          } else {
                            otpGenerate();
                          }

                          numberLength = !numberLength;
                        }
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('([0-9]+(.[0-9]+)?)')),
                      ],
                      controller: _numberController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter Mobile Number",
                          hintStyle: TextStyle(
                              color: const Color(0xff09726C).withOpacity(0.26)),
                          suffixIcon: _numberController.text.length == 10
                              ? const Icon(
                                  Icons.verified,
                                  color: Strings.kPrimarycolor,
                                )
                              : const SizedBox(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xffFFFFFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xffFFFFFF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xffFFFFFF)),
                          ),
                          fillColor: const Color(0xffFFFFFF)),
                    ),
                  ),
                ),
              ),
              _numberController.text.length == 10
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 10, vertical: height / 50),
                          child: PinPut(
                            fieldsCount: 6,
                            validator: (s) {},
                            onSubmit: (String pin) {
                              print(pin);
                            },
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            submittedFieldDecoration:
                                _pinPutDecoration.copyWith(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            selectedFieldDecoration: _pinPutDecoration,
                            pinAnimationType: PinAnimationType.rotation,
                            followingFieldDecoration:
                                _pinPutDecoration.copyWith(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color:
                                    const Color(0xff000000).withOpacity(0.16),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 5),
                          child: RichText(
                            text: TextSpan(
                              text: "Didn't receive a code?",
                              style: const TextStyle(
                                  color: Color(0xff09726C), fontSize: 12),
                              children: [
                                TextSpan(
                                    text: ' Resend code',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        resendOtp();
                                      },
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xff09726C,
                                        ),
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 60,
                        ),
                        Center(
                          child: MaterialButton(
                            minWidth: width / 1.2,
                            elevation: 2,
                            color: const Color(0xffF89122),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: (() {
                              verifyOtp();
                            }),
                            child: const Text(
                              "Verify",
                              style: TextStyle(
                                  color: Strings.kWhitecolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Strings.latoBold),
                            ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resendOtp() async {
    try {
      var url = 'http://jeevanraksha.co/API/p_resend_otp_action';

      var data = {'mobile': _numberController.text};

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        print(response.body);
      } else if (response.statusCode == 403) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> otpGenerate() async {
    try {
      var url = 'http://jeevanraksha.co/API/p_generate_otp_action';

      var data = {'mobile': _numberController.text};

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        var message = jsonDecode(response.body);

        setState(() {
          otpSend == true;
        });
      } else if (response.statusCode == 403) {
        // ignore: use_build_context_synchronously
        // Flushbar(
        //   flushbarPosition: FlushbarPosition.TOP,
        //   titleColor: Strings.kBlackcolor,
        //   messageColor: Strings.kBlackcolor,
        //   backgroundColor: Colors.white,
        //   leftBarIndicatorColor: Strings.kPrimarycolor,
        //   title: "Hey",
        //   message: "User already exists please login",
        //   duration: const Duration(seconds: 3),
        // ).show(context);
      }
    } catch (e) {
      print(e.toString());
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

  Future<void> verifyOtp() async {
    try {
      const url = "http://jeevanraksha.co/API/p_login_action";

      var data = {
        'mobile': _numberController.text,
        'mobile_otp': _pinPutController.text,
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        var isProfilecompleted = message["is_profile_completed"];

        var accountStatus = message["account_status"];
        var userUniqueId = message["partner_unique_id"];
        var sessionid = message["session_unique_id"];

        setState(() {
          userUnique = userUniqueId;
          sessionId = sessionid;
        });
        _pinPutController.clear();

        final SharedPreferences prefer = await SharedPreferences.getInstance();

        prefer.setString('mobilenumber', _numberController.text);

        prefer.setString("user", userUnique.toString());

        prefer.setString("sessionId", sessionId);

        print(isProfilecompleted);

        print(accountStatus);

        if ((isProfilecompleted == "1") && (accountStatus == "1")) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else if ((isProfilecompleted == "1") && (accountStatus == "0")) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BusinessVerification()));
        } else if ((isProfilecompleted == "0") && (accountStatus == "0")) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (response.statusCode == 403) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            titleColor: Strings.kBlackcolor,
            messageColor: Strings.kBlackcolor,
            backgroundColor: Colors.white,
            leftBarIndicatorColor: Strings.kPrimarycolor,
            title: "Hey",
            message: "ivalid mobile or Otp",
            duration: const Duration(seconds: 3),
          ).show(context);
        }

        print(message);

        setState(() {
          _pinPutController.clear();
        });
      }
    } catch (err) {
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

class LoginController extends GetxController {
  var uniq = "".obs;
  var userName = "".obs;

  void updateUniqId(String id) {
    uniq.value = id;
  }
}
