import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrcode/qr_image.dart';
import 'package:qrcode/scanner_qr_code.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({Key? key}) : super(key: key);

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GENERATION D'UN QR CODE"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Saisir une phrase ou un mot de votre choix !!!'),
            ),
          ),
          // This button when pressed navigates to QR code generation
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) {
                // Afficher le toast si le champ de texte est vide
                Fluttertoast.showToast(
                  msg: "Veuillez entrer un texte",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return QRImage(controller);
                    }),
                  ),
                );
              }
            },
            child: const Text('GENERER LE QR CODE'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return const QRCodeScanner();
                    }),
                  ),
                );
              },
              child: const Text('SCANNER LE QR CODE'),
            ),
          ),
        ],
      ),
    );
  }
}
