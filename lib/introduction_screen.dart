// // ignore_for_file: prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:medicub/login.dart';
// import 'package:medicub/main.dart';
// import 'helpers/strings.dart';

// class IntroScreen extends StatefulWidget {
//   const IntroScreen({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _IntroScreen();
//   }
// }

// class _IntroScreen extends State<IntroScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     PageDecoration pageDecoration = PageDecoration(
//       imagePadding: EdgeInsets.all(0),
//       titlePadding: EdgeInsets.all(0),
//       bodyFlex: 3,
//       footerPadding: EdgeInsets.all(0),
//       bodyPadding: EdgeInsets.all(0),

//       titleTextStyle: TextStyle(
//           fontSize: 45.0, fontWeight: FontWeight.w700, color: Colors.black),

//       // imagePadding: EdgeInsets.only(top: 20),
//       imageFlex: 1, //image padding
//       boxDecoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [
//             Color(0xffF89122).withOpacity(0.22),
//             Color(0xffF89122).withOpacity(0.22),
//             Color(0xffF89122).withOpacity(0.22),
//             Color(0xffF89122).withOpacity(0.22),
//           ],
//         ),
//       ), //show linear gradient background of page
//     );

//     return IntroductionScreen(
//       isBottomSafeArea: false,

//       globalBackgroundColor: Color(0xfff2f2f2),
//       //main background of screen
//       pages: [
//         PageViewModel(
//           title: "",
//           bodyWidget: Column(
//             children: [
//               Image.asset(
//                 "assets/images/intro1.png",
//                 height: 420,
//                 width: double.infinity,
//               ),

//               SizedBox(
//                 height: 10,
//               ),
//               // Image.asset(
//               //   "assets/images/intro1.png",
//               //   height: 100,
//               // )
//             ],
//           ),
//           image: Text(
//             "A FREE Digital Health \nCard, Just for you!",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.w500,
//               fontFamily: Strings.lato,
//             ),
//           ),
//           // body: "",

//           decoration: pageDecoration,
//         ),
//         PageViewModel(
//           title: "",
//           bodyWidget: Column(
//             children: [
//               Image.asset(
//                 "assets/images/intro2.png",
//                 height: 420,
//                 width: double.infinity,
//               ),

//               SizedBox(
//                 height: 10,
//               ),
//               // Image.asset(
//               //   "assets/images/intro1.png",
//               //   height: 100,
//               // )
//             ],
//           ),
//           image: Text(
//             "Find Best Hospitals\n Nearby",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: Strings.lato,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w500),
//           ),
//           // body: "",

//           decoration: pageDecoration,
//         ),

//         PageViewModel(
//           title: "",

//           bodyWidget: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset(
//                 "assets/images/intro3.png",
//                 height: 420,
//                 width: double.infinity,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                 color: Color(0xffF89122),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 onPressed: (() {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const LoginScreen()),
//                   );
//                 }),
//                 child: Center(
//                     child: Text(
//                   "Get Your Digital Health Card Now!",
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 21,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: Strings.latoBold),
//                 )),
//               )
//             ],
//           ),
//           image: Text(
//             "Avail Never Imagined \nDiscounts",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: Strings.lato,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w500),
//           ),
//           // body: "",

//           decoration: pageDecoration,
//         ),

//         //add more screen here
//       ],

//       onDone: () => goHomepage(context), //go to home page on done
//       onSkip: () => goHomepage(context), // You can override on skip
//       showSkipButton: true,

//       nextFlex: 0,
//       skip: Text(
//         'Skip',
//         style: TextStyle(
//           fontFamily: Strings.lato,
//           color: Colors.black,
//         ),
//       ),
//       next: Text(
//         'Next',
//         style: TextStyle(
//           fontFamily: Strings.lato,
//           color: Colors.black,
//         ),
//       ),
//       done: Text(
//         '',
//         style: TextStyle(
//             fontFamily: Strings.lato,
//             fontWeight: FontWeight.w600,
//             color: Colors.black),
//       ),
//       dotsDecorator: DotsDecorator(
//         size: Size(10.0, 10.0), //size of dots
//         color: Color(0xffF89122).withOpacity(0.22),
//         activeSize: Size(22.0, 10.0),
//         activeColor: Colors.black,
//         //activeColor: Colors.white, //color of active dot
//         activeShape: RoundedRectangleBorder(
//           //shave of active dot
//           borderRadius: BorderRadius.all(Radius.circular(25.0)),
//         ),
//       ),
//     );
//   }

//   void goHomepage(context) {
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) {
//       return MyHomePage();
//     }), (Route<dynamic> route) => false);
//     //Navigate to home page and remove the intro screen history
//     //so that "Back" button wont work.
//   }

//   Widget introImage(String assetName) {
//     return Image.asset(
//       'assets/images/$assetName',
//       width: double.infinity,
//     );
//   }
// }
