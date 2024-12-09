import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code/Screen/qr_scanner_overlay.dart';
import 'package:qr_code/Screen/result_screen.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool isScanCompleted = false;

  Future<void> showTorchErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('TorchLight Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void closeScreen() {
    setState(() {
      isScanCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code below",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Scanning will start automatically"),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: (BarcodeCapture barcodes) {
                        if (!isScanCompleted) {
                          String? rawValue;
                          if (barcodes.raw is Map) {
                            rawValue = barcodes.raw['rawValue'];
                          } else if (barcodes.raw is List &&
                              barcodes.raw.isNotEmpty &&
                              barcodes.raw[0] is Map) {
                            rawValue = (barcodes.raw[0] as Map)['rawValue'];
                          }
                          String code = rawValue ?? 'Unknown Raw Value';
                          isScanCompleted = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                closeScreen: closeScreen,
                                code: code,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const QRScannerOverlay(
                      overlayColour: Colors.white,
                    )
                  ],
                )),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Scan Easy, Live Smarter",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
