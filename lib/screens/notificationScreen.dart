
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  //-----------------------Notification data-------------------
  dynamic notificationData = [
    {
      "notificationTitle": "Firmware update available",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/firmwareIcon.png",
      "newNotification" : true,
    },
    {
      "notificationTitle": "Test videos now released in beta",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/testVideosIcon.png",
      "newNotification" : true,
    },
    {
      "notificationTitle": "Firmware update available",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/firmwareIcon.png",
      "newNotification" : true,
    },
    {
      "notificationTitle": "Firmware update available",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/firmwareIcon.png",
      "newNotification" : true,
    },
    {
      "notificationTitle": "Test videos now released in beta",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/testVideosIcon.png",
      "newNotification" : false,
    },
    {
      "notificationTitle": "Firmware update available",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/firmwareIcon.png",
      "newNotification" : false,
    },
    {
      "notificationTitle": "Test videos now released in beta",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/testVideosIcon.png",
      "newNotification" : false,
    },
    {
      "notificationTitle": "Firmware update available",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/firmwareIcon.png",
      "newNotification" : false,
    },
    {
      "notificationTitle": "Firmware update available",
      "notificationDate": "June 6, 2021",
      "notificationTime": "9:00 AM",
      "notificationImage": "assets/icons/firmwareIcon.png",
      "newNotification" : false,
    },
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //---------------------Appbar of screen----------------------
      appBar: AppBar(
        backgroundColor: ThemeManager().getWhiteColor,
        elevation: 1.5,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/icons/backArrowIcon.png"),
        ),
        leadingWidth: width * 0.12,
        title: Text(
          TextConst.notificationAppbarTitleText,
          style: interBold.copyWith(
              color: ThemeManager().getBlackColor, ),
        ),
      ),

      //---------------------Notification list------------------------
      body: notificationDataView(),
    );
  }

  //---------------------Notification list------------------------
  Widget notificationDataView(){
    return ListView.builder(
      itemCount: notificationData.length,
      itemBuilder: (BuildContext context, int index)
      {
        return Container(
          color: notificationData[index]["newNotification"] == true
              ? ThemeManager().getLightGreenNotificationColor
              : ThemeManager().getWhiteColor,

          child: Column(

            children: [
              Container(
                margin: EdgeInsets.only(
                    left: width * 0.039,
                    right: width * 0.039,
                    top: height * 0.017),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    //------------------Notification Image------------------
                    Image.asset(notificationData[index]["notificationImage"],
                        height: height * 0.06,
                        width: width * 0.12,
                        fit: BoxFit.fill),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: width*0.033),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //-------------Notification Title---------------------
                            Container(
                                child: Text(
                                  notificationData[index]["notificationTitle"],
                                  style: interSemiBold.copyWith(fontSize: width * 0.04),
                                )),

                            //-------------Notification date and Time---------------
                            Container(
                              margin: EdgeInsets.only(top: height*0.009),
                              child: Text(notificationData[index]["notificationDate"] +
                                  " at " +
                                  notificationData[index]["notificationTime"],
                                style: interRegular.copyWith(
                                    fontSize: width * 0.03,
                                    color: ThemeManager().getLightGrey5Color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: height*0.01),
                        child: SvgPicture.asset("assets/svg/menuButtonIcon.svg")),
                  ],
                ),
              ),
              Container(
                height: height*0.0009,
                width: width,
                margin: EdgeInsets.only(top: height*0.017),
                color: ThemeManager().getBlackColor.withOpacity(.15),
              ),
            ],
          ),
        );
      },
    );
  }
}
