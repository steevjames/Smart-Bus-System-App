import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';

class AddBalance extends StatefulWidget {
  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  String balance;
  String amount;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  addBalance() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        "Successfully added balance",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefTemplate(
      showBackButton: true,
      topChildren: [
        Text(
          "Add Balance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 20),
      ],
      bottomChildren: [
        SizedBox(height: 20),
        Center(
          child: Text("Add balance to your account to travel."),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Form(
            key: _formKey,
            child: TextFormField(
              onChanged: (value) {
                amount = value;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
              validator: (value) {
                if (value.isEmpty) return "Enter amount";
                return null;
              },
            ),
          ),
        ),
        SizedBox(height: 30),
        isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: ElevatedButton(
                  onPressed: () {
                    addBalance();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 15,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  child: Text("Add balance"),
                ),
              ),
      ],
    );
  }
}
