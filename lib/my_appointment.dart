import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:medicub_vendor/businessverification/upload_bills.dart';
import 'package:medicub_vendor/login.dart';

import 'package:medicub_vendor/profile/upload_image.dart';
import 'package:medicub_vendor/scaned_appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/strings.dart';
import 'profile/updateprofile/update_profilecompletion.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({
    super.key,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List todayAppointments = [];
  List pickedDateAppointments = [];

  var _selectedDate;
  var selectedDate;
  var userData;
  bool isVisible = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String _scanBarcode = '';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    _movement();
  }

  void _movement() {
    if (_scanBarcode.isNotEmpty) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScannedAppointment(dummy: _scanBarcode)));
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  Future<void> appointmentList() async {
    try {
      var url = 'http://jeevanraksha.co/API/p_appointment';

      var data = {
        'partner_unique_id': uniqId,
        'session_unique_id': isSessionId,
      };

      var response = await post(Uri.parse(url), body: data);

      print(uniqId);

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        setState(() {
          todayAppointments = message["PartnersTodaysAppointments"];
        });
        print(todayAppointments);
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String? page;
  String? uniqId;
  String? isSessionId;
  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");

      isSessionId = pref.getString("sessionId");
    });
    getUser();
  }

  var UserprofileData;
  var userImage;

  @override
  void initState() {
    getValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return false;
      },
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height / 10,
                  ),
                  userImage != null
                      ? Padding(
                          padding: EdgeInsets.only(left: width / 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Strings.kPrimarycolor,
                                child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage:
                                        NetworkImage(userImage.toString())),
                              ),
                              SizedBox(
                                width: width / 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UploadImage()),
                                  );
                                },
                                child: const Text(
                                  "Change Profile",
                                  style:
                                      TextStyle(color: Strings.kPrimarycolor),
                                ),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(left: width / 20),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 60,
                                backgroundColor: Strings.kPrimarycolor,
                                child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage: NetworkImage(
                                        "http://jeevanraksha.co/public/images/vendor.jpg")),
                              ),
                              SizedBox(
                                width: width / 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UploadImage()),
                                  );
                                },
                                child: const Text(
                                  "Change Profile",
                                  style:
                                      TextStyle(color: Strings.kPrimarycolor),
                                ),
                              )
                            ],
                          ),
                        ),
                  SizedBox(
                    height: height / 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfileCompletion()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 19),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/svg/profile.svg"),
                            SizedBox(
                              width: width / 80,
                            ),
                            Text(
                              "My Account",
                              style: TextStyle(
                                  color:
                                      const Color(0xff1C1C1C).withOpacity(0.6),
                                  fontFamily: Strings.lato,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: height / 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 19),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/svg/help.svg"),
                            SizedBox(
                              width: width / 80,
                            ),
                            Text(
                              "Help",
                              style: TextStyle(
                                  color:
                                      const Color(0xff1C1C1C).withOpacity(0.6),
                                  fontFamily: Strings.lato,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: height / 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        logoutHome();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen()),
                            (Route<dynamic> route) => false);
                        // Navigator.popUntil(context, ModalRoute.withName("/transition1"));

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MyProfile()),
                        // );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 19),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/svg/logout.svg"),
                            SizedBox(
                              width: width / 80,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  color:
                                      const Color(0xff1C1C1C).withOpacity(0.6),
                                  fontFamily: Strings.lato,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
        backgroundColor: Strings.kBackgroundcolor,
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(33.0),
              bottomRight: Radius.circular(33.0),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          // automaticallyImplyLeading: false,
          backgroundColor: Strings.kPrimarycolor,
          title: const Text(
            "My Appointments",
            style: TextStyle(
                color: Strings.kBlackcolor,
                fontWeight: FontWeight.w700,
                fontFamily: Strings.lato,
                fontSize: 18),
          ),
          toolbarHeight: height / 10,
          elevation: 2,
          shadowColor: Strings.kBlackcolor.withOpacity(0.16),
          actions: [
            IconButton(
              onPressed: () {
                scanQR();
              },
              icon: const Icon(Icons.qr_code_scanner),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: width / 20),
                    child: MaterialButton(
                        color: Strings.kPrimarycolor,
                        onPressed: (() async {
                          await _pickDateDialog();
                        }),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.filter_list),
                            Text(" Filter"),
                          ],
                        )),
                  ),
                ],
              ),
              isVisible == false
                  ? const Padding(
                      padding: EdgeInsets.only(left: 20, top: 9, bottom: 9),
                      child: Text(
                        "Todays",
                        style: TextStyle(
                            color: Strings.kBlackcolor,
                            fontWeight: FontWeight.w500,
                            fontFamily: Strings.lato,
                            fontSize: 18),
                      ),
                    )
                  : const SizedBox(),
              isVisible == false
                  ? todayAppointments.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          itemCount: todayAppointments.length,
                          itemBuilder: ((context, index) {
                            var address =
                                jsonDecode(todayAppointments[index]["address"]);

                            var contacts = jsonDecode(
                                todayAppointments[index]["contact_details"]);
                            print(contacts);

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Strings.kWhitecolor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if ((todayAppointments[index]
                                                        ["status"] ==
                                                    "0") ||
                                                todayAppointments[index]
                                                        ["status"] ==
                                                    "1") {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UploadImages(
                                                            appointMentUnique:
                                                                todayAppointments[
                                                                        index][
                                                                    "appointment_unique_id"],
                                                          )));
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor:
                                                    Strings.kPrimarycolor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: CircleAvatar(
                                                    radius: 35,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            todayAppointments[
                                                                    index]
                                                                ["image_url"]),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    todayAppointments[index]
                                                        ["name"],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Strings
                                                            .kBlackcolor),
                                                  ),

                                                  todayAppointments[index]
                                                              ["status"] ==
                                                          "1"
                                                      ? Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              "Attended",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            SizedBox(
                                                              width: width / 10,
                                                            ),
                                                            Text(
                                                              "Amount: ${todayAppointments[index]["total_amount"]}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  todayAppointments[index]
                                                              ["status"] ==
                                                          "0"
                                                      ? const Text(
                                                          "Pending",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color: Strings
                                                                  .kPrimarycolor),
                                                        )
                                                      : const SizedBox(),
                                                  todayAppointments[index]
                                                              ["status"] ==
                                                          "-1"
                                                      ? const Text(
                                                          "Cancelled",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : const SizedBox(),
                                                  todayAppointments[index]
                                                              ["status"] ==
                                                          "2"
                                                      ? Row(
                                                          children: [
                                                            const Text(
                                                              "Approved",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            SizedBox(
                                                              width: width / 20,
                                                            ),
                                                            Text(
                                                                "Amount ${todayAppointments[index]["total_amount"]}")
                                                          ],
                                                        )
                                                      : const SizedBox()
                                                  // SizedBox(
                                                  //   height: height / 100,
                                                  // ),
                                                  // Row(
                                                  //   children: [
                                                  //     Text(
                                                  //       todayAppointments[index]
                                                  //           ["name"],
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: width / 10,
                                                  //     ),
                                                  //     Container(
                                                  //       color: Strings
                                                  //           .kPrimarycolor
                                                  //           .withOpacity(0.17),
                                                  //       child: Text(
                                                  //         todayAppointments[index]
                                                  //             ["date"],
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: height / 8.0,
                                        width: width / 8,
                                        decoration: const BoxDecoration(
                                            color: Strings.kPrimarycolor,
                                            borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            )),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _makePhoneCall(
                                                      contacts["phone_number"]);
                                                });
                                              },
                                              child: const CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    Strings.kPrimarycolor,
                                                child: Icon(
                                                  Icons.phone,
                                                  color: Strings.kWhitecolor,
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              "CALL",
                                              style: TextStyle(
                                                  color: Strings.kWhitecolor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                      : Container(
                          child: const Center(
                              child:
                                  Text("There is No Appointments for Today")))
                  : const SizedBox(),
              pickedDateAppointments.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 9, bottom: 9),
                      child: Text(
                        "Appointments: $selectedDate",
                        style: const TextStyle(
                            color: Strings.kBlackcolor,
                            fontWeight: FontWeight.w500,
                            fontFamily: Strings.lato,
                            fontSize: 18),
                      ),
                    )
                  : const SizedBox(),
              pickedDateAppointments.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      itemCount: pickedDateAppointments.length,
                      itemBuilder: ((context, index) {
                        var address = jsonDecode(
                            pickedDateAppointments[index]["address"]);

                        var contacts = jsonDecode(
                            pickedDateAppointments[index]["contact_details"]);
                        print(contacts);

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 20, vertical: height / 100),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Strings.kWhitecolor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if ((pickedDateAppointments[index]
                                                    ["status"] ==
                                                "0") ||
                                            pickedDateAppointments[index]
                                                    ["status"] ==
                                                "1") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadImages(
                                                        appointMentUnique:
                                                            pickedDateAppointments[
                                                                    index][
                                                                "appointment_unique_id"],
                                                      )));
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 35,
                                            backgroundColor:
                                                Strings.kPrimarycolor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundImage: NetworkImage(
                                                    pickedDateAppointments[
                                                        index]["image_url"]),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pickedDateAppointments[index]
                                                    ["name"],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Strings.kBlackcolor),
                                              ),

                                              pickedDateAppointments[index]
                                                          ["status"] ==
                                                      "1"
                                                  ? Row(
                                                      children: [
                                                        const Text(
                                                          "Attended",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        SizedBox(
                                                          width: width / 20,
                                                        ),
                                                        Text(
                                                            "Amount: ${pickedDateAppointments[index]["total_amount"]}")
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              pickedDateAppointments[index]
                                                          ["status"] ==
                                                      "0"
                                                  ? const Text(
                                                      "Pending",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 18,
                                                          color: Strings
                                                              .kPrimarycolor),
                                                    )
                                                  : const SizedBox(),
                                              pickedDateAppointments[index]
                                                          ["status"] ==
                                                      "-1"
                                                  ? const Text(
                                                      "Cancelled",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 18,
                                                          color: Colors.red),
                                                    )
                                                  : const SizedBox(),
                                              pickedDateAppointments[index]
                                                          ["status"] ==
                                                      "2"
                                                  ? Row(
                                                      children: [
                                                        const Text(
                                                          "Approved",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        SizedBox(
                                                          width: width / 20,
                                                        ),
                                                        Text(
                                                            "Amount: ${pickedDateAppointments[index]["total_amount"]}")
                                                      ],
                                                    )
                                                  : const SizedBox()
                                              // SizedBox(
                                              //   height: height / 100,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       todayAppointments[index]
                                              //           ["name"],
                                              //     ),
                                              //     SizedBox(
                                              //       width: width / 10,
                                              //     ),
                                              //     Container(
                                              //       color: Strings
                                              //           .kPrimarycolor
                                              //           .withOpacity(0.17),
                                              //       child: Text(
                                              //         todayAppointments[index]
                                              //             ["date"],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: height / 8.0,
                                    width: width / 8,
                                    decoration: const BoxDecoration(
                                        color: Strings.kPrimarycolor,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _makePhoneCall(
                                                  contacts["phone_number"]);
                                            });
                                          },
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                Strings.kPrimarycolor,
                                            child: Icon(
                                              Icons.phone,
                                              color: Strings.kWhitecolor,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "CALL",
                                          style: TextStyle(
                                              color: Strings.kWhitecolor),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }))
                  : const Text("")
            ],
          ),
        ),
      ),
    );
  }

  Future<void> filterData(String date) async {
    try {
      var url = 'http://jeevanraksha.co/API/P_r_appointments/$uniqId/$date';

      var response = await get(Uri.parse(url));

      print(uniqId);

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        setState(() {
          pickedDateAppointments = message["P_Appoinments"];
          isVisible = true;
        });

        if (pickedDateAppointments.isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            titleColor: Strings.kBlackcolor,
            messageColor: Strings.kBlackcolor,
            backgroundColor: Colors.white,
            leftBarIndicatorColor: Strings.kPrimarycolor,
            title: "Hey",
            message: "There is no appointments on $date",
            duration: const Duration(seconds: 3),
          ).show(context);
        }
        print(pickedDateAppointments);
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else if (response.statusCode == 404) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "Hey",
          message: "There is no appointments on $date",
          duration: const Duration(seconds: 3),
        ).show(context);

        setState(() {
          pickedDateAppointments.length = 0;
          isVisible = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future _pickDateDialog() async {
    await showDatePicker(
            confirmText: "OK",
            cancelText: "Cancel",
            helpText: "Appointment",
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1990),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2050)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
        selectedDate = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(_selectedDate.toString()));
      });
      if (selectedDate != null) {
        filterData(selectedDate);
        // appointmentAction(partnerUnique);
      }
    });
  }

  void logoutHome() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  // Future<void> profileData() async {
  //   try {
  //     var url = 'http://jeevanraksha.co/API/r_partnersbyid';

  //     var data = {
  //       'user_unique_id': uniqId,
  //       'session_unique_id': isSessionId,
  //     };

  //     var response = await post(Uri.parse(url), body: (data));

  //     if (response.statusCode == 200) {
  //       var message = jsonDecode(response.body);

  //       setState(() {
  //         UserprofileData = message["Users"];
  //       });

  //       SharedPreferences preferences = await SharedPreferences.getInstance();

  //       setState(() {
  //         // userImage = preferences.getString("image")!;
  //       });

  //       print(message);
  //     } else if (response.statusCode == 403) {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const LoginScreen()));
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> getUser() async {
    try {
      var url = 'http://jeevanraksha.co/API/r_partnersbyid';

      var data = {
        'partner_unique_id': uniqId,
        'session_unique_id': isSessionId,
      };

      var response = await post(Uri.parse(url), body: data);

      if (response.statusCode == 200) {
        var message = response.body;

        var users = jsonDecode(message);

        userData = users["Partner"]["0"];

        setState(() {
          userImage = userData["image_url"];
        });

        appointmentList();
      }
    } catch (e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleColor: Strings.kBlackcolor,
        messageColor: Strings.kBlackcolor,
        backgroundColor: Colors.white,
        leftBarIndicatorColor: Strings.kPrimarycolor,
        title: "Hey",
        message: "No Internet Connection",
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}
