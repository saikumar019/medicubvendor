import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:medicub_vendor/login.dart';

import 'package:place_picker/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/strings.dart';
import '../basic_details.dart';
import 'update_basicdetails.dart';

class AddressUpdateProfileCompletion extends StatefulWidget {
  Map? hospitalbasicData;
  Map? userBasicdata;

  AddressUpdateProfileCompletion(
      {super.key, this.hospitalbasicData, this.userBasicdata});

  @override
  State<AddressUpdateProfileCompletion> createState() =>
      _AddressUpdateProfileCompletionState();
}

class _AddressUpdateProfileCompletionState
    extends State<AddressUpdateProfileCompletion> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressline1Controller;
  late TextEditingController _addressline2Controller;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _zipController;

  String? aadhaarNumber;
  LocationResult? location;
  LatLng? latlang;
  String? latitude;
  String? longitude;
  String? names;
  Map? data;
  String? uniqId;

  String? accountStatus;
  String? isSessionId;
  var userProfileData;
  String? subLocality1name;

  String? administrative1name;

  String? lat;
  String? long;
  var address;
  var latlong;
  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
      accountStatus = pref.getString("accountStatus");
      isSessionId = pref.getString("sessionId");

      subLocality1name = pref.getString("sublocal");
      administrative1name = pref.getString("admin");
    });
    await profileData();
  }

  static Future<void> openMap(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void initState() {
    getValue();
    _addressline1Controller = TextEditingController();
    _addressline2Controller = TextEditingController();
    _cityController = TextEditingController();
    _districtController = TextEditingController();
    _stateController = TextEditingController();
    _countryController = TextEditingController();
    _zipController = TextEditingController();

    super.initState();
  }

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
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Strings.kPrimarycolor,
          automaticallyImplyLeading: false,
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
                          height: height / 80,
                        ),

                        SizedBox(
                          height: height / 100,
                        ),
                        // Center(
                        //   child: MaterialButton(
                        //     child: const Text("Pick location"),
                        //     onPressed: () {
                        //       showPlacePicker();
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 12),
                          child: GestureDetector(
                            onTap: () async {
                              showPlacePicker();
                            },
                            child: Row(
                              children: [
                                Spacer(),
                                const Icon(
                                  Icons.pin_drop,
                                  color: Strings.kPrimarycolor,
                                ),
                                administrative1name != null
                                    ? Center(
                                        child: Text(
                                          "${administrative1name.toString()}/${subLocality1name.toString()}",
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color:
                                                  Strings.kSecondarytextColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: Strings.lato,
                                              fontSize: 10),
                                        ),
                                      )
                                    : Center(child: Text("Select Location")),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: height / 100,
                        // ),

                        // Center(
                        //     child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text("Latitude :${latlong["latitude"]}"),
                        //     SizedBox(
                        //       height: height / 100,
                        //     ),
                        //     Text("Longitide :${latlong["longitude"]}")
                        //   ],
                        // )),
                        // SizedBox(
                        //   height: height / 100,
                        // ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 12),
                          child: const Text(
                            "Address Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Strings.kBlackcolor,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: Strings.latoBold),
                          ),
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
                                controller: _addressline1Controller
                                  ..text = address["address_1"],
                                // keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Addressline-01",
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
                                    return 'Enter Addressline-01';
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
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _addressline2Controller
                                  ..text = address["address_2"],
                                // keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Addressline-02",
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
                                    return 'Enter Addressline-02';
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
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _cityController
                                  ..text = address["city_town_village"],
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
                                    return 'Enter City';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter City",
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
                                // keyboardType: const TextInputType.numberWithOptions(
                                //     decimal: true),
                                controller: _districtController
                                  ..text = address["district"],

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter District';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter District",
                                    hintStyle: TextStyle(
                                        color: const Color(0xff09726C)
                                            .withOpacity(0.26)),
                                    suffixIcon:
                                        aadhaarNumber.toString().length == 12
                                            ? const Icon(
                                                Icons.verified,
                                                color: Strings.kPrimarycolor,
                                              )
                                            : const SizedBox(),
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
                                controller: _stateController
                                  ..text = address["state"],
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
                                    return 'Enter State';
                                  }
                                  return null;
                                },
                                // keyboardType: const TextInputType.numberWithOptions(
                                //     decimal: true),
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter State",
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
                                controller: _countryController
                                  ..text = address["country"],
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
                                    return 'Enter Country';
                                  }
                                  return null;
                                },
                                // keyboardType: const TextInputType.numberWithOptions(
                                //     decimal: true),
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Country",
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
                                controller: _zipController
                                  ..text = address["pincode"],
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
                                    return 'Enter Pincode';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Pincode",
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
                                addressData();
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
                : Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Future<void> addressData() async {
    Map coordinates = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    };
    setState(() {
      data = coordinates;
    });

    Map addressData = {
      'address_1': _addressline1Controller.text,
      'address_2': _addressline2Controller.text,
      'city_town_village': _cityController.text,
      'district': _districtController.text,
      "state": _stateController.text,
      "country": _countryController.text,
      "pincode": _zipController.text,
    };

    if (latitude != null && longitude != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateBasicDetails(
                    adressData: addressData,
                    basicDetails: widget.hospitalbasicData,
                    coordinates: coordinates,
                  )));
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleColor: Strings.kBlackcolor,
        messageColor: Strings.kBlackcolor,
        backgroundColor: Colors.white,
        leftBarIndicatorColor: Strings.kPrimarycolor,
        title: "Hey",
        message: "Please Pick location",
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  void showPlacePicker() async {
    LocationResult? result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlacePicker(
        "AIzaSyDnlgk_3dfS6s98DMe47PoBD5RxmkK3Cro",
      ),
    ));

    setState(() {
      location = result;

      latlang = location!.latLng;

      latitude = latlang!.latitude.toString();
      longitude = latlang!.longitude.toString();
      location = result;

      // _address1 = location!.locality.toString();

      latlang = location!.latLng;

      subLocality1name = location!.subLocalityLevel1!.name;
      administrative1name = location!.administrativeAreaLevel1!.name;
    });
    // Handle the result in your way
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('sublocal', subLocality1name.toString());

    preferences.setString("admin", administrative1name.toString());

    print(result);
  }

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
        });

        var addressDetails = jsonDecode(userProfileData["address"]);

        var latitudelong = jsonDecode(userProfileData["coordinates"]);

        print(addressDetails);

        print(latitudelong["latitude"]);

        setState(() {
          address = addressDetails;

          latitude = latitudelong["latitude"];
          longitude = latitudelong["longitude"];
        });
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
