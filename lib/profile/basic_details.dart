// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:http/http.dart';
import 'package:medicub_vendor/businessverification/business_verification.dart';
import 'package:medicub_vendor/businessverification/qr_scanner.dart';
import 'package:medicub_vendor/login.dart';
import 'package:medicub_vendor/my_appointment.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/strings.dart';

class BasicDetails extends StatefulWidget {
  Map? adressData;
  Map? basicDetails;
  Map? coordinates;
  BasicDetails(
      {super.key, this.adressData, this.basicDetails, this.coordinates});

  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  String? uniqId;

  String? accountStatus;
  String? isSessionId;
  String? diagonosticPartnerId;
  String? pharmacyPartnerId;
  String? hospitalPartnerId;

  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
      accountStatus = pref.getString("accountStatus");
      isSessionId = pref.getString("sessionId");

      // prefer.setString('hospital', partnerId[0]["partner_type_unique_id"]);
      // prefer.setString('clinic', partnerId[1]["partner_type_unique_id"]);
      // prefer.setString('diagnostic', partnerId[2]["partner_type_unique_id"]);
      // prefer.setString('pharmacy', partnerId[3]["partner_type_unique_id"]);

      diagonosticPartnerId = pref.getString("diagnostic");
      hospitalPartnerId = pref.getString("hospital");
      pharmacyPartnerId = pref.getString("pharmacy");
    });

    lookUp();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clinicdoctorController = TextEditingController();
  List dropList = [
    "Surgery",
    "Gynocology",
    "Eye",
    "Heart",
    "Liver",
    "Brain",
    "Kidney"
  ];
  var department = [];

  bool isselected = false;
  bool isselected1 = false;
  String dropdownvalue = 'Free';
  String? gender = "";
  String? free = "";

  // List of items in our dropdown menu
  var items = [
    'Free',
    'Paid',
  ];

  var selectedList;

  List? sec = [];
  bool isTrue = false;
  bool ishos = false;

  _compareHos() {
    if (hospitalPartnerId == widget.basicDetails!["partner_type_unique_id"]) {
      setState(() {
        ishos = true;
      });
    }
  }

  _Compare() {
    if ((diagonosticPartnerId ==
            widget.basicDetails!["partner_type_unique_id"]) ||
        (pharmacyPartnerId == widget.basicDetails!["partner_type_unique_id"])) {
      setState(() {
        isTrue = true;
      });
    }
    _compareHos();
  }

  @override
  void initState() {
    getValue();

    super.initState();
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
              Navigator.pop(context);
            },
          ),
          backgroundColor: Strings.kPrimarycolor,
          automaticallyImplyLeading: true,
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 70,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: const Text(
                    "Basic Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Strings.kBlackcolor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: Strings.latoBold),
                  ),
                ),
                SizedBox(
                  height: height / 250,
                ),
                isTrue == true
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 12),
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(10),
                          child: MultiSelectDialogField(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            items: department
                                .map((e) => MultiSelectItem(e, e["name"]))
                                .toList(),
                            listType: MultiSelectListType.LIST,
                            selectedColor: Strings.kPrimarycolor,

                            // cancelText: Text(
                            //   "Cancel",
                            //   style: TextStyle(color: Strings.kPrimarycolor),
                            // ),
                            searchable: true,
                            searchHint: "Search here",
                            onConfirm: (values) {
                              setState(() {
                                selectedList = values;
                              });
                            },
                          ),
                        ),
                      ),
                SizedBox(
                  height: height / 70,
                ),
                ishos == false
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 12),
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: _clinicdoctorController,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Doctor Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter Doctor Name",
                                  hintStyle: TextStyle(
                                      color: const Color(0xff09726C)
                                          .withOpacity(0.26)),
                                  // suffixIcon: _aadharController.text.length == 12
                                  //     ? const Icon(
                                  //         Icons.verified,
                                  //         color: Strings.kPrimarycolor,
                                  //       )
                                  //     : const SizedBox(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xffFFFFFF)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xffFFFFFF)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xffFFFFFF)),
                                  ),
                                  fillColor: const Color(0xffFFFFFF)),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: height / 70,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: Row(
                    children: [
                      const Text(
                        "Second Opinion",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Strings.kBlackcolor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: Strings.latoBold),
                      ),
                      SizedBox(
                        width: width / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 50),
                        child: Column(
                          children: [
                            SizedBox(
                              width: width / 2.5,
                              child: RadioListTile(
                                // key: _formKey,
                                contentPadding: const EdgeInsets.all(0),
                                dense: true,
                                title: const Text("Free"),
                                value: "Free",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: width / 2.5,
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                dense: true,
                                title: const Text("Paid"),
                                value: "Paid",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                isTrue == false
                    ? Center(
                        child: MaterialButton(
                          minWidth: width / 1.2,
                          elevation: 2,
                          color: const Color(0xffF89122),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: (() {
                            if (selectedList.toString() == "[]") {
                              Flushbar(
                                flushbarPosition: FlushbarPosition.BOTTOM,
                                titleColor: Strings.kBlackcolor,
                                messageColor: Strings.kBlackcolor,
                                backgroundColor: Colors.white,
                                leftBarIndicatorColor: Strings.kPrimarycolor,
                                title: "Hey",
                                message: "Please Enter All Fields",
                                duration: const Duration(seconds: 3),
                              ).show(context);
                            } else {
                              if ((_formKey.currentState!.validate()) &&
                                  (gender.toString().isNotEmpty)) {
                                submitData();
                              } else {
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.BOTTOM,
                                  titleColor: Strings.kBlackcolor,
                                  messageColor: Strings.kBlackcolor,
                                  backgroundColor: Colors.white,
                                  leftBarIndicatorColor: Strings.kPrimarycolor,
                                  title: "Hey",
                                  message: "Please Enter All Fields",
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                              }
                            }
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
                    : Center(
                        child: MaterialButton(
                          minWidth: width / 1.2,
                          elevation: 2,
                          color: const Color(0xffF89122),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: (() {
                            if (selectedList.toString() == "null") {
                              if ((_formKey.currentState!.validate()) &&
                                  (gender.toString().isNotEmpty)) {
                                submitDataWithoutDept();
                              } else {
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.BOTTOM,
                                  titleColor: Strings.kBlackcolor,
                                  messageColor: Strings.kBlackcolor,
                                  backgroundColor: Colors.white,
                                  leftBarIndicatorColor: Strings.kPrimarycolor,
                                  title: "Hey",
                                  message: "Please Enter All Fields",
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                              }
                            } else {
                              Flushbar(
                                flushbarPosition: FlushbarPosition.BOTTOM,
                                titleColor: Strings.kBlackcolor,
                                messageColor: Strings.kBlackcolor,
                                backgroundColor: Colors.white,
                                leftBarIndicatorColor: Strings.kPrimarycolor,
                                title: "Hey",
                                message: "Please Enter All Fields",
                                duration: const Duration(seconds: 3),
                              ).show(context);
                            }
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitData() async {
    try {
      const url = "http://jeevanraksha.co/API/p_profile_action";

      print(selectedList);

      List<String> da = [];

      for (Map a in selectedList) {
        da.add(a["department_unique_id"]);
      }

      var departments = jsonEncode(da);

      var contactdetails = jsonEncode(widget.basicDetails!["contact_details"]);

      var address = jsonEncode(widget.adressData);
      var coordinatesLatlog = jsonEncode(widget.coordinates);

      var data = {
        'partner_type_unique_id':
            widget.basicDetails!["partner_type_unique_id"],
        'partner_unique_id': uniqId,
        'departments': departments,
        'session_unique_id': isSessionId,
        'contact_details': contactdetails,
        'address': address,
        'doctor_name': _clinicdoctorController.text,
        'timings': widget.basicDetails!["timings"],
        "second_opinion": gender,
        'discount': widget.basicDetails!["discount"],
        'name': widget.basicDetails!["name"],
        'email': widget.basicDetails!["email"],
        "coordinates": coordinatesLatlog,
      };

      var response = await post(
        Uri.parse(url),
        encoding: Encoding.getByName("utf-8"),
        body: data,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      var message = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (accountStatus == "1") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BusinessVerification()));
        }

        print("login");
      }
    } catch (err) {
      print(err);
    }
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
          department = message["lookups"]["Departments"];
          _Compare();
        });

        print(department);

        // setState(() {
        //   otpSend == true;
        // });

      } else if (response.statusCode == 403) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> submitDataWithoutDept() async {
    try {
      const url = "http://jeevanraksha.co/API/p_profile_action";

      print(selectedList);

      List<String> da = [];

      print(da);

      if (selectedList != null) {
        for (Map a in selectedList!) {
          da.add(a["department_unique_id"]);
        }
      }

      var departments = jsonEncode(da);

      var contactdetails = jsonEncode(widget.basicDetails!["contact_details"]);

      var address = jsonEncode(widget.adressData);
      var coordinatesLatlog = jsonEncode(widget.coordinates);

      var data = {
        'partner_type_unique_id':
            widget.basicDetails!["partner_type_unique_id"],
        'partner_unique_id': uniqId,
        'session_unique_id': isSessionId,
        'departments': departments,
        'contact_details': contactdetails,
        'address': address,
        'doctor_name': _clinicdoctorController.text,
        'timings': widget.basicDetails!["timings"],
        "second_opinion": gender,
        'discount': widget.basicDetails!["discount"],
        'name': widget.basicDetails!["name"],
        'email': widget.basicDetails!["email"],
        "coordinates": coordinatesLatlog,
      };

      var response = await post(
        Uri.parse(url),
        encoding: Encoding.getByName("utf-8"),
        body: data,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      var message = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (accountStatus == "1") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BusinessVerification()));
        }

        //

        print("login");
      } else if (response.statusCode == 403) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (err) {
      print(err);
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

    Future<void> lookUp() async {
      try {
        var url = 'http://jeevanraksha.co/API/r_lookup';

        var response = await get(
          Uri.parse(url),
        );

        if (response.statusCode == 200) {
          var message = jsonDecode(response.body);

          setState(() {
            // partnerId = message["lookups"]["PartnerTypes"];
            department = message["lookups"]["Departments"];
            // _Compare();
            // _compareHos();
          });

          print(department);

          // setState(() {
          //   otpSend == true;
          // });

        } else if (response.statusCode == 403) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } catch (e) {
        print(e.toString());
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
}
