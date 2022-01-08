
import 'package:connect/Activities/CalibrationUI/calibration_select_device.dart';
import 'package:connect/Activities/CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/screens/updateSoftwareScreen.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect/screens/accountScreen.dart';

import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';




class DecimalPlaceChoose extends StatefulWidget {
  DecimalPlaceChoose();
  int decimalPlace = 1 ;

  @override
  _DecimalPlaceChooseState createState() => _DecimalPlaceChooseState();
}

class _DecimalPlaceChooseState extends State<DecimalPlaceChoose> {
  @override
  Widget build(BuildContext context) {
  return Container(color: Colors.white,child: SafeArea(child: Scaffold(appBar: AppBar(
    backgroundColor: ThemeManager().getWhiteColor,
    elevation: 1.5,
    centerTitle: true,
    leading: GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Image.asset("assets/icons/backArrowIcon.png"),
    ),
    leadingWidth: width * 0.12,
    title: Text("Decimal places",
      style: interBold.copyWith(
          color: ThemeManager().getBlackColor),
    ),
  ),body:  Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data!.containsKey("decimalPlace")){
              widget.decimalPlace =  snapshot.data!.getInt("decimalPlace")!;

            }
            return Container(
              margin: EdgeInsets.only(
                top: height * 0.019,
              ),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(width*0.02)),
                border: Border.all(
                  color: ThemeManager().getBlackColor.withOpacity(.05),
                ),
              ),

              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

                child: ExpansionTile(
                  key: UniqueKey(),
                  backgroundColor: ThemeManager().getLightGreenTextFieldColor,
                  collapsedBackgroundColor: ThemeManager().getLightGreenTextFieldColor,
                  //initiallyExpanded: true,
                  iconColor: ThemeManager().getLightGrey1Color,
                  //trailing: Icon(Icons.keyboard_arrow_down,size: width*0.08),

                  //----------------Selected Product text from dropdown-------
                  title: Text(widget.decimalPlace.toString()+" Decimal Place",
                    style: interMedium.copyWith(
                        color: ThemeManager().getLightGrey1Color,
                        fontSize: width * 0.042),
                  ),

                  //----------------Available Product List in dropdown------------
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.decimalPlace = 1 ;
                          PrefferedDecimalPlaces = 1 ;
                          snapshot.data!.setInt("decimalPlace", 1);
                        });
                      },
                      child: Container(
                        color: ThemeManager().getWhiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.02, left: width * 0.03),
                              child: Text( "1 Decimal Place",
                                style: interSemiBold.copyWith(
                                    color: ThemeManager().getBlackColor,
                                    fontSize: width * 0.042),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.02),
                              height: height * 0.001,
                              color: ThemeManager().getBlackColor.withOpacity(0.10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.decimalPlace = 2 ;
                          PrefferedDecimalPlaces = 2 ;
                          snapshot.data!.setInt("decimalPlace", 2);
                        });
                      },
                      child: Container(
                        color: ThemeManager().getWhiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.02, left: width * 0.03),
                              child: Text( "2 Decimal Place",
                                style: interSemiBold.copyWith(
                                    color: ThemeManager().getBlackColor,
                                    fontSize: width * 0.042),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.02),
                              height: height * 0.001,
                              color: ThemeManager().getBlackColor.withOpacity(0.10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }else return Container(width: 0,height: 0,);
        }
    ),
  ) ,) ),);


  }
}


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    CustomerHomePageLogic().tabChangedStream.dataReload(currentTab);

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //-------------------------Appbar of screen-------------------
      appBar: AppBar(
        backgroundColor: ThemeManager().getWhiteColor,
        elevation: 1.5,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset("assets/icons/backArrowIcon.png"),
        ),
        leadingWidth: width * 0.12,
        title: Text(
          TextConst.settingAppbarTitleText,
          style: interBold.copyWith(
              color: ThemeManager().getBlackColor),
        ),
      ),

      //------------------------Body of screen---------------------
      body: Column(
        children: [

          //----------------------Setting screen Fields------------------
          // settingFieldView(TextConst.calibrationSettingsText, CalibrationConnectDeviceStep1Screen()),
          settingFieldView(TextConst.accountSettingsText, AccountScreen()),
          (userCalibration == false && isCustomerLoggedIn ==true)? Container(height: 0,width: 0,):  settingFieldView(TextConst.calibrationSettingsText, CalibrationSelectDeviceScreen()),
          firmwareUpdate?   settingFieldView(TextConst.firmwareUpdateText, UpdateSoftwareScreen()):Container(height: 0,width: 0,),
           (canCustomerLogout == false && isCustomerLoggedIn ==true)?Container(height: 0,width: 0,): Column(
            children: [
              InkWell(
                onTap: (){
                  FirebaseAuth.instance.signOut().then((value) =>Navigator.pushNamed(context,"/"));
                },
                child: Container(
                  height: height*0.053,
                  width: width,
                  margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logout",
                          style: interSemiBold.copyWith(fontSize: width * 0.037)),
                      SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
                    ],
                  ),
                ),
              ),
              Container(
                height: height*0.0008,
                width: width,
                //margin: EdgeInsets.only(top: height*0.01),
                color: ThemeManager().getBlackColor.withOpacity(.15),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Scaffold(body: DecimalPlaceChoose(),)));
                },
                child: Container(
                  height: height*0.053,
                  width: width,
                  margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Decimal Places",
                          style: interSemiBold.copyWith(fontSize: width * 0.037)),
                      SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
                    ],
                  ),
                ),
              ),
              Container(
                height: height*0.0008,
                width: width,
                //margin: EdgeInsets.only(top: height*0.01),
                color: ThemeManager().getBlackColor.withOpacity(.15),
              ),
            ],
          ),
          if(false)  Column(
            children: [
              InkWell(
                onTap: () async {

                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(shrinkWrap: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(onTap: () async {
                                  try{
                                    bool r = await FlutterDynamicIcon.supportsAlternateIcons;
                                 //   AppToast().show(message: r.toString());
                                    await FlutterDynamicIcon.setAlternateIconName("staht");
                                    print("App icon change successful");
                                    Navigator.pop(context);
                                  }catch(e){
                                    AppToast().show(message: e.toString());
                                  }
                                },
                                  child: Container(
                                    width: 100,height: 100,child: Image.asset("assets/staht_logo_green.jpg") ,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(onTap: () async {
                                  try{
                                    bool r = await FlutterDynamicIcon.supportsAlternateIcons;
                                   // AppToast().show(message: r.toString());
                                    await FlutterDynamicIcon.setAlternateIconName("aje");
                                    print("App icon change successful");
                                    Navigator.pop(context);
                                  }catch(e){
                                    AppToast().show(message: e.toString());
                                  }
                                },
                                  child: Container(
                                    width: 100,height: 100,child: Image.asset("assets/aje.png") ,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(onTap: () async {
                                  try{

                                    bool r = await FlutterDynamicIcon.supportsAlternateIcons;
                                   // AppToast().show(message: r.toString());
                                    await FlutterDynamicIcon.setAlternateIconName("iconn");
                                    print("App icon change successful");
                                    Navigator.pop(context);
                                  }catch(e){
                                    AppToast().show(message: e.toString());
                                  }
                                },
                                  child: Container(
                                    width: 100,height: 100,child: Image.asset("assets/iconn.png") ,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });

                },
                child: Container(
                  height: height*0.053,
                  width: width,
                  margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Change App Icon",
                          style: interSemiBold.copyWith(fontSize: width * 0.037)),
                      SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
                    ],
                  ),
                ),
              ),
              Container(
                height: height*0.0008,
                width: width,
                //margin: EdgeInsets.only(top: height*0.01),
                color: ThemeManager().getBlackColor.withOpacity(.15),
              ),
            ],
          ),
        if(false)  Column(
            children: [
              InkWell(
                onTap: () async {
                  try{

                    bool r = await FlutterDynamicIcon.supportsAlternateIcons;
                    AppToast().show(message: r.toString());
                    await FlutterDynamicIcon.setAlternateIconName("iconn");
                    print("App icon change successful");
                  }catch(e){
                    AppToast().show(message: e.toString());
                  }
                },
                child: Container(
                  height: height*0.053,
                  width: width,
                  margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logo Iconns",
                          style: interSemiBold.copyWith(fontSize: width * 0.037)),
                      SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
                    ],
                  ),
                ),
              ),
              Container(
                height: height*0.0008,
                width: width,
                //margin: EdgeInsets.only(top: height*0.01),
                color: ThemeManager().getBlackColor.withOpacity(.15),
              ),
            ],
          ),
          if(false)  Column(
            children: [
              InkWell(
                onTap: () async {
                  try{
                    bool r = await FlutterDynamicIcon.supportsAlternateIcons;
                    AppToast().show(message: r.toString());
                    await FlutterDynamicIcon.setAlternateIconName("staht");
                    print("App icon change successful");
                  }catch(e){
                    AppToast().show(message: e.toString());
                  }
                },
                child: Container(
                  height: height*0.053,
                  width: width,
                  margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logo Staht",
                          style: interSemiBold.copyWith(fontSize: width * 0.037)),
                      SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
                    ],
                  ),
                ),
              ),
              Container(
                height: height*0.0008,
                width: width,
                //margin: EdgeInsets.only(top: height*0.01),
                color: ThemeManager().getBlackColor.withOpacity(.15),
              ),
            ],
          ),

          // settingFieldView(TextConst.testFieldSettingsText, TestFieldsScreen()),
          //  settingFieldView(TextConst.reportFieldSettingsText, ReportFieldsScreen()),
          // settingFieldView(TextConst.softwareUpdateSettingsText, UpdateSoftwareScreen()),
        ],
      ),
    );
    return Scaffold(body: Stack(children: [
      Scaffold(
        backgroundColor: ThemeManager().getWhiteColor,

        //-------------------------Appbar of screen-------------------
        appBar: AppBar(
          backgroundColor: ThemeManager().getWhiteColor,
          elevation: 1.5,
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset("assets/icons/backArrowIcon.png"),
          ),
          leadingWidth: width * 0.12,
          title: Text(
            TextConst.settingAppbarTitleText,
            style: interBold.copyWith(
                color: ThemeManager().getBlackColor),
          ),
        ),

        //------------------------Body of screen---------------------
        body: Column(
          children: [

            //----------------------Setting screen Fields------------------
            // settingFieldView(TextConst.calibrationSettingsText, CalibrationConnectDeviceStep1Screen()),
            settingFieldView(TextConst.accountSettingsText, AccountScreen()),
            settingFieldView(TextConst.calibrationSettingsText, CalibrationSelectDeviceScreen()),
            settingFieldView(TextConst.firmwareUpdateText, UpdateSoftwareScreen()),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    FirebaseAuth.instance.signOut().then((value) =>Navigator.pushNamed(context,"/"));
                  },
                  child: Container(
                    height: height*0.053,
                    width: width,
                    margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Logout",
                            style: interSemiBold.copyWith(fontSize: width * 0.037)),
                        SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height*0.0008,
                  width: width,
                  //margin: EdgeInsets.only(top: height*0.01),
                  color: ThemeManager().getBlackColor.withOpacity(.15),
                ),
              ],
            ),
            // settingFieldView(TextConst.testFieldSettingsText, TestFieldsScreen()),
            //  settingFieldView(TextConst.reportFieldSettingsText, ReportFieldsScreen()),
            // settingFieldView(TextConst.softwareUpdateSettingsText, UpdateSoftwareScreen()),
          ],
        ),
      ),
      Align(alignment: Alignment.bottomCenter,child: Container(height: height*.08,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0))),

    ],),);

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //-------------------------Appbar of screen-------------------
      appBar: AppBar(
        backgroundColor: ThemeManager().getWhiteColor,
        elevation: 1.5,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset("assets/icons/backArrowIcon.png"),
        ),
        leadingWidth: width * 0.12,
        title: Text(
          TextConst.settingAppbarTitleText,
          style: interBold.copyWith(
              color: ThemeManager().getBlackColor),
        ),
      ),

      //------------------------Body of screen---------------------
      body: Column(
        children: [

          //----------------------Setting screen Fields------------------
         // settingFieldView(TextConst.calibrationSettingsText, CalibrationConnectDeviceStep1Screen()),
          settingFieldView(TextConst.accountSettingsText, AccountScreen()),
         // settingFieldView(TextConst.testFieldSettingsText, TestFieldsScreen()),
        //  settingFieldView(TextConst.reportFieldSettingsText, ReportFieldsScreen()),
         // settingFieldView(TextConst.softwareUpdateSettingsText, UpdateSoftwareScreen()),
        ],
      ),
    );
  }

  //-------------------------Setting fields view--------------------------
  Widget settingFieldView(String title,Widget screen) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> screen));
          },
          child: Container(
            height: height*0.053,
            width: width,
            margin: EdgeInsets.only(left: width*0.045, right: width*0.045),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: interSemiBold.copyWith(fontSize: width * 0.037)),
                SvgPicture.asset("assets/svg/forwardArrowIcon.svg"),
              ],
            ),
          ),
        ),
        Container(
          height: height*0.0008,
          width: width,
          //margin: EdgeInsets.only(top: height*0.01),
          color: ThemeManager().getBlackColor.withOpacity(.15),
        ),
      ],
    );
  }
}
