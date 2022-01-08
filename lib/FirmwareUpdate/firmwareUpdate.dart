import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/scanningAnimatedIcon/wave.dart';
import 'package:connect/services/os_dependent_settings.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../main.dart';

class FirmwareUpdateSelectDeviceScreen extends StatefulWidget {

  bool isAdmin = true;
  String calibratorId = "admin";




  @override
  FirmwareUpdateSelectDeviceScreenScreenState createState() => FirmwareUpdateSelectDeviceScreenScreenState();



}

class FirmwareUpdateSelectDeviceScreenScreenState extends State<FirmwareUpdateSelectDeviceScreen> {

  Widget scanDevices(){
    FlutterBlue flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: Duration(seconds: 20));
    Widget scanResult = StreamBuilder<List<ScanResult>>(
      stream:flutterBlue.scanResults,
      initialData: [],
      builder: (c, snapshot) {
        return Column(
          children: snapshot.data!
              .map(
                (r) {
              if (r.device.name != null &&
                  r.device.name.length > 0 &&
                  (r.device.name.contains("Staht") | r.device
                      .name.contains("Default") | r.device.name
                      .contains("Mukul") | r.device.name.contains("BLE Gauge"))
              )
                return  InkWell(onTap: () {

                  {
                    r.device.connect(autoConnect: false).then((value) async {
                      //Navigator.pop(context);
                      print("just connected and started discovering services");
                      await r.device.discoverServices();

                      List<BluetoothService> allservice = await r.device.discoverServices();
                      print("a X" + allservice.length.toString());
                      if (allservice.length > 0) {
                        print("b X" + allservice.length.toString());
                        //find services
                        dynamic bleCharacteristics = await OsDependentSettings().getReadWriteCharacters(device: r.device);

                        BluetoothCharacteristic characteristicWritePurpose = bleCharacteristics["write"];
                        BluetoothCharacteristic characteristicReadPurpose = bleCharacteristics["read"];
                        String iceSerial = "";
                        String Serial = "";
                        getSerial2() async {
                          print("c X");
                          await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                          List<int> responseAray2 = await characteristicReadPurpose.read();
                          await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                          responseAray2 = await characteristicReadPurpose.read();
                          String responseInString = utf8.decode(responseAray2);
                          Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
                          if (Serial.length == 0) {
                            getSerial2();
                          } else if (!iceSerial.contains("Default") && !Serial.contains("Default") && iceSerial != "Default" && Serial != "Default" && iceSerial != "No command presen" && Serial != "No command presen") {
                            print("g X");
                            //  lookUpBoard(Serial, iceSerial, scaffoldKey, characteristicReadPurpose, characteristicWritePurpose, r.device,);
                          } else {
                            print("h X");




                            GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        key: scaffoldKey2,
                                        appBar: AppBar(),
                                        body: Column(
                                          children: [
                                            ListTile(
                                              title: Text("SN and/or ICE SN is Default."),
                                              tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                TextEditingController controllerIce = new TextEditingController();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Scaffold(
                                                        appBar: AppBar(
                                                          title: Text("Update ICE SN"),
                                                        ),
                                                        body: Wrap(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: TextField(
                                                                controller: controllerIce,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                String commandToWrite = COMMAND_INDEX_1_SET + controllerIce.text + COMMAND_SUFFIX;
                                                                print("command " + commandToWrite);

                                                                try {
                                                                  await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  iceSerial = controllerIce.text;

                                                                  //return true;
                                                                } catch (e) {
                                                                  // return false;
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Card(
                                                                  color: Theme.of(context).primaryColor,
                                                                  child: Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "Save",
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                );

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  title: Text(iceSerial),
                                                  subtitle: Text("Change  ICE SN"),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                TextEditingController controller = new TextEditingController();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Scaffold(
                                                        appBar: AppBar(
                                                          title: Text("Update  SN"),
                                                        ),
                                                        body: Wrap(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: TextField(
                                                                controller: controller,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
                                                                print("command " + commandToWrite);

                                                                try {
                                                                  await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  Serial = controller.text;

                                                                  // return true;
                                                                } catch (e) {
                                                                  // return false;
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Card(
                                                                  color: Theme.of(context).primaryColor,
                                                                  child: Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "Save",
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                );

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  //title: Text(Serial), subtitle:userData.docs.first.get("roleId") ==RoleManager(rolId: '').STAHT_ADMIN_ROLE_ID  ?  Text("Change SN"):Container(width: 0,height: 0,),
                                                  title: Text(Serial), subtitle:widget.isAdmin ==false  ? Container(width: 0,height: 0,): Text("Change SN"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))));
                          }
                        }

                        getICESerial2() async {
                          print("d X");
                          await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                          List<int> responseAray2 = await characteristicReadPurpose.read();
                          await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                          responseAray2 = await characteristicReadPurpose.read();
                          String responseInString = utf8.decode(responseAray2);
                          iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
                          if (iceSerial.length == 0) {
                            print("e X");
                            getICESerial2();
                          }
                          if (Serial.length == 0) {
                            print("e X");
                            getSerial2();
                          } else {
                            //lookUpBoard(Serial, iceSerial, scaffoldKey, characteristicReadPurpose, characteristicWritePurpose, r.device);
                          }
                        }

                        getSerial() async {
                          print("c X");
                          await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                          List<int> responseAray2 = await characteristicReadPurpose.read();
                          await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                          responseAray2 = await characteristicReadPurpose.read();
                          String responseInString = utf8.decode(responseAray2);
                          Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
                          if (Serial.length == 0) {
                            getSerial();
                          }
                          if (iceSerial.length == 0) {
                            getICESerial2();
                          } else if (!iceSerial.contains("Default") && !Serial.contains("Default") && iceSerial != "Default" && Serial != "Default" && iceSerial != "No command presen" && Serial != "No command presen") {
                            print("g X");
                            // lookUpBoard(Serial, iceSerial, scaffoldKey, characteristicReadPurpose, characteristicWritePurpose, r.device);
                          } else {
                            print("h X");

                            // set up the button
                            Widget okButton = FlatButton(
                              child: Text("OK"),
                              onPressed: () {},
                            );

                            // set up the AlertDialog





                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        appBar: AppBar(),
                                        body: Column(
                                          children: [
                                            ListTile(
                                              title: Text("SN and/or ICE SN is Default."),
                                              tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                TextEditingController controllerICe = new TextEditingController();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Scaffold(
                                                        appBar: AppBar(
                                                          title: Text("Update ICE SN"),
                                                        ),
                                                        body: Wrap(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: TextField(
                                                                controller: controllerICe,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                String commandToWrite = COMMAND_INDEX_1_SET + controllerICe.text + COMMAND_SUFFIX;
                                                                print("command " + commandToWrite);

                                                                try {
                                                                  await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  iceSerial = controllerICe.text;
                                                                  getICESerial2();
                                                                  // return true;
                                                                } catch (e) {
                                                                  //return false;
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Card(
                                                                  color: Theme.of(context).primaryColor,
                                                                  child: Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "Save",
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                );


                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  title: Text(iceSerial),
                                                  subtitle: Text("Change  SN"),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                TextEditingController controller = new TextEditingController();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Scaffold(
                                                        appBar: AppBar(
                                                          title: Text("Update  SN"),
                                                        ),
                                                        body: Wrap(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: TextField(
                                                                controller: controller,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
                                                                print("command " + commandToWrite);

                                                                try {
                                                                  await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
                                                                  Serial = controller.text;
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  getICESerial2();
                                                                  //return true;
                                                                } catch (e) {
                                                                  //return false;
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Card(
                                                                  color: Theme.of(context).primaryColor,
                                                                  child: Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "Save",
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                );

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  title: Text(Serial),
                                                  //subtitle:snapshotprofile.data!.docs.first.get("roleId") == RoleManager(rolId: '').STAHT_ADMIN_ROLE_ID  ?  Text("Change SN"):Container(width: 0,height: 0,),
                                                  subtitle:widget.isAdmin ==false   ? Container(width: 0,height: 0,): Text("Change SN"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))));
                          }
                        }

                        //get ice
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                        List<int> responseAray2 = await characteristicReadPurpose.read();
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                        responseAray2 = await characteristicReadPurpose.read();
                        String responseInString = utf8.decode(responseAray2);
                        iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);

                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                        responseAray2 = await characteristicReadPurpose.read();
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                        responseAray2 = await characteristicReadPurpose.read();
                        responseInString = utf8.decode(responseAray2);
                        iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);

                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                        responseAray2 = await characteristicReadPurpose.read();
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
                        responseAray2 = await characteristicReadPurpose.read();
                        responseInString = utf8.decode(responseAray2);
                        iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
                        //end ice

                        //get sl
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                        responseAray2 = await characteristicReadPurpose.read();
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                        responseAray2 = await characteristicReadPurpose.read();
                        responseInString = utf8.decode(responseAray2);
                        Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                        responseAray2 = await characteristicReadPurpose.read();
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                        responseAray2 = await characteristicReadPurpose.read();
                        responseInString = utf8.decode(responseAray2);
                        Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                        responseAray2 = await characteristicReadPurpose.read();
                        await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

                        responseAray2 = await characteristicReadPurpose.read();
                        responseInString = utf8.decode(responseAray2);
                        Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);

                        productInfoGlobal["1"] = iceSerial;
                        productInfoGlobal["2"] = Serial;

                        GlobalKey<ScaffoldState> scaffoldKey20 = GlobalKey<ScaffoldState>();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>Container(color: Colors.white,child: SafeArea(child: Scaffold(key: scaffoldKey20,


                                  body: Column(
                                    children: [
                                      ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
                                      Container(
                                        margin: EdgeInsets.only(top: height*0.02,left: width*0.04),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_back_ios,
                                                color: ThemeManager().getDarkGreenColor,
                                                size: height * 0.02,
                                              ),
                                              Text(TextConst.backText,
                                                  style: interMedium.copyWith(
                                                      color: ThemeManager().getDarkGreenColor,
                                                      fontSize: width * 0.040)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //userData.docs.first.get("roleId") == RoleManager(rolId: '').STAHT_ADMIN_ROLE_ID


                                          if(widget.isAdmin == true   ){
                                            TextEditingController controllerIce = new TextEditingController();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Scaffold(
                                                    appBar: AppBar(
                                                      title: Text("Update ICE SN"),
                                                    ),
                                                    body: Wrap(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            controller: controllerIce,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            String commandToWrite = COMMAND_INDEX_1_SET + controllerIce.text + COMMAND_SUFFIX;
                                                            print("command " + commandToWrite);

                                                            try {
                                                              await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
                                                              Navigator.pop(context);
                                                              // Navigator.pop(context);
                                                              iceSerial = controllerIce.text;
                                                              Index1ValueStream.getInstance().dataReload( controllerIce.text);

                                                              //return true;
                                                            } catch (e) {
                                                              // return false;
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Card(
                                                              color: Theme.of(context).primaryColor,
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text(
                                                                    "Save",
                                                                    style: TextStyle(color: Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          }


                                        },
                                        child: Column(

                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.05,
                                                  right: width * 0.05,
                                                  top: height * 0.02),

                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      //------------- Title -------------------
                                                      Text("ICE Serial",
                                                        style: interBold.copyWith(
                                                            color: ThemeManager().getExtraDarkBlueColor,
                                                            fontSize: width * 0.040),
                                                      ),

                                                      //------------- Machine data------------------
                                                      Container(
                                                          margin: EdgeInsets.only(top: height * 0.008),
                                                          constraints: BoxConstraints(
                                                            maxWidth: width * 0.70,
                                                          ),
                                                          child :StreamBuilder(
                                                              stream: Index1ValueStream.getInstance().outData,
                                                              initialData: iceSerial,
                                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                                if (snapshot.hasData) {
                                                                  return Text(snapshot.data!,style: interRegular.copyWith(
                                                                      color: ThemeManager().getLightGrey5Color,
                                                                      fontSize: width * 0.030));
                                                                } else {
                                                                  return Text("Please wait",style: interRegular.copyWith(
                                                                      color: ThemeManager().getLightGrey5Color,
                                                                      fontSize: width * 0.030));
                                                                }
                                                              })
                                                      ),
                                                    ],
                                                  ),

                                                  //-------------------- Edit Detail PopUp ---------------------
                                                  Image.asset(
                                                    "assets/icons/editIcon.png",
                                                    color: ThemeManager().getDarkGreenColor,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //--------------------- Divider ----------------------------------
                                            Container(
                                              margin: EdgeInsets.only(top: height * 0.009),
                                              height: height * 0.001,
                                              width: double.infinity,
                                              color: ThemeManager().getBlackColor.withOpacity(0.19),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            //snapshotprofile.data!.docs.first.get("roleId") == RoleManager(rolId: '').STAHT_ADMIN_ROLE_ID
                                            //
                                            if(widget.isAdmin == true ){
                                              TextEditingController controller = new TextEditingController();

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Scaffold(
                                                      appBar: AppBar(
                                                        title: Text("Update  SN"),
                                                      ),
                                                      body: Wrap(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: TextField(
                                                              controller: controller,
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
                                                              print("command " + commandToWrite);

                                                              try {
                                                                await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
                                                                Navigator.pop(context);
                                                                Index2ValueStream.getInstance().dataReload( controller.text);
                                                                //Navigator.pop(context);

                                                                Serial = controller.text;

                                                                // return true;
                                                              } catch (e) {
                                                                // return false;
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Card(
                                                                color: Theme.of(context).primaryColor,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "Save",
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              );
                                            }

                                          },

                                          child : Column(

                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.05,
                                                    right: width * 0.05,
                                                    top: height * 0.02),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        //------------- Title -------------------
                                                        Text("Serial",
                                                          style: interBold.copyWith(
                                                              color: ThemeManager().getExtraDarkBlueColor,
                                                              fontSize: width * 0.040),
                                                        ),

                                                        //------------- Machine data------------------
                                                        Container(
                                                            margin: EdgeInsets.only(top: height * 0.008),
                                                            constraints: BoxConstraints(
                                                              maxWidth: width * 0.70,
                                                            ),
                                                            child :StreamBuilder(
                                                                stream: Index2ValueStream.getInstance().outData,
                                                                initialData: Serial,
                                                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    return Text(snapshot.data!,style: interRegular.copyWith(
                                                                        color: ThemeManager().getLightGrey5Color,
                                                                        fontSize: width * 0.030));
                                                                  } else {
                                                                    return Text("Please wait",style: interRegular.copyWith(
                                                                        color: ThemeManager().getLightGrey5Color,
                                                                        fontSize: width * 0.030));
                                                                  }
                                                                })
                                                        ),
                                                      ],
                                                    ),

                                                    //-------------------- Edit Detail PopUp ---------------------
                                                    Image.asset(
                                                      "assets/icons/editIcon.png",
                                                      color: ThemeManager().getDarkGreenColor,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //--------------------- Divider ----------------------------------
                                              Container(
                                                margin: EdgeInsets.only(top: height * 0.009),
                                                height: height * 0.001,
                                                width: double.infinity,
                                                color: ThemeManager().getBlackColor.withOpacity(0.19),
                                              ),
                                            ],
                                          )

                                      ),


                                      Directory_3_view_edit(
                                        bluetoothCharacteristicWrite: characteristicWritePurpose,
                                        bluetoothCharacteristicRead:characteristicReadPurpose,
                                      ),
                                      Directory_4_view_edit(
                                        bluetoothCharacteristicWrite: characteristicWritePurpose,
                                        bluetoothCharacteristicRead:characteristicReadPurpose,
                                      ),
                                      Directory_9_view_edit(
                                        bluetoothCharacteristicWrite: characteristicWritePurpose,
                                        bluetoothCharacteristicRead:characteristicReadPurpose,
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(
                                            left: width * 0.05,
                                            right: width * 0.05,
                                            top: height * 0.045),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            //---------- Assign Customer Button -------------------
                                            InkWell(
                                              onTap: () {


                                                lookUpBoard(widget.calibratorId,Serial, iceSerial, scaffoldKey20, characteristicReadPurpose, characteristicWritePurpose, r.device,context,context);

                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => CalibrationChooseCustomerScreen()));
                                              },
                                              child: Container(
                                                  height: height * 0.065,
                                                  decoration: BoxDecoration(
                                                      color: ThemeManager().getDarkGreenColor,
                                                      borderRadius:
                                                      BorderRadius.circular(width * 0.014)),
                                                  alignment: Alignment.center,
                                                  child:ButtonView(buttonLabel: TextConst.assignCustomerText)
                                              ),
                                            ),

                                            //--------------- Advanced Settings Button -----------------------
                                            InkWell(onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>  ConnectedDevicePage(auth: FirebaseAuth.instance,
                                                      firestore:
                                                      FirebaseFirestore
                                                          .instance,

                                                      device:  r.device, calibratorID: 'admin', key: null,)),
                                              );
                                            },
                                              child: Container(
                                                margin: EdgeInsets.only(top: height * 0.015),
                                                height: height * 0.065,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        ThemeManager().getOrangeGradientColor,
                                                        ThemeManager().getYellowGradientColor,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.circular(width * 0.014)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  TextConst.advancedSettingsText,
                                                  style: interSemiBold.copyWith(
                                                      fontSize: width * 0.04,
                                                      color: ThemeManager().getWhiteColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),



                                      // if(false)   ListTile(
                                      //   title: Text(
                                      //     "Sequential Write",
                                      //     style: TextStyle(color: Colors.blue),
                                      //   ),
                                      //   subtitle: StreamBuilder<double>(
                                      //       stream: ImageWriteStatusStream.getInstance().outData,
                                      //       // async work
                                      //       builder: (BuildContext context,
                                      //           AsyncSnapshot<double> snapshot) {
                                      //         if(snapshot.hasData){
                                      //           return LinearProgressIndicator(
                                      //             value: snapshot.data,
                                      //           );
                                      //         }else{
                                      //           return LinearProgressIndicator(
                                      //             value: 0,
                                      //           );
                                      //         }
                                      //       }),
                                      //   trailing: RaisedButton(
                                      //     child: Text("Gallary"),
                                      //     onPressed:(){
                                      //       //image write stopped
                                      //       writeImageGallary(r.device,characteristicReadPurpose,characteristicWritePurpose);
                                      //     },
                                      //   ),
                                      // ),

                                      if(false)   InkWell(
                                        onTap: () {

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,

                                          ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Text(
                                                "Advanced settings",
                                                style: TextStyle(color:Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if(false)   InkWell(
                                        onTap: () {
                                          lookUpBoard(widget.calibratorId,Serial, iceSerial, scaffoldKey20, characteristicReadPurpose, characteristicWritePurpose, r.device,context,context);
                                        },
                                        child: Card(
                                          color: Colors.blue,
                                          child: Container(
                                              child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(widget.isAdmin?"Assign Customer":"Search in System",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),),)));


                      } else {
                        print("i X");
                        print("service side " + allservice.length.toString());
                      }
                    });

                  }



                }, child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: ThemeManager()
                                .getLightGrey3Color,
                            width: height * 0.0007)),
                  ),
                  height: height * 0.052,
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      children: [
                        Text(r.device.name,
                          style: interMedium.copyWith(
                              fontSize: width * 0.037),
                        ),
                        Text("Select Device",
                          style: interSemiBold.copyWith(
                              fontSize: width * 0.033,
                              color: ThemeManager()
                                  .getRedColor),
                        ),
                      ],
                    ),
                  ),
                ),);
              else
                return Container(width: 0, height: 0,);
            },

          )
              .toList(),
        );
      },
      // builder: (c, snapshot) => Column(
      //   children: snapshot.data!
      //       .map(
      //         (r) => ScanResultTile(
      //       result: r,
      //       onTap: () {
      //         r.device.connect(autoConnect: false).then((value) async{
      //           CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
      //
      //           SharedPreferences sf =await SharedPreferences.getInstance();
      //           String index6;
      //           String index2;
      //
      //
      //           void initDeviceSlAndCalibDate() async {
      //
      //             Duration waitingDuration = Duration(milliseconds: 50);
      //             await  r.device.discoverServices();
      //
      //             List<BluetoothService> allService = await r.device.discoverServices();
      //             // print(allService.length.toString());
      //
      //
      //             dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
      //
      //             BluetoothCharacteristic read = readWrite["read"];
      //
      //             BluetoothCharacteristic write = readWrite["write"];
      //
      //
      //
      //
      //             getIndex6()async{
      //               await Future.delayed(waitingDuration);
      //
      //               allService = await r.device.discoverServices();
      //               print(allService.length.toString());
      //
      //               dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
      //
      //               read = readWrite["read"];
      //
      //               write = readWrite["write"];
      //
      //
      //
      //
      //
      //
      //               await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
      //                   withoutResponse: OsDependentSettings().writeWithresponse);
      //               await read.read();
      //               await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
      //                   withoutResponse: OsDependentSettings().writeWithresponse);
      //               List<int> responseAray6 = await read.read();
      //               String responseInString6 = utf8.decode(responseAray6);
      //               String data6 =
      //               removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
      //               print("2 " + data6);
      //               String g = "ok";
      //
      //
      //
      //
      //               index6 = data6;
      //               sf.setString("index6", data6);
      //
      //               if(index6.length == 0){
      //                 try{
      //                   await getIndex6();
      //                 }catch(e){
      //                   await Future.delayed(waitingDuration);
      //                   await getIndex6();
      //                 }
      //               }
      //             }
      //
      //
      //             //await widget.d.disconnect();
      //
      //
      //             getIndex1()async{
      //               await Future.delayed(waitingDuration);
      //
      //               await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
      //                   withoutResponse: OsDependentSettings().writeWithresponse);
      //               await read.read();
      //               await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
      //                   withoutResponse: OsDependentSettings().writeWithresponse);
      //               List<int> responseAray2 = await read.read();
      //               String responseInString = utf8.decode(responseAray2);
      //               String data =
      //               removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
      //               print("2 " + data);
      //
      //
      //               index2 = data;
      //               sf.setString("index2", data);
      //
      //               if(index2.length == 0){
      //                 try{
      //                   await getIndex1();
      //                 }catch(e){
      //                   await Future.delayed(waitingDuration);
      //                   await getIndex1();
      //                 }
      //
      //
      //
      //
      //
      //               }else{
      //                 try{
      //                   await getIndex6();
      //                 }catch(e){
      //                   await Future.delayed(waitingDuration);
      //                   await getIndex6();
      //                 }
      //               }
      //             }
      //
      //             try{
      //               await getIndex1();
      //             }catch(e){
      //               await Future.delayed(waitingDuration);
      //               await getIndex1();
      //             }
      //
      //
      //
      //           // Navigator.pop(context);
      //           }
      //           initDeviceSlAndCalibDate();
      //
      //         });
      //         //return Text("ok");
      //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
      //         //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
      //         //Navigator.pop(context);
      //         //return ConnectedDevicePage(device: r.device);
      //         //return DeviceScreenLessDetails(r.device);
      //       },
      //     ),
      //     //     (r) => ScanResultTile(
      //     //   result: r,
      //     //   onTap: () => Navigator.of(context)
      //     //       .push(MaterialPageRoute(builder: (context) {
      //     //     r.device.connect(autoConnect: false);
      //     //     //return Text("ok");
      //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
      //     //     return   PerformTestPage(device: r.device,project:"o",);
      //     //     Navigator.pop(context);
      //     //     //return ConnectedDevicePage(device: r.device);
      //     //     //return DeviceScreenLessDetails(r.device);
      //     //   })),
      //     // ),
      //   )
      //       .toList(),
      // ),
    );
    return scanResult;
  }





  dynamic devices=[
    {
      "deviceName":"ELEMNT BOLT 957700"
    },
    {
      "deviceName":"Logitech BT Adapter"
    },
    {
      "deviceName":"VW Phone"
    },
  ];

  @override
  Widget build(BuildContext context) {


    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    //select device for calibration
    return  Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ThemeManager().getWhiteColor,

          //-----------------------AppBar of screen--------------
          appBar: PreferredSize(
            preferredSize: Size(0,kToolbarHeight),

            child:    ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
          ),

          //-----------------------Body of screen---------------
          body: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                //-----------------Back button----------
                Container(
                  margin: EdgeInsets.only(top: height*0.02,left: width*0.04),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: ThemeManager().getDarkGreenColor,
                          size: height * 0.02,
                        ),
                        Text(TextConst.backText,
                            style: interMedium.copyWith(
                                color: ThemeManager().getDarkGreenColor,
                                fontSize: width * 0.040)),
                      ],
                    ),
                  ),
                ),

                //--------Select device to calibrate text-------
                Container(
                  margin: EdgeInsets.only(top: height*0.03,left: width*0.05),
                  child: Text(TextConst.selectDeviceToCalibrateText,
                      style: interBold.copyWith(
                          color: ThemeManager().getBlackColor,
                          fontSize: width * 0.042)),
                ),
                dividingLine(),

                //--------------------List of available device and select device------------
                scanDevices(),

                //-------------------Scanning devices view----------------
                scanningDevicesView()

              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget availableDeviceList(){
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: devices.length ,
        itemBuilder: (BuildContext context, int index)
        {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: height*0.012,left: width*0.05,right: width*0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(devices[index]["deviceName"],  style: interMedium.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.040)),
                    InkWell(
                      onTap: (){
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             CalibrationAdvancedSettingScreen()));
                      },
                      child: Text("Select Device",style: interSemiBold.copyWith(
                          color: ThemeManager().getRedColor,
                          fontSize: width * 0.038)),
                    )
                  ],
                ),
              ),
              dividingLine(),
            ],
          );
        }
    );
  }

  Widget scanningDevicesView(){
    return Container(
      margin: EdgeInsets.only(top: height*0.02),

      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            margin: EdgeInsets.only(right: width*0.03),
            child: SpinKitWave(
              type: SpinKitWaveType.start,
              color: ThemeManager().getDarkGreenColor,
              size: width*0.09,
            ),
          ),

          Container(
            child: Text(TextConst.scanningDevicesText,
                style: interSemiBold.copyWith(
                    color: ThemeManager().getDarkGreenColor,
                    fontSize: width * 0.042)),
          ),
        ],
      ),
    );
  }

  Widget dividingLine(){
    return Container(
      height: height*0.0008,
      width: width,
      margin: EdgeInsets.only(top: height*0.017),
      color: ThemeManager().getBlackColor.withOpacity(.15),
    );
  }

}
