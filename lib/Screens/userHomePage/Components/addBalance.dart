import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class AddBalance extends StatefulWidget {
  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add balance"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text("Add balance to your account")),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                alertDialog(text: "Coming soon", context: context);
              },
              child: Text("Add balance"),
            ),
          ),
        ],
      ),
    );
  }
}
