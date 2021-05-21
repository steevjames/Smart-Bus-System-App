import 'package:busapp/Screens/UserRegistration/login.dart';
import 'package:busapp/Screens/conductorRegistration/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginPage(),
                ),
              );
            },
            child: Text("Passenger"),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConductorLogin(),
                ),
              );
            },
            child: Text("Conductor"),
          ),
        ],
      ),
    );
  }
}
