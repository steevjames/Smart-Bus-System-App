import 'package:flutter/material.dart';

class UserTravelLog extends StatefulWidget {
  @override
  _UserTravelLogState createState() => _UserTravelLogState();
}

class _UserTravelLogState extends State<UserTravelLog> {
  var travelHistory = [
    {
      "time": "5 am",
      "date": "22 May",
      "destination": "Kochi",
      "busID": "7615231523"
    },
    {
      "time": "6 am",
      "date": "21 May",
      "destination": "Kochi",
      "busID": "7615231523"
    },
    {
      "time": "7 am",
      "date": "20 May",
      "destination": "Kochi",
      "busID": "7615231523"
    },
    {
      "time": "8 am",
      "date": "19 May",
      "destination": "Kochi",
      "busID": "7615231523"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sample travel log"),
      ),
      body: ListView(
        children: List.generate(
            travelHistory.length,
            (index) => Card(
                  child: Column(
                    children: [
                      Text(
                        travelHistory[index]["destination"],
                      ),
                      Text(
                        travelHistory[index]["time"],
                      ),
                      Text(
                        travelHistory[index]["date"],
                      ),
                      Text(
                        travelHistory[index]["busID"],
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
