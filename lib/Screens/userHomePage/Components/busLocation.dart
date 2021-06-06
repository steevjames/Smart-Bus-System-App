import 'dart:convert';

import 'package:flutter_map/plugin_api.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BusLocation extends StatelessWidget {
  final String data;
  BusLocation({this.data});
  @override
  Widget build(BuildContext context) {
    var busLoc = jsonDecode(data);
    print(busLoc);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Color(0xff444444),
          title: Text("Bus Location"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(
                  double.parse(busLoc["xCoordinate"]),
                  double.parse(busLoc["yCoordinate"]),
                ),
                zoom: 17.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        double.parse(busLoc["xCoordinate"]),
                        double.parse(busLoc["yCoordinate"]),
                      ),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.pink,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            color: Color(0xff444444),
          )
        ],
      ),
    );
  }
}
