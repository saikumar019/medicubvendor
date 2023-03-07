import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:medicub_vendor/businessverification/qr_scanner.dart';
import 'package:medicub_vendor/businessverification/upload_bills.dart';
import 'package:medicub_vendor/login.dart';
import 'package:medicub_vendor/my_appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/strings.dart';

class ScannedAppointment extends StatefulWidget {
  String? dummy;
  ScannedAppointment({super.key, this.dummy});

  @override
  State<ScannedAppointment> createState() => _ScannedAppointmentState();
}

class _ScannedAppointmentState extends State<ScannedAppointment> {
  List scannedTodayAppointment = [];
  List scannedUpcomingAppointment = [];
  List scannedPastAppointment = [];

  List? statusData = [];

  String? userName = "";
  String? userNumber = "";
  String? userImage = "";

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> scannedappointmentList() async {
    String c = "6264509a-64a9-11ed-a6b0-5254004811a4";

    var f = jsonEncode(c);
    try {
      var url = 'http://jeevanraksha.co/API/r_appointments';

      var data = {
        'user_unique_id': widget.dummy,
        'partner_unique_id': uniqId,
        'session_unique_id': isSessionId,
      };

      var response = await post(Uri.parse(url), body: data);

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        setState(() {
          statusData = message["user"];
          scannedTodayAppointment = message["TodaysAppointments"];
          scannedUpcomingAppointment = message["UpcomingAppointments"];
          scannedPastAppointment = message["PastAppointments"];
        });
        print(scannedTodayAppointment);
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String? uniqId;
  String? isSessionId;

  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");

      isSessionId = pref.getString("sessionId");
    });
    scannedappointmentList();
  }

  @override
  void initState() {
    getValue();
    // TODO: implement initState
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashBoardScreen()));
            },
          ),
          backgroundColor: Strings.kPrimarycolor,
          title: const Text(
            "Patients Appointments",
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
        body: SingleChildScrollView(
            child: statusData!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Strings.kPrimarycolor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage: NetworkImage(
                                                statusData![0]["image_url"]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            statusData![0]["name"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Strings.kBlackcolor),
                                          ),
                                        ],
                                      ),
                                    ],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _makePhoneCall(
                                                statusData![0]["mobile"]);
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
                      ),
                      scannedTodayAppointment.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: const Text(
                                "Today",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            )
                          : const SizedBox(),
                      scannedTodayAppointment.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              itemCount: scannedTodayAppointment.length,
                              itemBuilder: ((context, index) {
                                var address = jsonDecode(
                                    scannedTodayAppointment[index]["address"]);

                                var contacts = jsonDecode(
                                    scannedTodayAppointment[index]
                                        ["contact_details"]);
                                print(contacts);

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 20,
                                      vertical: height / 100),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if ((scannedTodayAppointment[index]
                                                    ["status"] ==
                                                "0") ||
                                            scannedTodayAppointment[index]
                                                    ["status"] ==
                                                "1") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadImages(
                                                        appointMentUnique:
                                                            scannedTodayAppointment[
                                                                    index][
                                                                "appointment_unique_id"],
                                                      )));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Strings.kWhitecolor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width / 10,
                                                  ),
                                                  SizedBox(
                                                    height: height / 100,
                                                  ),
                                                  scannedTodayAppointment[index]
                                                              ["status"] ==
                                                          "1"
                                                      ? const Text(
                                                          "Attended",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.green),
                                                        )
                                                      : const SizedBox(),
                                                  scannedTodayAppointment[index]
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
                                                  scannedTodayAppointment[index]
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
                                                  scannedTodayAppointment[index]
                                                              ["status"] ==
                                                          "2"
                                                      ? const Text(
                                                          "Approved",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.green),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Strings.kWhitecolor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  )),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: scannedTodayAppointment[
                                                                    index][
                                                                "total_amount"] !=
                                                            null
                                                        ? Text(
                                                            "Amount: ${scannedTodayAppointment[index]["total_amount"]}",
                                                            style: const TextStyle(
                                                                color: Strings
                                                                    .kBlackcolor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        : Text(
                                                            "Amount: 0",
                                                            style: const TextStyle(
                                                                color: Strings
                                                                    .kBlackcolor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                          : Container(),
                      scannedUpcomingAppointment.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: const Text(
                                "Upcoming",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            )
                          : const SizedBox(),
                      scannedUpcomingAppointment.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              itemCount: scannedUpcomingAppointment.length,
                              itemBuilder: ((context, index) {
                                var address = jsonDecode(
                                    scannedUpcomingAppointment[index]
                                        ["address"]);

                                var contacts = jsonDecode(
                                    scannedUpcomingAppointment[index]
                                        ["contact_details"]);
                                print(contacts);

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 20,
                                      vertical: height / 100),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if ((scannedUpcomingAppointment[index]
                                                    ["status"] ==
                                                "0") ||
                                            scannedUpcomingAppointment[index]
                                                    ["status"] ==
                                                "1") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadImages(
                                                        appointMentUnique:
                                                            scannedUpcomingAppointment[
                                                                    index][
                                                                "appointment_unique_id"],
                                                      )));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Strings.kWhitecolor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width / 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        color: Strings
                                                            .kPrimarycolor
                                                            .withOpacity(0.1),
                                                        child: Text(
                                                          "${scannedUpcomingAppointment[index]["date"]}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color: Strings
                                                                  .kBlackcolor),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 100,
                                                      ),
                                                      scannedUpcomingAppointment[
                                                                      index]
                                                                  ["status"] ==
                                                              "1"
                                                          ? const Text(
                                                              "Attended",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : const SizedBox(),
                                                      scannedUpcomingAppointment[
                                                                      index]
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
                                                      scannedUpcomingAppointment[
                                                                      index]
                                                                  ["status"] ==
                                                              "-1"
                                                          ? const Text(
                                                              "Cancelled",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : const SizedBox(),
                                                      scannedUpcomingAppointment[
                                                                      index]
                                                                  ["status"] ==
                                                              "2"
                                                          ? const Text(
                                                              "Approved",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Strings.kWhitecolor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  )),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: scannedUpcomingAppointment[
                                                                      index][
                                                                  "total_amount"] !=
                                                              null
                                                          ? Text(
                                                              "Amount: ${scannedUpcomingAppointment[index]["total_amount"]}",
                                                              style: const TextStyle(
                                                                  color: Strings
                                                                      .kBlackcolor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          : Text(
                                                              "Amount: 0",
                                                              style: const TextStyle(
                                                                  color: Strings
                                                                      .kBlackcolor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                          : Container(),
                      scannedPastAppointment.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: const Text(
                                "Past",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            )
                          : const SizedBox(),
                      scannedPastAppointment.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              itemCount: scannedPastAppointment.length,
                              itemBuilder: ((context, index) {
                                var address = jsonDecode(
                                    scannedPastAppointment[index]["address"]);

                                var contacts = jsonDecode(
                                    scannedPastAppointment[index]
                                        ["contact_details"]);
                                print(contacts);

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 20,
                                      vertical: height / 100),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if ((scannedPastAppointment[index]
                                                    ["status"] ==
                                                "0") ||
                                            scannedPastAppointment[index]
                                                    ["status"] ==
                                                "1") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadImages(
                                                        appointMentUnique:
                                                            scannedUpcomingAppointment[
                                                                    index][
                                                                "appointment_unique_id"],
                                                      )));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Strings.kWhitecolor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width / 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        color: Strings
                                                            .kPrimarycolor
                                                            .withOpacity(0.1),
                                                        child: Text(
                                                          "${scannedPastAppointment[index]["date"]}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18,
                                                              color: Strings
                                                                  .kBlackcolor),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 100,
                                                      ),
                                                      scannedPastAppointment[
                                                                      index]
                                                                  ["status"] ==
                                                              "1"
                                                          ? const Text(
                                                              "Attended",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : const SizedBox(),
                                                      scannedPastAppointment[
                                                                      index]
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
                                                      scannedPastAppointment[
                                                                      index]
                                                                  ["status"] ==
                                                              "-1"
                                                          ? const Text(
                                                              "Cancelled",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : const SizedBox(),
                                                      scannedPastAppointment[
                                                                      index]
                                                                  ["status"] ==
                                                              "2"
                                                          ? const Text(
                                                              "Approved",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Strings.kWhitecolor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  )),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: scannedPastAppointment[
                                                                      index][
                                                                  "total_amount"] !=
                                                              null
                                                          ? Text(
                                                              "Amount: ${scannedPastAppointment[index]["total_amount"]}",
                                                              style: const TextStyle(
                                                                  color: Strings
                                                                      .kBlackcolor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          : Text(
                                                              "Amount: 0",
                                                              style: const TextStyle(
                                                                  color: Strings
                                                                      .kBlackcolor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                          : Container()
                    ],
                  )
                : Align(
                    child: CircularProgressIndicator(),
                  )),
      ),
    );
  }
}
