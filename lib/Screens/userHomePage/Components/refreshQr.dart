import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class RefreshQR extends StatefulWidget {
  @override
  _RefreshQRState createState() => _RefreshQRState();
}

class _RefreshQRState extends State<RefreshQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Are u sure ? Previous QR will be useless")),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                alertDialog(text: "Coming Soon", context: context);
              },
              child: Text("Refresh QR"),
            ),
          ),
        ],
      ),
    );
  }
}
