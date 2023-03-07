import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicub_vendor/helpers/strings.dart';
import 'package:medicub_vendor/login.dart';
import 'package:medicub_vendor/my_appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImages extends StatefulWidget {
  String? appointMentUnique;
  UploadImages({super.key, this.appointMentUnique});

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  File? uploadimage; //variable for choosed file

  Future<void> chooseImage() async {
    var choosedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage as File?;
    });
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  String? uniqueId;
  String? sessionId;

  int a = 20;
  File? _image;
  String? _imagepath;
  String imageProfile = '';
  String? sharedImage = '';

  String? mobilenumber;

  Future Pickimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        _image = imageTemporary;
      });
      // uploadImage();

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

      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to pick$e");
    }
  }

  Future<void> getUniqueUserId() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    setState(() {
      uniqueId = prefer.getString('user');
      sessionId = prefer.getString('sessionId');
    });
  }

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    getUniqueUserId();
    super.initState();
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bills Updates"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer(),
              MaterialButton(
                  color: Strings.kPrimarycolor,
                  child: const Text("Pick Bill"),
                  onPressed: (() {
                    // chooseImage();

                    showModalBottomSheet<void>(
                      // context and builder are
                      // required properties in this widget
                      context: context,
                      builder: (BuildContext context) {
                        // we set up a container inside which
                        // we create center column and display text

                        // Returning SizedBox instead of a Container
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
                  })),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _image != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: Image.file(
                    _image as File,
                    height: height / 9,
                    width: width / 2,
                  ),
                )
              : const Text("PickBill"),
          SizedBox(
            height: height / 40,
          ),
          Column(
            children: [
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
                      onChanged: (value) {},
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('([0-9]+(.[0-9]+)?)')),
                      ],
                      controller: _numberController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter Total Bill",
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
              SizedBox(
                height: height / 60,
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
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      controller: _commentController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter Comment ",
                          hintStyle: TextStyle(
                              color: const Color(0xff09726C).withOpacity(0.26)),
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
            ],
          ),
          SizedBox(
            height: height / 40,
          ),
          _image != null
              ? MaterialButton(
                  color: Strings.kPrimarycolor,
                  child: const Text("Upload Bill"),
                  onPressed: (() {
                    uploadBills();
                  }))
              : const SizedBox()
        ],
      ),
    );
  }

  Future<void> uploadBills() async {
    try {
      // API URL
      var url = 'http://jeevanraksha.co/API/p_bills_upload';

      final response = MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll({
          'partner_unique_id': uniqueId.toString(),
          'total_amount': _numberController.text.toString(),
          'appointment_unique_id': widget.appointMentUnique.toString(),
          'session_unique_id': sessionId.toString(),
          'comment': _commentController.text.toString()
        })
        ..files.add(await MultipartFile.fromPath(
          'files',
          _image!.path,
        ));

      var respond = await response.send();

      if (respond.statusCode == 201) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "Your Bill Uploaded Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: Strings.lato,
              ),
            )));
      } else if (respond.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
