
import 'package:flutter/material.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class ViewTestLast30DaysTabScreen extends StatefulWidget {
  const ViewTestLast30DaysTabScreen({Key? key}) : super(key: key);

  @override
  _ViewTestLast30DaysTabScreenState createState() => _ViewTestLast30DaysTabScreenState();
}

class _ViewTestLast30DaysTabScreenState extends State<ViewTestLast30DaysTabScreen> {

  //-----------------------Test result data--------------------
  dynamic testData = [
    {"testResult": "Test #262 has passed"},
    {"testResult": "Test #262 has failed"},
    {"testResult": "Test #262 has failed"},
    {"testResult": "Test #262 has passed"},
    {"testResult": "Test #262 has passed"},
    {"testResult": "Test #262 has passed"},
    {"testResult": "Test #262 has passed"},
    {"testResult": "Test #262 has passed"},
  ];


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

      //----------------------last 30 days Tab body view----------------------
    return Container(
      margin: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              TextConst.testsText,
              style: interMedium.copyWith(
                  fontSize: width * 0.035,
                  color: ThemeManager().getLightGrey1Color),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: testData.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: height * 0.019),
                  child: Column(

                    children: [
                      Row(
                        children: [

                          Image.asset("assets/icons/testIcon.png"),

                          Container(
                            margin: EdgeInsets.only(left: width * 0.03),
                            child: Text(
                              testData[index]["testResult"],
                              style: interRegular.copyWith(
                                  fontSize: width * 0.038,
                                  color: ThemeManager().getBlackColor),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.02),
                        height: height * 0.0009,
                        width: double.infinity,
                        color: ThemeManager().getBlackColor.withOpacity(.15),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
