import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicub_vendor/helpers/strings.dart';
import 'package:medicub_vendor/my_appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String? uniqId;
  List userProfileData = [];
  String? isSessionId;

  String imageProfile = '';
  String? sharedImage = '';

  File? _image;

  String? mobilenumber;
  var UserprofileData;
  String? userImage = "";
  var userData;

  Future Pickimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        _image = imageTemporary;
      });
      uploadImage();

      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to pick$e");
    }
  }

  Future Pickcamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        _image = imageTemporary;
      });
      uploadImage();

      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to pick$e");
    }
  }

  getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
      isSessionId = pref.getString("sessionId");
      mobilenumber = pref.getString('mobileNumber');
    });
    getUser();
  }

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashBoardScreen()));
            },
          ),
          backgroundColor: Strings.kPrimarycolor,
          automaticallyImplyLeading: true,
          title: const Text(
            "Profile Image updating",
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
        backgroundColor: Strings.kWhitecolor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  userImage != null
                      ? CircleAvatar(
                          radius: 65,
                          child: CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(userImage.toString())),
                        )
                      : const CircleAvatar(
                          radius: 65,
                          child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  "http://jeevanraksha.co/public/images/vendor.jpg")),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: ClipOval(
                      child: Container(
                        color: Strings.kPrimarycolor,
                        child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: GestureDetector(
                                              child: const Text(
                                                'Gallery',
                                                style: TextStyle(
                                                    fontFamily: Strings.lato,
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              onTap: () {
                                                Pickimage();
                                                // pickImage();
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: GestureDetector(
                                              child: const Text(
                                                'Camera',
                                                style: TextStyle(
                                                    fontFamily: Strings.lato,
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              onTap: () {
                                                Pickcamera();
                                                // cameraImage();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    try {
      // API URL
      var url = 'http://jeevanraksha.co/API/p_image_action';

      final response = MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll({
          "partner_unique_id": uniqId.toString(),
          "session_unique_id": isSessionId.toString(),
        })
        ..files.add(await MultipartFile.fromPath(
          'image',
          _image!.path,
        ));

      var respond = await response.send();

      if (respond.statusCode == 201) {
        getUser();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "Your Profile Picture Uploaded Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: Strings.lato,
              ),
            )));
      } else {
        print("Upload Failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

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

        print(userData["image_url"]);

        setState(() {
          userImage = userData["image_url"];
        });
      }
    } catch (e) {
      print(e);

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
