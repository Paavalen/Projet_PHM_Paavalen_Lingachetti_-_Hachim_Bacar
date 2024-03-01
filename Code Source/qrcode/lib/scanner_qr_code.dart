import 'package:action_slider/action_slider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

ScanResult? scanResult;

class _QRCodeScannerState extends State<QRCodeScanner> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SCANNER LE QR CODE'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ActionSlider.standard(
            width: size.width - 50,
            actionThresholdType: ThresholdType.release,
            backgroundColor: Color(0xFFF1F7F7),
            toggleColor: Color(0xff572d86),
            child: Text(
              "Defiler pour scanner le code qr",
              textAlign: TextAlign.center,
            ),
            action: (controller) async {
              controller.loading(); //starts loading animation
              setState(() => scanResult = null);
              try {
                final result = await BarcodeScanner.scan(
                  options: ScanOptions(
                    strings: {
                      'cancel': 'Retour',
                      'flash_on': "activer flash",
                      'flash_off': "désactiver flash",
                    },
                    useCamera: -1,
                    autoEnableFlash: false,
                    android: AndroidOptions(
                      aspectTolerance: 0.00,
                      useAutoFocus: true,
                    ),
                  ),
                );
                if (result.rawContent != '') {
                  controller.success();
                  Fluttertoast.showToast(
                    msg: result.rawContent,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.lightGreen,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  await launch(result.rawContent);

                  await Future.delayed(const Duration(seconds: 5));
                  controller.reset();
                } else {
                  controller.failure();
                  Fluttertoast.showToast(
                    msg: "Une erreur est survenue lors du scan du code qr",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xffc91a34),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  await Future.delayed(const Duration(seconds: 5));
                  controller.reset();
                }
              } on PlatformException catch (e) {
                setState(() {
                  scanResult = ScanResult(
                    type: ResultType.Error,
                    format: BarcodeFormat.unknown,
                    rawContent: e.code == BarcodeScanner.cameraAccessDenied
                        ? 'The user did not grant the camera permission!'
                        : 'Unknown error: $e',
                  );
                });
                controller.failure();
                await Future.delayed(const Duration(seconds: 2));
                controller.reset();
              }
            },
          ),
        ),
      ),
    );
  }
}