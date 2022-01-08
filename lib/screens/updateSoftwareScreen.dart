
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter_blue/flutter_blue.dart';

class UpdateSoftwareScreen extends StatefulWidget {
  const UpdateSoftwareScreen({Key ?key}) : super(key: key);

  @override
  _UpdateSoftwareScreenState createState() => _UpdateSoftwareScreenState();
}

class _UpdateSoftwareScreenState extends State<UpdateSoftwareScreen> {

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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

                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FirmwareSettingsPage(device: r.device,)));
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
    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //-----------------------AppBar of screen-------------
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
          TextConst.updateText,
          style: interBold.copyWith(
              color: ThemeManager().getBlackColor),
        ),
      ),

      //----------------------Body of screen----------------
      body: SingleChildScrollView(

        child: Container(
          margin: EdgeInsets.only(
              top: height * 0.02, left: width * 0.04, right: width * 0.04),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                child: Text(TextConst.softwareUpdatesText,style: interSemiBold.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.043)),
              ),
              Container(
                margin: EdgeInsets.only(top: height*0.02),
                child: Text("New firmware is available for your product",
                    style: interRegular.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.040)),
              ),
              Container(
                margin: EdgeInsets.only(top: height*0.003),
                child: Text("Staht v1.1",
                    style: interRegular.copyWith(
                        color: ThemeManager().getLightGrey5Color,
                        fontSize: width * 0.034)),
              ),

              //-----------------Steps for update----------------
              stepsDetail("Step 1.", " Please turn off your Staht tester"),
              stepsDetail("Step 2.",
                  " Connect your Staht tester to a power source using the USB cable"),
              stepsDetail("Step 3.",
                  " Check the Staht tester is showing the battery percentage"),
              dividingLine(),

              //----------------Confirm and continue Button------------
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Container(color: Colors.white,child: SafeArea(child: Scaffold(body: Column(
                            children: [
                              ApplicationAppbar().getAppbar(title: "Connect Device"),
                              scanDevices()
                            ],
                          ),),),)));


                },
                child: Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.03, top: height * 0.038),
                    child: ButtonView(
                        buttonLabel: TextConst.confirmAndContinueText)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stepsDetail(String step,String title){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        //-----Divider------
        dividingLine(),

        //----------Step number and description---------
        RichText(
          text: TextSpan(
            text: step,
            style: interBold.copyWith(
              color: ThemeManager().getBlackColor,
              fontSize: width * 0.038),
                children: <TextSpan>[
                  TextSpan(text: title,
                    style: interRegular.copyWith(
                        color: ThemeManager().getBlackColor,height: 1.4,
                        fontSize: width * 0.038)
                  ),
            ],
          ),
        ),

        //-----------Grey container below steps description-------
        stepsGreyContainer(),
      ],
    );
  }

  Widget dividingLine(){
    return  Container(
      margin: EdgeInsets.only(top: height*0.012,bottom: height*0.01),
      color:ThemeManager().getBlackColor.withOpacity(.15),
      height: height*0.0008,
      width: double.infinity,
    );
  }

  Widget stepsGreyContainer(){
    return  Container(
      margin: EdgeInsets.only(top: height*0.014),
      height: height*0.16,
      width: width,
      color: ThemeManager().getLightGrey10Color,
    );
  }

}
