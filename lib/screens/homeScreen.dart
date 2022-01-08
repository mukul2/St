import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //------------------------User data to show in body of screen-----------------------
  dynamic homeScreenUserData = [
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "BP Devon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.84149700629685,
          "longitude": -1.884403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile1Image.png",
          "userName": "B + Q Halesawn",
          "date": "June 6, 2021",
          "time": "8:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider4Image.png",
            },
            {
              "image": "assets/images/mapSlider5Image.png",
            },
            {
              "image": "assets/images/mapSlider6Image.png",
            }
          ],
          "latitude": 52.66609893141218,
          "longitude": -1.3181455442201135
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Devon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.64149700629685,
          "longitude": -1.684403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "LP Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.54149700629685,
          "longitude": -1.584403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
    {
      "userData": [
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "B + Q Maleswan",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.34149700629685,
          "longitude": -1.384403362729722
        },
        {
          "userProfileImage": "assets/images/userProfile2Image.png",
          "userName": "NEW Melon",
          "date": "June 6, 2021",
          "time": "9:00 AM",
          "peakLoad": "23",
          "targetLoad": "21",
          "timePeriod": "12",
          "result": "Pass",
          "sliderImages": [
            {
              "image": "assets/images/mapSlider1Image.png",
            },
            {
              "image": "assets/images/mapSlider2Image.png",
            },
            {
              "image": "assets/images/mapSlider3Image.png",
            },
          ],
          "latitude": 52.24149700629685,
          "longitude": -1.284403362729722
        },
      ],
    },
  ];

  bool isMapLoading = true;
  late BitmapDescriptor markerIcon;

  static int page = 0;
  ScrollController _listViewScrollController = new ScrollController();
  bool isPageLoading = false;
  List finalUserData = [];

  @override
  void initState() {
    _getMoreUserData(page);

    super.initState();

    setMarkerIcon();

    _listViewScrollController.addListener(() {
      if (_listViewScrollController.position.pixels ==
          _listViewScrollController.position.maxScrollExtent) {
        _getMoreUserData(page);
      }
    });

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    _listViewScrollController.dispose();
    super.dispose();
  }

  //------------------------Set marker image---------------------
  Future<void> setMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/icons/mapMarker1Icon.png');
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isMapLoading = false;
    });
  }

  //-------------------Load more user data------------------------
  void _getMoreUserData(int index) async {
    if (!isPageLoading) {
      setState(() {
        isPageLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      List newUserDataList = [];
      for (int i = 0; i < homeScreenUserData[index]["userData"].length; i++) {
        newUserDataList.add(homeScreenUserData[index]["userData"][i]);
      }

      setState(() {
        isPageLoading = false;
        finalUserData.addAll(newUserDataList);
        page++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return isMapLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: ThemeManager().getWhiteColor,
            body: Column(
              children: [
                //-------------------------Appbar view------------------------
                AppBarCustom(
                  appbarTitle: TextConst.homeAppbarTitleText,
                ),

                //-------------------------Screen body view-------------------
                Expanded(
                  //------------------------------------User data list view---------------------
                  child: userDataList(),
                ),
              ],
            ));
  }

  //------------------------------------User data list view---------------------
  Widget userDataList() {
    return ListView.builder(
      controller: _listViewScrollController,
      padding: EdgeInsets.zero,
      itemCount: finalUserData.length + 1,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        if (index == finalUserData.length) {
          return _circularProgressIndicator();
        } else {
          return Container(
            margin: EdgeInsets.only(top: height * 0.02),
            child: Column(
              children: [
                //----------------------User profile image and name header------------------
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(finalUserData[index]["userProfileImage"]),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: width * 0.038),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                finalUserData[index]["userName"],
                                style:
                                    interBold.copyWith(fontSize: width * 0.04),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.007),
                                child: Text(
                                  finalUserData[index]["date"] +
                                      " at " +
                                      finalUserData[index]["time"],
                                  style: interRegular.copyWith(
                                      fontSize: width * 0.03,
                                      color: ThemeManager().getLightGrey4Color),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: height * 0.01),
                          child: SvgPicture.asset(
                              "assets/svg/menuButtonIcon.svg")),
                    ],
                  ),
                ),

                //----------------------Measurements, time and result data------------------
                Container(
                  margin:
                      EdgeInsets.only(top: height * 0.02, left: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //-----------------Peak load data and icon-----------------
                      Container(
                        margin: EdgeInsets.only(left: width * 0.04),
                        child: Column(
                          children: [
                            Container(
                              height: width * 0.11,
                              width: width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeManager().getLightBlueColor,
                              ),
                              child:
                                  Image.asset("assets/icons/peakLoadIcon.png"),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                child: Row(
                                  children: [
                                    Text(
                                      finalUserData[index]["peakLoad"],
                                      style: interSemiBold.copyWith(
                                          fontSize: width * 0.04),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: Text(
                                          "kN",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.031),
                                        ))
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.005),
                              child: Text("Peak Load",
                                  style: interRegular.copyWith(
                                      fontSize: width * 0.03,
                                      color:
                                          ThemeManager().getLightGrey4Color)),
                            ),
                          ],
                        ),
                      ),

                      //-----------------Target load data and icon---------------
                      Container(
                        margin: EdgeInsets.only(right: width * 0.02),
                        child: Column(
                          children: [
                            Container(
                              height: width * 0.11,
                              width: width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeManager().getLightOrangeColor,
                              ),
                              child: Image.asset(
                                  "assets/icons/targetLoadIcon.png"),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                child: Row(
                                  children: [
                                    Text(
                                      finalUserData[index]["targetLoad"],
                                      style: interSemiBold.copyWith(
                                          fontSize: width * 0.04),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: Text(
                                          "kN",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.031),
                                        ))
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.005),
                                child: Text(
                                  "Target Load",
                                  style: interRegular.copyWith(
                                      fontSize: width * 0.03,
                                      color: ThemeManager().getLightGrey4Color),
                                )),
                          ],
                        ),
                      ),

                      //-----------------Time data and icon----------------------
                      Container(
                        margin: EdgeInsets.only(right: width * 0.04),
                        child: Column(
                          children: [
                            Container(
                              height: width * 0.11,
                              width: width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeManager().getLightBottleGreenColor,
                              ),
                              child: Image.asset("assets/icons/timeIcon.png"),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                child: Row(
                                  children: [
                                    Text(
                                      finalUserData[index]["timePeriod"],
                                      style: interSemiBold.copyWith(
                                          fontSize: width * 0.04),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: Text(
                                          "secs",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.031),
                                        ))
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.005),
                                child: Text(
                                  "Time",
                                  style: interRegular.copyWith(
                                      fontSize: width * 0.03,
                                      color: ThemeManager().getLightGrey4Color),
                                )),
                          ],
                        ),
                      ),

                      //----------------Result data and icon---------------------
                      Container(
                        margin: EdgeInsets.only(right: width * 0.07),
                        child: Column(
                          children: [
                            Container(
                              height: width * 0.11,
                              width: width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeManager().getLightGreenColor,
                              ),
                              child: Image.asset("assets/icons/passIcon.png"),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                child: Text(
                                  finalUserData[index]["result"],
                                  style: interSemiBold.copyWith(
                                      fontSize: width * 0.04),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: height * 0.005),
                                child: Text(
                                  index == 1 ? "Pass/fail" : "Result",
                                  style: interRegular.copyWith(
                                      fontSize: width * 0.03,
                                      color: ThemeManager().getLightGrey4Color),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //----------------------Map and other images slider-------------------
                mapImageSlider(index),
              ],
            ),
          );
        }
      },
    );
  }

  //----------------------------------Map and Other Images Slider----------------
  Widget mapImageSlider(int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(top: height * 0.02),
        child: Row(
          children: [
            //--------------------map view-----------------
            Container(
                height: height * 0.21,
                width: width * 0.88,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(finalUserData[index]["latitude"],
                        finalUserData[index]["longitude"]),
                    zoom: 8,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(index.toString()),
                      position: LatLng(finalUserData[index]["latitude"],
                          finalUserData[index]["longitude"]),
                      icon: markerIcon,
                    ),
                  },

                  // zoomControlsEnabled: false,
                  // zoomGesturesEnabled: false,
                )),

            //-----------------------Slider images------------------------------------
            for (var sliderImages in finalUserData[index]["sliderImages"])
              Container(
                  height: height * 0.21,
                  width: width * 0.88,
                  margin: EdgeInsets.only(left: width * 0.04),
                  child: Image.asset(
                    sliderImages["image"],
                    fit: BoxFit.fill,
                  )),
          ],
        ),
      ),
    );
  }

  //--------------------------Circular progress indicator------------
  Widget _circularProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Opacity(
          opacity: isPageLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
