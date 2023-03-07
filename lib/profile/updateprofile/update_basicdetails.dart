// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:http/http.dart';

import 'package:medicub_vendor/login.dart';
import 'package:medicub_vendor/my_appointment.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/strings.dart';

class UpdateBasicDetails extends StatefulWidget {
  Map? adressData;
  Map? basicDetails;
  Map? coordinates;
  UpdateBasicDetails(
      {super.key, this.adressData, this.basicDetails, this.coordinates});

  @override
  State<UpdateBasicDetails> createState() => _UpdateBasicDetailsState();
}

class _UpdateBasicDetailsState extends State<UpdateBasicDetails> {
  String? uniqId;

  String? accountStatus;
  String? isSessionId;
  var userProfileData;
  var departmentName;

  var address;
  late TextEditingController _clinicdoctorController;

  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
      accountStatus = pref.getString("accountStatus");
      isSessionId = pref.getString("sessionId");

      // diagonosticPartnerId = pref.getString("diagnostic");
      // hospitalPartnerId = pref.getString("hospital");
      // pharmacyPartnerId = pref.getString("pharmacy");
    });
    profileData();
  }

  String? _radioValue; //Initial definition of radio button value
  String? choice;

  // void radioButtonChanges(String? value) {
  //   setState(() {
  //     _radioValue = value;
  //     switch (value) {
  //       case 'free':
  //         choice = value;
  //         break;
  //       case 'paid':
  //         break;
  //       default:
  //         choice = null;
  //     }
  //     debugPrint(choice); //Debug the choice in console
  //   });
  // }
  bool isSelect = false;
  bool isSelect1 = false;

  void selectedButton() {
    if (userProfileData["second_opinion"] == "free") {
      setState(() {
        isSelect = true;
      });
    } else if (userProfileData["second_opinion"] == "paid") {
      setState(() {
        isSelect1 = true;
      });
    }
  }

  void selecteddeptButton() {
    if (userProfileData["second_opinio"] == "free") {
      setState(() {
        isSelect = true;
      });
    } else if (userProfileData["second_opinion"] == "paid") {
      setState(() {
        isSelect1 = true;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  var department = [];

  List partnerId = [];

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

  String? diagonosticPartnerId;
  String? pharmacyPartnerId;
  String? hospitalPartnerId;

  List? selectedList;

  List? resSelected;

  bool isTrue = false;

  bool show = true;

  bool deptStatus = false;

  String? partnerUniqid;
  String? partnerhosid;
  bool ishos = false;

  void _compareHos() {
    if (hospitalPartnerId == partnerUniqid) {
      setState(() {
        ishos = true;
      });
    }
    selectedButton();
  }

  void _compare() {
    if ((diagonosticPartnerId == partnerUniqid) ||
        (pharmacyPartnerId == partnerUniqid)) {
      setState(() {
        isTrue = true;
      });
    }
    _compareHos();
  }

  // void _CompareHos() {
  //   if ((diagonosticPartnerId == partnerUniqid) ||
  //       (pharmacyPartnerId == partnerUniqid)) {
  //     setState(() {
  //       isTrue = true;
  //     });
  //   }
  //   selectedButton();
  // }

  @override
  void initState() {
    getValue();
    _clinicdoctorController = TextEditingController();

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
            "Profile Updating",
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
            child: userProfileData != null
                ? Form(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 12),
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  child: MultiSelectDialogField(
                                    // initialValue: userProfileData,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    items: department
                                        .map((e) =>
                                            MultiSelectItem(e, e["name"]))
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
                                      if (values.isNotEmpty) {
                                        setState(() {
                                          deptStatus = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: height / 70,
                        ),
                        isTrue == true
                            ? const SizedBox()
                            : !deptStatus
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width / 12),
                                    child: Container(
                                      height: height / 10,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: resSelected!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: resSelected![index]
                                                            ["name"] !=
                                                        null
                                                    ? Text(
                                                        resSelected![index]
                                                            ["name"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Strings
                                                                .kPrimarycolor),
                                                      )
                                                    : Text(
                                                        "",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Strings
                                                                .kPrimarycolor),
                                                      ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                        SizedBox(
                          height: height / 70,
                        ),
                        ishos == false
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 12),
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller: _clinicdoctorController
                                        ..text = userProfileData["doctor_name"]
                                                .toString()
                                                .isNotEmpty
                                            ? userProfileData["doctor_name"]
                                                .toString()
                                            : "",
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xffFFFFFF)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xffFFFFFF)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xffFFFFFF)),
                                          ),
                                          fillColor: const Color(0xffFFFFFF)),
                                    ),
                                  ),
                                ))
                            : const SizedBox(),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 50),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: width / 2.5,
                                      child: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor: isSelect
                                                ? Strings.kPrimarycolor
                                                : Colors.grey),
                                        child: RadioListTile(
                                          // key: _formKey,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          // dense: true,
                                          activeColor: Strings.kPrimarycolor,

                                          title: const Text("Free"),
                                          value: "Free",
                                          autofocus: isSelect,
                                          groupValue: gender,

                                          onChanged: (value) {
                                            setState(() {
                                              isSelect = false;
                                              isSelect1 = false;
                                              gender = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 2.5,
                                      child: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor: isSelect1
                                                ? Strings.kPrimarycolor
                                                : Colors.grey),
                                        child: RadioListTile(
                                          autofocus: isSelect1,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          // dense: true,
                                          title: const Text("Paid"),
                                          value: "Paid",
                                          activeColor: Strings.kPrimarycolor,
                                          groupValue: gender,

                                          onChanged: (value) {
                                            setState(() {
                                              isSelect1 = false;
                                              isSelect = false;
                                              gender = value.toString();
                                            });
                                          },
                                        ),
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
                                        flushbarPosition:
                                            FlushbarPosition.BOTTOM,
                                        titleColor: Strings.kBlackcolor,
                                        messageColor: Strings.kBlackcolor,
                                        backgroundColor: Colors.white,
                                        leftBarIndicatorColor:
                                            Strings.kPrimarycolor,
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
                                          flushbarPosition:
                                              FlushbarPosition.BOTTOM,
                                          titleColor: Strings.kBlackcolor,
                                          messageColor: Strings.kBlackcolor,
                                          backgroundColor: Colors.white,
                                          leftBarIndicatorColor:
                                              Strings.kPrimarycolor,
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
                                          flushbarPosition:
                                              FlushbarPosition.BOTTOM,
                                          titleColor: Strings.kBlackcolor,
                                          messageColor: Strings.kBlackcolor,
                                          backgroundColor: Colors.white,
                                          leftBarIndicatorColor:
                                              Strings.kPrimarycolor,
                                          title: "Hey",
                                          message: "Please Enter All Fields",
                                          duration: const Duration(seconds: 3),
                                        ).show(context);
                                      }
                                    } else {
                                      Flushbar(
                                        flushbarPosition:
                                            FlushbarPosition.BOTTOM,
                                        titleColor: Strings.kBlackcolor,
                                        messageColor: Strings.kBlackcolor,
                                        backgroundColor: Colors.white,
                                        leftBarIndicatorColor:
                                            Strings.kPrimarycolor,
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
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  )),
      ),
    );
  }

  Future<void> submitData() async {
    try {
      const url = "http://jeevanraksha.co/API/p_profile_action";

      print(selectedList);

      print(selectedList);

      List<String> da = [];

      if (selectedList != null) {
        for (Map a in selectedList!) {
          da.add(a["department_unique_id"]);
        }
      }

      List<String> resda = [];

      if (resSelected != null) {
        for (Map b in resSelected!) {
          resda.add(b["department_unique_id"]);
        }
      }
      var resDept = jsonEncode(resda);

      var departments = jsonEncode(da);

      var contactdetails = jsonEncode(widget.basicDetails!["contact_details"]);

      var address = jsonEncode(widget.adressData);
      var coordinatesLatlog = jsonEncode(widget.coordinates);

      var data = {
        'partner_type_unique_id': partnerUniqid,
        'partner_unique_id': uniqId,
        'departments': selectedList == null ? resDept : departments,
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()));

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "",
          message: "Profile updated Successfully",
          duration: const Duration(seconds: 3),
        ).show(context);

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
          partnerId = message["lookups"]["PartnerTypes"];
          department = message["lookups"]["Departments"];
          hospitalPartnerId = partnerId[0]["partner_type_unique_id"];

          diagonosticPartnerId = partnerId[2]["partner_type_unique_id"];

          pharmacyPartnerId = partnerId[3]["partner_type_unique_id"];
        });
        // final SharedPreferences prefer = await SharedPreferences.getInstance();
        // prefer.setString('hospital', partnerId[0]["partner_type_unique_id"]);
        // prefer.setString('clinic', partnerId[1]["partner_type_unique_id"]);
        // prefer.setString('diagnostic', partnerId[2]["partner_type_unique_id"]);
        // prefer.setString('pharmacy', partnerId[3]["partner_type_unique_id"]);

        _compare();

        print(department);

        // if (listEquals(userProfileData, department)) {
        //   setState(() {
        //     deptStatus = true;
        //   });
        // }
        for (var i = 0; i < department.length; i++) {
          if (department.contains(userProfileData![i])) {
            print("contins");
          }
        }

        print(deptStatus);

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
        'partner_type_unique_id': partnerUniqid,
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()));
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "",
          message: "Profile updated Successfully",
          duration: const Duration(seconds: 3),
        ).show(context);

        //

        print("login");
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "",
          message: "Profile updated Successfully",
          duration: const Duration(seconds: 3),
        ).show(context);
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
  }

  //   Future<void> lookUp() async {
  //     try {
  //       var url = 'http://jeevanraksha.co/API/r_lookup';

  //       var response = await get(
  //         Uri.parse(url),
  //       );

  //       if (response.statusCode == 200) {
  //         var message = jsonDecode(response.body);

  //         setState(() {
  //           // partnerId = message["lookups"]["PartnerTypes"];
  //           department = message["lookups"]["Departments"];
  //           _Compare();
  //         });

  //         print(department);

  //         // setState(() {
  //         //   otpSend == true;
  //         // });

  //       } else if (response.statusCode == 403) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //       }
  //     } catch (e) {
  //       print(e.toString());
  //       Flushbar(
  //         flushbarPosition: FlushbarPosition.TOP,
  //         titleColor: Strings.kBlackcolor,
  //         messageColor: Strings.kBlackcolor,
  //         backgroundColor: Colors.white,
  //         leftBarIndicatorColor: Strings.kPrimarycolor,
  //         title: "Hey",
  //         message: "No Internet Connection",
  //         duration: const Duration(seconds: 3),
  //       ).show(context);
  //     }
  //   }
  // }

  Future<void> profileData() async {
    try {
      var url = 'http://jeevanraksha.co/API/r_partnersbyid';

      var data = {
        'partner_unique_id': uniqId,
        'session_unique_id': isSessionId,
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        setState(() {
          userProfileData = message["Partner"]["0"];
          partnerUniqid = userProfileData["partner_type_unique_id"];
          gender = userProfileData["second_opinion"];

          resSelected = message["Partner"]["Departments"];
        });

        lookUp();
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
