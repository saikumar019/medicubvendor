import 'package:flutter/material.dart';

import 'package:medicub_vendor/profile/address_profile.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/strings.dart';

class ProfileCompletion extends StatefulWidget {
  String? hospitalPartnerid;
  ProfileCompletion({super.key, this.hospitalPartnerid});

  @override
  State<ProfileCompletion> createState() => _ProfileCompletionState();
}

class _ProfileCompletionState extends State<ProfileCompletion> {
  String? mobilenumber;

  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      // page = pref.getString('value');
      // uniqId = pref.getString("user");
      mobilenumber = pref.getString("mobilenumber");
    });
    print(mobilenumber);
    // print(uniqId);
    // lookUp();
    // profileData();
  }

  bool is10 = false;
  late TextEditingController _contactnumberController;

  late TextEditingController _emailController;
  late TextEditingController _discountController;
  late TextEditingController _hospitalnameController;
  late TextEditingController _timingsController;
  late TextEditingController _contactemailController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    getValue();
    // TODO: implement initState
    _contactnumberController = TextEditingController();
    _emailController = TextEditingController();
    _discountController = TextEditingController();
    _hospitalnameController = TextEditingController();
    _timingsController = TextEditingController();
    _contactemailController = TextEditingController();
    _websiteController = TextEditingController();
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  String? aadhaarNumber;

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
            backgroundColor: Strings.kBackgroundcolor,
            appBar: AppBar(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(33.0),
                  bottomRight: Radius.circular(33.0),
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 80,
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
                        height: height / 100,
                      ),
                      Padding(
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
                              controller: _hospitalnameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Name of the Hosipatal",
                                  hintStyle: TextStyle(
                                      color: const Color(0xff09726C)
                                          .withOpacity(0.26)),
                                  // suffixIcon: const Icon(Icons.verified),
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Hospital Name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 12),
                        child: Material(
                          elevation: 1,
                          color: Strings.kWhitecolor,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: height / 18,
                            decoration: BoxDecoration(
                                color: Strings.kWhitecolor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mobilenumber.toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
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
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return 'Enter a valid email!';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter Email Address",
                                  hintStyle: TextStyle(
                                      color: const Color(0xff09726C)
                                          .withOpacity(0.26)),
                                  // suffixIcon: const Icon(Icons.verified),
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
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
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
                              controller: _discountController,
                              onChanged: (value) {
                                // setState(() {
                                //   number = value;
                                // });
                                // print(number);
                                // if (number!.length == 10) {
                                //   otpGenerate();

                                //   numberLength = !numberLength;
                                // }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Discount';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter Discount",
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
                      ),
                      SizedBox(
                        height: height / 70,
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
                              // onChanged: (value) {
                              //   setState(() {
                              //     aadhaarNumber = value;
                              //   });
                              // },
                              // keyboardType: TextInputType.number,

                              controller: _timingsController,
                              maxLines: 5,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Timings';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter Timings",
                                  hintStyle: TextStyle(
                                      color: const Color(0xff09726C)
                                          .withOpacity(0.26)),
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
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 12),
                        child: const Text(
                          "Contact Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Strings.kBlackcolor,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: Strings.latoBold),
                        ),
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
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
                              controller: _contactnumberController,
                              onChanged: (value) {
                                if (value.length == 10) {
                                  setState(() {
                                    is10 = true;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Contact Number';
                                } else if (value.length != 10) {
                                  return 'Enter 10 Digits Contact Number';
                                }
                                return null;
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter Contact Number",
                                  hintStyle: TextStyle(
                                      color: const Color(0xff09726C)
                                          .withOpacity(0.26)),
                                  // suffixIcon: is10 == true
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
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
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
                              controller: _contactemailController,
                              onChanged: (value) {
                                // setState(() {
                                //   number = value;
                                // });
                                // print(number);
                                // if (number!.length == 10) {
                                //   otpGenerate();

                                //   numberLength = !numberLength;
                                // }
                              },
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return 'Enter a valid Contact email!';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter Contact Email",
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
                      ),
                      SizedBox(
                        height: height / 70,
                      ),
                      Padding(
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
                              controller: _websiteController,
                              onChanged: (value) {
                                // setState(() {
                                //   number = value;
                                // });
                                // print(number);
                                // if (number!.length == 10) {
                                //   otpGenerate();

                                //   numberLength = !numberLength;
                                // }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'https://www.alala.com/';
                                }
                                return null;
                              },
                              // keyboardType:
                              //     const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter https://www.hospitals.com/",
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
                      ),
                      SizedBox(
                        height: height / 70,
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
                            if (_formKey.currentState!.validate()) {
                              BasicData();
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
                      ),
                    ]),
              ),
            )));
  }

  Future<void> BasicData() async {
    Map contactDetails = {
      'phone_number': _contactnumberController.text,
      'email_address': _contactemailController.text,
      'website': _websiteController.text,
    };

    Map basicData = {
      'partner_type_unique_id': widget.hospitalPartnerid,
      'name': _hospitalnameController.text,

      'email': _emailController.text,
      'discount': _discountController.text,
      'contact_details': contactDetails,
      "timings": _timingsController.text
      // 'aadhaar': _aadharController.text
    };

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddressProfileCompletion(
                  hospitalbasicData: basicData,
                )));
  }
}

  // Future<void> setUniqueUserId() async {
  //   final SharedPreferences prefer = await SharedPreferences.getInstance();

  //   prefer.setString('value', _fullnameController.text);
  //   prefer.setString("user", widget.userUniqueId.toString());
  // }

