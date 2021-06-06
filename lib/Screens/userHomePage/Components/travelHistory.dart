import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTravelLog extends StatefulWidget {
  @override
  _UserTravelLogState createState() => _UserTravelLogState();
}

class _UserTravelLogState extends State<UserTravelLog> {
  Future travelData;
  var travelHistory = [
    {
      "time": "5 am",
      "date": "22 May",
      "destination": "Trivandrum",
      "from": "Kochi",
      "busID": "7615231523"
    },
    {
      "time": "6 am",
      "date": "21 May",
      "destination": "Thrissur",
      "from": "Kochi",
      "busID": "7615231523"
    },
    {
      "time": "7 am",
      "date": "20 May",
      "destination": "Aluva",
      "from": "Kochi",
      "busID": "7615231523"
    },
    {
      "time": "8 am",
      "date": "19 May",
      "destination": "Kollam",
      "from": "Kochi",
      "busID": "7615231523"
    },
  ];

  getTravelData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = jsonDecode(prefs.get('userData'));
      var res = await http.get(
        Uri.parse(baseUrl + "api/travelLog"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "token " + userData["token"],
        },
      );
      print(res.body);
      print(res.statusCode);

      if (res.statusCode != 200) {
        throw Exception("Operation failed: Status code not 200");
      }
      return travelHistory;
    } catch (e) {
      print("Error $e");
      return travelHistory;
    }
  }

  @override
  void initState() {
    travelData = getTravelData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: travelData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var travelHistory = snapshot.data;
            return DefTemplate(
              showBackButton: true,
              topChildren: [
                Text(
                  "Travel History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 20),
              ],
              bottomChildren: List.generate(
                travelHistory.length,
                (index) => TravelHistoryCard(
                  from: travelHistory[index]["from"],
                  to: travelHistory[index]["destination"],
                  time: travelHistory[index]["time"],
                  date: travelHistory[index]["date"],
                  busId: travelHistory[index]["busID"],
                ),
              ),
            );
          } else {
            return DefTemplate(
              showBackButton: true,
              topChildren: [
                Text(
                  "Travel History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 20),
              ],
              bottomChildren: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 170, 20, 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class TravelHistoryCard extends StatelessWidget {
  final String from, to, time, date, busId;
  TravelHistoryCard({this.busId, this.date, this.from, this.time, this.to});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
      decoration: BoxDecoration(
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage("assets/pagebg3.png"),
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              spreadRadius: -3,
              color: Colors.black38,
              offset: Offset(3, 3),
            )
          ]),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  from + " to " + to,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  busId,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
