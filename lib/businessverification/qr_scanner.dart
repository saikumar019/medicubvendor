import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:medicub_vendor/helpers/strings.dart';
import 'package:medicub_vendor/my_appointment.dart';

import 'package:medicub_vendor/scaned_appointments.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
  }

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

      if (_scanBarcode.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScannedAppointment(dummy: _scanBarcode)));
      }
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
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
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
  }

  // Future _qrScanner() async {
  //   var cameraStatus = await Permission.camera.status;
  //   if (cameraStatus.isGranted) {
  //     String? grData = await scanner.scan();
  //     String? qrdataphone = await scanner.scanPhoto();
  //     print(grData);
  //   } else {
  //     var isGrant = await Permission.camera.request();

  //     if (isGrant.isGranted) {}
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: (() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashBoardScreen()));
            }),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)
                  MaterialButton(
                      color: Strings.kPrimarycolor,
                      onPressed: (() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScannedAppointment(dummy: result!.code)));
                      }),
                      child: const Text("Show Scanned Data "))
                else
                  const Text(''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Container(
                    //   margin: const EdgeInsets.all(8),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       await controller?.pauseCamera();
                    //     },
                    //     child: const Text('pause',
                    //         style: TextStyle(fontSize: 20)),
                    //   ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.all(8),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       await controller?.resumeCamera();
                    //     },
                    //     child: const Text('resume',
                    //         style: TextStyle(fontSize: 20)),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });

    if (result != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScannedAppointment(dummy: result!.code)));
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
