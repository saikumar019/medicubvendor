import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';

import 'package:medicub_vendor/login.dart';

import 'package:medicub_vendor/profile/profile_completion.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/strings.dart';

class HomeScreen extends StatefulWidget {
  String? userName;
  String? usrUniqueId;
  HomeScreen({super.key, this.userName, this.usrUniqueId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? page;
  String? uniqId;
  String? mobilenumber;
  // Future<void> setUniqueUserId() async {
  //   final SharedPreferences prefer = await SharedPreferences.getInstance();

  //   prefer.setString('value', "${widget.userName}");
  // }

  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      page = pref.getString('value');
      uniqId = pref.getString("user");
      mobilenumber = pref.getString("mobilenumber");
    });
    print(mobilenumber);
    print(uniqId);
    lookUp();
    // profileData();
  }

  final controller = Get.put(LoginController());
  var myIns;
  List partners = [];

  var myins1;
  bool isSelected = false;
  bool isSelected1 = false;

  bool isSelected2 = false;
  bool isSelected3 = false;

  List partnerId = [];
  List department = [];
  var partId;

  var partId1;

  String? _selectedLocation;

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
          backgroundColor: Strings.kPrimarycolor,
          automaticallyImplyLeading: false,
          title: const Text(
            "Profile Completetion",
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
            child: partnerId.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 12,
                            right: width / 12,
                            top: width / 7),
                        child: const Text(
                          "Looking for?",
                          style: TextStyle(
                              color: Strings.kSecondarytextColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: Strings.lato,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 17),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = !isSelected;
                                  isSelected1 = !true;
                                  isSelected2 = !true;
                                  isSelected3 = !true;

                                  partId =
                                      partnerId[0]["partner_type_unique_id"];
                                });
                              },
                              child: Card(
                                color: isSelected
                                    ? Strings.kPrimarycolor
                                    : Strings.kWhitecolor,
                                elevation: 1,
                                shadowColor:
                                    Strings.kBlackcolor.withOpacity(0.16),
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),

                                  //<-- SEE HERE
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/hospital.png",
                                        height: height / 12,
                                        width: width / 2.5,
                                      ),
                                      SizedBox(
                                        height: height / 100,
                                      ),
                                      Text(
                                        "Hospitals",
                                        style: TextStyle(
                                            color: isSelected
                                                ? Strings.kWhitecolor
                                                : Strings.kSecondarytextColor,
                                            fontFamily: Strings.lato,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected1 = !isSelected1;
                                  isSelected = !true;
                                  isSelected2 = !true;
                                  isSelected3 = !true;
                                  partId =
                                      partnerId[1]["partner_type_unique_id"];
                                });
                              },
                              child: Card(
                                color: isSelected1
                                    ? Strings.kPrimarycolor
                                    : Strings.kWhitecolor,
                                elevation: 1,
                                shadowColor:
                                    Strings.kBlackcolor.withOpacity(0.16),
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),

                                  //<-- SEE HERE
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/clinic.png",
                                        height: height / 12,
                                        width: width / 2.5,
                                      ),
                                      SizedBox(
                                        height: height / 100,
                                      ),
                                      Text(
                                        "Clinic",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: isSelected1
                                                ? Strings.kWhitecolor
                                                : Strings.kSecondarytextColor,
                                            fontFamily: Strings.lato,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 60,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 17),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected2 = !isSelected2;
                                  isSelected = !true;
                                  isSelected1 = !true;
                                  isSelected3 = !true;
                                  partId =
                                      partnerId[2]["partner_type_unique_id"];
                                });
                              },
                              child: Card(
                                color: isSelected2
                                    ? Strings.kPrimarycolor
                                    : Strings.kWhitecolor,
                                elevation: 1,
                                shadowColor:
                                    Strings.kBlackcolor.withOpacity(0.16),
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),

                                  //<-- SEE HERE
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/diagnostic.png",
                                        height: height / 12,
                                        width: width / 2.5,
                                      ),
                                      SizedBox(
                                        height: height / 100,
                                      ),
                                      Text(
                                        "Diagnostic \ncenter",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: isSelected2
                                                ? Strings.kWhitecolor
                                                : Strings.kSecondarytextColor,
                                            fontFamily: Strings.lato,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected3 = !isSelected3;
                                  isSelected = !true;
                                  isSelected1 = !true;
                                  isSelected2 = !true;
                                  partId =
                                      partnerId[3]["partner_type_unique_id"];
                                });
                              },
                              child: Card(
                                color: isSelected3
                                    ? Strings.kPrimarycolor
                                    : Strings.kWhitecolor,
                                elevation: 1,
                                shadowColor:
                                    Strings.kBlackcolor.withOpacity(0.16),
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),

                                  //<-- SEE HERE
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/pharmacy.png",
                                        height: height / 12,
                                        width: width / 2.5,
                                      ),
                                      SizedBox(
                                        height: height / 100,
                                      ),
                                      Text(
                                        "Pharmacy",
                                        style: TextStyle(
                                            color: isSelected3
                                                ? Strings.kWhitecolor
                                                : Strings.kSecondarytextColor,
                                            fontFamily: Strings.lato,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 100,
                      ),
                      // isSelected
                      //     ? Padding(
                      //         padding: EdgeInsets.only(
                      //             left: width / 13,
                      //             top: height / 200,
                      //             right: width / 13),
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: Strings.kWhitecolor,
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: DropdownButton(
                      //             isExpanded: true,
                      //             underline: Container(
                      //                 decoration: const ShapeDecoration(
                      //               color: Colors.transparent,
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.all(
                      //                     Radius.circular(10.0)),
                      //               ),
                      //             )),
                      //             borderRadius: BorderRadius.circular(10),
                      //             hint: const Padding(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 "Select Your Department",
                      //                 style: TextStyle(color: Colors.grey),
                      //               ),
                      //             ),
                      //             items: department.map((item) {
                      //               return DropdownMenuItem(
                      //                 value: item,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Text(item['name'].toString()),
                      //                 ),
                      //               );
                      //             }).toList(),
                      //             onChanged: (newVal) {
                      //               setState(() {
                      //                 myIns = newVal;

                      //                 print(newVal);
                      //               });
                      //             },
                      //             value: myIns,
                      //           ),
                      //         ),
                      //       )
                      //     : const SizedBox(
                      //         height: 0,
                      //       ),
                      // SizedBox(
                      //   height: height / 200,
                      // ),
                      isSelected
                          ? Center(
                              child: MaterialButton(
                                minWidth: width / 1.15,
                                elevation: 2,
                                color: const Color(0xffF89122),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (() {
                                  searchPartnerHospital(partId);
                                }),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Strings.kWhitecolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Strings.latoBold),
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),

                      //clinic list

                      // isSelected1
                      //     ? Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: width / 13),
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: Strings.kWhitecolor,
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: DropdownButton(
                      //             isExpanded: true,
                      //             underline: Container(
                      //                 decoration: const ShapeDecoration(
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.all(
                      //                     Radius.circular(10.0)),
                      //               ),
                      //             )),
                      //             borderRadius: BorderRadius.circular(10),
                      //             hint: const Padding(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 "Select Your Department",
                      //                 style: TextStyle(color: Colors.grey),
                      //               ),
                      //             ),
                      //             items: department.map((item) {
                      //               return DropdownMenuItem(
                      //                 value: item,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Text(item['name'].toString()),
                      //                 ),
                      //               );
                      //             }).toList(),
                      //             onChanged: (newVal) {
                      //               setState(() {
                      //                 myins1 = newVal;
                      //               });
                      //             },
                      //             value: myins1,
                      //           ),
                      //         ),
                      //       )
                      //     : const SizedBox(),
                      // SizedBox(
                      //   height: height / 200,
                      // ),

                      isSelected1
                          ? Center(
                              child: MaterialButton(
                                minWidth: width / 1.15,
                                elevation: 2,
                                color: const Color(0xffF89122),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (() {
                                  searchPartnerClinic(partId);
                                }),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Strings.kWhitecolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Strings.latoBold),
                                ),
                              ),
                            )
                          : const SizedBox(),

                      //Diagnostic Center

                      isSelected2
                          ? Center(
                              child: MaterialButton(
                                minWidth: width / 1.15,
                                elevation: 2,
                                color: const Color(0xffF89122),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (() {
                                  searchPartnerDiagnosticcenter(
                                    partId,
                                  );
                                }),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Strings.kWhitecolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Strings.latoBold),
                                ),
                              ),
                            )
                          : const SizedBox(),

                      //Pharmacy center

                      isSelected3
                          ? Center(
                              child: MaterialButton(
                                minWidth: width / 1.15,
                                elevation: 2,
                                color: const Color(0xffF89122),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (() {
                                  searchPartnerPharmacy(partId);
                                }),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Strings.kWhitecolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Strings.latoBold),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const CircularProgressIndicator(),
                    ],
                  ))),
      ),
    );
  }

  Future<void> lookUp() async {
    try {
      var url = 'http://jeevanraksha.co/API/r_lookup';

      var response = await get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        setState(() {
          partnerId = message["lookups"]["PartnerTypes"];
          department = message["lookups"]["Departments"];
        });

        final SharedPreferences prefer = await SharedPreferences.getInstance();

        prefer.setString('hospital', partnerId[0]["partner_type_unique_id"]);
        prefer.setString('clinic', partnerId[1]["partner_type_unique_id"]);
        prefer.setString('diagnostic', partnerId[2]["partner_type_unique_id"]);
        prefer.setString('pharmacy', partnerId[3]["partner_type_unique_id"]);

        print(partnerId[0]["partner_type_unique_id"]);
        print(partnerId[1]["partner_type_unique_id"]);
        print(partnerId[2]["partner_type_unique_id"]);
        print(partnerId[3]["partner_type_unique_id"]);
        print(department);

        // setState(() {
        //   otpSend == true;
        // });

      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> searchPartnerHospital(
    String parid,
  ) async {
    if (partId.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileCompletion(
                  hospitalPartnerid: parid,
                )),
      );
    } else if (partners.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleColor: Strings.kBlackcolor,
        messageColor: Strings.kBlackcolor,
        backgroundColor: Colors.white,
        leftBarIndicatorColor: Strings.kPrimarycolor,
        title: "Hey",
        message: "No Hospitals Found",
        duration: const Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> searchPartnerClinic(
    String parid,
  ) async {
    if (partId.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileCompletion(
                  hospitalPartnerid: parid,
                )),
      );
    } else if (parid.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleColor: Strings.kBlackcolor,
        messageColor: Strings.kBlackcolor,
        backgroundColor: Colors.white,
        leftBarIndicatorColor: Strings.kPrimarycolor,
        title: "Hey",
        message: "No Clinics Found",
        duration: const Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> searchPartnerDiagnosticcenter(
    String parid,
  ) async {
    if (partId.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileCompletion(
                  hospitalPartnerid: parid,
                )),
      );
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleColor: Strings.kBlackcolor,
        messageColor: Strings.kBlackcolor,
        backgroundColor: Colors.white,
        leftBarIndicatorColor: Strings.kPrimarycolor,
        title: "Hey",
        message: "No Diagnostic Centers Found",
        duration: const Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> searchPartnerPharmacy(
    String parid,
  ) async {
    if (partId.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileCompletion(
                  hospitalPartnerid: parid,
                )),
      );
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleColor: Strings.kBlackcolor,
        messageColor: Strings.kBlackcolor,
        backgroundColor: Colors.white,
        leftBarIndicatorColor: Strings.kPrimarycolor,
        title: "Hey",
        message: "No Pharmacys Found",
        duration: const Duration(seconds: 3),
      )..show(context);
    }

    void logoutHome() async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
    }

    Future<void> profileData() async {
      try {
        var url = 'http://jeevanraksha.co/API/r_usersbyid';

        var data = {'user_unique_id': uniqId};

        var response = await post(Uri.parse(url), body: (data));

        if (response.statusCode == 200) {
          var message = jsonDecode(response.body);

          // setState(() {
          //   userProfileData = message["Users"];
          // });
          // print(userProfileData);

          print(message);
        } else if (response.statusCode == 403) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
