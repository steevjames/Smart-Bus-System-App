import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/Widgets/zeroHeightAppbar.dart';
import 'package:flutter/material.dart';

class DefTemplate extends StatelessWidget {
  final double height;
  final bool showBackButton;
  final List<Widget> topChildren;
  final List<Widget> bottomChildren;
  final Widget footer;

  DefTemplate({
    this.showBackButton,
    this.topChildren,
    this.height,
    this.bottomChildren,
    this.footer,
  });
  @override
  Widget build(BuildContext context) {
    var sh = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: zeroHeightAppbar(
        context,
        color: primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                // Page blue area
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    image: DecorationImage(
                      image: AssetImage("assets/pagebg.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: height ?? sh * .0),
                      showBackButton == true
                          ? Row(
                              children: [
                                SizedBox(width: 5),
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                          : Center(),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: topChildren ?? [],
                        ),
                      )
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -.5),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    // Page Body from here
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: sh * .01),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: sh * .05),
                          Column(
                            children: bottomChildren,
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          footer ?? Center()
        ],
      ),
    );
  }
}
