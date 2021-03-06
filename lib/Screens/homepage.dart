import 'package:busapp/Screens/UserRegistration/login.dart';
import 'package:busapp/Screens/conductorRegistration/login.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefTemplate(
      footer: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "© Group 11",
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
      topChildren: [
        SizedBox(height: 30),
        Text(
          "Welcome",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 35,
          child: Image.asset(
            "assets/pngicon.png",
            color: primaryColor,
            width: 40,
          ),
        ),
        SizedBox(height: 17),
        Text(
          "Making Bus Travel Easier",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 30),
      ],
      bottomChildren: [
        SizedBox(height: 20),
        Text(
          "Choose your category:",
          style: TextStyle(
            fontSize: 17,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 30),
        HomeOption(
          image: "assets/homescreen/passenger.png",
          text: "Passenger",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserLoginPage(),
              ),
            );
          },
        ),
        SizedBox(height: 30),
        HomeOption(
          image: "assets/homescreen/conductor.png",
          text: "Conductor",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConductorLogin(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class HomeOption extends StatelessWidget {
  final String image;
  final String text;
  final Function onTap;
  HomeOption({@required this.image, @required this.text, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 0),
        color: secondaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 22),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/pagebg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 7),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Image.asset(
                  image,
                  width: 35,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
