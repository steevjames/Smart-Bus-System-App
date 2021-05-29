import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';

class HomeOptionCard extends StatefulWidget {
  final String text;
  final IconData icon;
  final Function onPressed;
  HomeOptionCard({this.onPressed, this.text, this.icon});
  @override
  _HomeOptionCardState createState() => _HomeOptionCardState();
}

class _HomeOptionCardState extends State<HomeOptionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 30, 10),
      child: MaterialButton(
        elevation: 5,
        onPressed: () {
          widget.onPressed();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50),
            right: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 0),
        color: Color(0xff666666),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                widget.icon,
                color: primaryColor,
              ),
            ),
            SizedBox(width: 20),
            Text(
              widget.text ?? "",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
