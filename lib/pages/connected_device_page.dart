import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:io';
import 'dart:ui';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/services/os_dependent_settings.dart';
import 'package:connect/services/pdf.dart';
import 'package:connect/services/size_pannel.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'dart:math';
 import 'package:convert/convert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:connect/imageUtils.dart';
import 'package:connect/models/CustomImageModel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/CustomColorPallet.dart';
import 'package:connect/models/SavedData.dart';
import 'package:connect/models/todo.dart';
import 'package:connect/pages/TestDetailsPage.dart';
import 'package:connect/pages/colorSpectrumWidget.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/todo_card.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:io' show Platform;
List currentProductInfo = [];


String COMMAND_INDEX_1_1 = "GET|1|@";
String COMMAND_INDEX_1_SET = "SET|1|";
String COMMAND_INDEX_1__2 = "SET|1|mkl|@";
String COMMAND_INDEX_9_GET_DEVICE_NAME = "GET|9|@";
String COMMAND_INDEX_9__2 = "SET|9|";

String COMMAND_INDEX_25_1 = "GET|25|@";
String COMMAND_INDEX_23_1 = "GET|23|@";

String COMMAND_INDEX_22_GET_BATTERY = "GET|22|@";
String COMMAND_INDEX_22__2 = "SET|22|mkl|@";

String COMMAND_INDEX_1_GET_ = "GET|1|@";
String COMMAND_INDEX_2_GET_ = "GET|2|@";
String COMMAND_INDEX_2_SET = "SET|2|";
String COMMAND_INDEX_3_GET_ = "GET|3|@";
String COMMAND_INDEX_3_SET_ = "SET|3|";
String COMMAND_INDEX_4_GET_ = "GET|4|@";
String COMMAND_INDEX_4_SET_ = "SET|4|";
String COMMAND_INDEX_5_GET_ = "GET|5|@";
String COMMAND_INDEX_6_GET_ = "GET|6|@";
String COMMAND_INDEX_9_GET_ = "GET|9|@";
String COMMAND_INDEX_10_GET_ = "GET|10|@";
String COMMAND_INDEX_15_GET_ = "GET|15|@";

String COMMAND_INDEX_14_GET_CalCoefficient0thOrder = "GET|14|@";
String COMMAND_INDEX_14_SET_CalCoefficient0thOrder = "SET|14|";
String COMMAND_INDEX_5_SET_CalCoefficient0thOrder = "SET|5|";
String COMMAND_INDEX_6_SET_CalCoefficient0thOrder = "SET|6|";
String COMMAND_INDEX_7_SET_CalCoefficient0thOrder = "SET|7|";

String COMMAND_INDEX_13_GET_CalCoefficient1thOrder = "GET|13|@";
String COMMAND_INDEX_13_SET_CalCoefficient1thOrder = "SET|13|";

String COMMAND_INDEX_12_GET_CalCoefficient2thOrder = "GET|12|@";
String COMMAND_INDEX_12_SET_CalCoefficient2thOrder = "SET|12|";

String COMMAND_INDEX_11_GET_CalCoefficient3thOrder = "GET|11|@";
String COMMAND_INDEX_11_SET_CalCoefficient3thOrder = "SET|11|";

String COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS = "GET|18|@";
String COMMAND_INDEX_18_SET_DISPLAY_BRIGTNESS = "SET|18|";

String COMMAND_INDEX_21_GET_DISPLAY_FOREGROUND_COLOR = "GET|21|@";
String COMMAND_INDEX_21_SET_DISPLAY_FOREGROUND_COLOR = "SET|21|";

String COMMAND_INDEX_20_GET_DISPLAY_FOREGROUND_COLOR = "GET|20|@";
String COMMAND_INDEX_20_SET_DISPLAY_FOREGROUND_COLOR = "SET|20|";

String COMMAND_SUFFIX = "|@";
int LOOP_COUNT_TO_REMOVE_CACHE = 3;

List<String> allcommands = [
  COMMAND_INDEX_1_1,
  COMMAND_INDEX_1__2,
  COMMAND_INDEX_9_GET_DEVICE_NAME,
  COMMAND_INDEX_9__2,
  COMMAND_INDEX_22_GET_BATTERY,
  COMMAND_INDEX_22__2,
  COMMAND_INDEX_14_GET_CalCoefficient0thOrder,
  COMMAND_INDEX_14_SET_CalCoefficient0thOrder,
  COMMAND_INDEX_13_GET_CalCoefficient1thOrder,
  COMMAND_INDEX_13_SET_CalCoefficient1thOrder,
  COMMAND_INDEX_12_GET_CalCoefficient2thOrder,
  COMMAND_INDEX_12_SET_CalCoefficient2thOrder,
  COMMAND_INDEX_11_GET_CalCoefficient3thOrder,
  COMMAND_INDEX_11_SET_CalCoefficient3thOrder,
  COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS,
  COMMAND_INDEX_18_SET_DISPLAY_BRIGTNESS,
  COMMAND_INDEX_21_GET_DISPLAY_FOREGROUND_COLOR,
  COMMAND_INDEX_21_SET_DISPLAY_FOREGROUND_COLOR,
  COMMAND_INDEX_20_GET_DISPLAY_FOREGROUND_COLOR,
  COMMAND_INDEX_20_SET_DISPLAY_FOREGROUND_COLOR,
  COMMAND_SUFFIX
];

bool isBLEbg = false;

String removeCodesFromStrings(String data, String code) {
  String returnValue;
  returnValue = data.replaceAll(code.replaceAll("@", ""), "");

  returnValue = returnValue.substring(0, returnValue.length - 2);
  return returnValue;
}

class ConnectedDevicePage extends StatefulWidget {
  String notoiceBoard = "Nothing to show";
  String image = "Nothing to show";
  List<CustomColorPallete> allColors = [];
  BluetoothDevice device;
 late List<BluetoothService> allService;
  double progressValue = 0;
  FirebaseFirestore firestore;

  FirebaseAuth auth;

  //QueryDocumentSnapshot userBody;

  function(value) {
    //setDisplayForegroudColor(value.toString());
    print("vale from custom funtion " + value.toString());
  }
  String calibratorID;

  ConnectedDevicePage(
      { Key? key,required this.calibratorID,required this.device,required this.firestore, required this.auth})
      : super(key: key);
  late BluetoothCharacteristic characteristicWritePurpose;
  late BluetoothCharacteristic characteristicReadPurpose;
  String ICE_SERIAL_NUMBER = "Pres View to Fetch";
  String BATTERY_LEVEL = "Pres View to Fetch";
  String DEVICE_TITLE = "Pres View to Fetch";
  String COEFFICIENT_0_TH_ORDER = "Pres View to Fetch";
  String COEFFICIENT_1_TH_ORDER = "Pres View to Fetch";
  String COEFFICIENT_2_TH_ORDER = "Pres View to Fetch";
  String COEFFICIENT_3_TH_ORDER = "Pres View to Fetch";
  double DISPLAY_BRIGHTNESS = 0;
  String DISPLAY_FOREGROUND_COLOR = "Pres View to Fetch";

  @override
  _ConnectedDevicePageState createState() => _ConnectedDevicePageState();
}

class _ConnectedDevicePageState extends State<ConnectedDevicePage> {
  Future<void> fetchServices() async {
    String writeUid = "F0001111-0451-4000-B000-000000000000";
    String readUid = "F0001112-0451-4000-B000-000000000000";
    late  BluetoothCharacteristic read ;
    late BluetoothCharacteristic write ;
    await conenctDevice();
    List<BluetoothService> allService = await widget.device.services.first;
    print(allService.length.toString());
    setState(() {
      //Platform.isAndroid





        for (int i = 0;
        i < allService.length;
        i++) {

          for (int j = 0;
          j <
              allService[i].characteristics.length;
          j++) {
            print(i.toString()+"  "+j.toString());
            print(allService[i].toString());
            //print(allService[i].characteristics[j].uuid.toString());
            if (writeUid.toLowerCase() ==
                allService[i].characteristics[j].uuid
                    .toString().toLowerCase()) {
              print("h7");
              write = allService[i].characteristics[j];
              print("write found");
              break;
            }
          }
        }


        for (int i = 0;
        i < allService.length;
        i++) {

          for (int j = 0;
          j <
              allService[i].characteristics.length;
          j++) {
            print("h6");
            if (readUid.toLowerCase() ==
                allService[i].characteristics[j].uuid
                    .toString().toLowerCase()) {
              print("h7");
              read = allService[i].characteristics[j];
              print("read found");
              break;
            }
          }
        }


        // Android-specific code
        widget.characteristicReadPurpose = read;

        widget.characteristicWritePurpose = write;



    });
    //await fetchICSEserialNumber();

    // await fetchDeviceDisplayName();
    // downloadSplashImage();
  }

  Future<void> fetchDeviceDisplayName() async {
    if (widget.characteristicWritePurpose == null) {
      print("emplty null");
    } else {
      await widget.characteristicWritePurpose.write(
          StringToASCII(COMMAND_INDEX_9_GET_DEVICE_NAME),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.characteristicReadPurpose.read();
      String responseInString = utf8.decode(responseAray);
      setState(() {
        widget.DEVICE_TITLE = removeCodesFromStrings(
            responseInString, COMMAND_INDEX_9_GET_DEVICE_NAME);
      });
    }

    // await fetchBatteryLevel();
  }

  Future<void> fetchBatteryLevel() async {
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_22_GET_BATTERY),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);
    setState(() {
      widget.BATTERY_LEVEL = removeCodesFromStrings(
          responseInString, COMMAND_INDEX_22_GET_BATTERY);
    });
  }

  Future<String> CalCoefficient0thOrder() async {
    print("write " + COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_14_GET_CalCoefficient0thOrder),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);
    print("read " + responseInString);
    setState(() {
      widget.COEFFICIENT_0_TH_ORDER = removeCodesFromStrings(
          responseInString, COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
    });
    return widget.COEFFICIENT_0_TH_ORDER;
  }

  Future<void> CalCoefficient1thOrder() async {
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_13_GET_CalCoefficient1thOrder),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);
    setState(() {
      widget.COEFFICIENT_1_TH_ORDER = removeCodesFromStrings(
          responseInString, COMMAND_INDEX_13_GET_CalCoefficient1thOrder);
    });
  }

  Future<void> CalCoefficient2thOrder() async {
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_12_GET_CalCoefficient2thOrder),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);
    setState(() {
      widget.COEFFICIENT_2_TH_ORDER = removeCodesFromStrings(
          responseInString, COMMAND_INDEX_12_GET_CalCoefficient2thOrder);
    });
  }

  Future<void> CalCoefficient3thOrder() async {
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_11_GET_CalCoefficient3thOrder),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);
    setState(() {
      widget.COEFFICIENT_3_TH_ORDER = removeCodesFromStrings(
          responseInString, COMMAND_INDEX_11_GET_CalCoefficient3thOrder);
    });
  }

  Future<void> getDisplayBrightness() async {
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);

    setState(() {
      widget.DISPLAY_BRIGHTNESS = double.parse(removeCodesFromStrings(
          responseInString, COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS));
    });
  }

  Future<void> getDisplayForegroundColor() async {
    await widget.characteristicWritePurpose.write(
        StringToASCII(COMMAND_INDEX_21_GET_DISPLAY_FOREGROUND_COLOR),
        withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await widget.characteristicReadPurpose.read();
    String responseInString = utf8.decode(responseAray);

    setState(() {
      widget.DISPLAY_FOREGROUND_COLOR = removeCodesFromStrings(
          responseInString, COMMAND_INDEX_21_GET_DISPLAY_FOREGROUND_COLOR);
    });
  }

  Future<void> setDisplayBrightness(double value) async {
    String correctedValue = "0";

    if (isBLEbg == false) {
      isBLEbg = true;
      print(COMMAND_INDEX_18_SET_DISPLAY_BRIGTNESS +
          value.toString() +
          COMMAND_SUFFIX);

      await widget.characteristicWritePurpose.write(
          StringToASCII(COMMAND_INDEX_18_SET_DISPLAY_BRIGTNESS +
              value.toStringAsFixed(2) +
              COMMAND_SUFFIX),
          withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int> responseAray = await widget.characteristicReadPurpose.read();
      //String responseInString = utf8.decode(responseAray);

      // setState(() {widget.DISPLAY_BRIGHTNESS = double.parse(removeCodesFromStrings(responseInString, COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS));});
      isBLEbg = false;
    }
  }

  Future<void> writeImage() async {
    // List<BluetoothService> allService = await widget.device.services.last;
    // print(allService.length.toString());
    // setState(() {
    //   widget.characteristicReadPurpose = allService[3].characteristics[1];
    //
    //   widget.characteristicWritePurpose = allService[3].characteristics[0];
    //   print("service size " + allService.length.toString());
    //   print("char size " + (allService[3].characteristics.length.toString()));
    // });

     widget.device.services.listen((event) async{
       setState(() {
       //  widget.characteristicReadPurpose = event[3].characteristics[1];

       //  widget.characteristicWritePurpose = event[3].characteristics[0];
         print("service size " + event.length.toString());
         print("char size " + (event[3].characteristics.length.toString()));
       });




    setState(() {
      widget.progressValue = 0;
    });
    await widget.device.requestMtu(244);
    print("method clicked ");
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    //Color color = Color(int.parse(""));
    // print("image " + pickedFile.path);

    // List<int> allPix = getImagesDataInt(pickedFile.path);
    List<int> allColor = [];
    List<String> ColorToSend = [];
    List<List<int>> triColor = [];
    // print("all piz size is " + allPix.length.toString());

    //  print("red " + color.red.toString());
    //print("g " + color.green.toString());
    //print("b " + color.blue.toString());
    // getImagesDataInt(pickedFile.path);

    ImageModelCustom imageModelCustom =await getImagesDataInt(pickedFile!.path);

    //  Uint8List uint8list =await pickedFile.readAsBytes();
    //  print("sampple one");
    //  print(uint8list);
    //  print(uint8list.length);
    print("sampple two");
    //  print(inpPIx.length);

    for (int i = 0; i < (imageModelCustom.allPixels.length / 3); i++) {
      //0,1,2

      int red = imageModelCustom.allPixels[i * 3]; //0,3,6
      int green = imageModelCustom.allPixels[i * 3 + 1]; //1,4,7
      int blue = imageModelCustom.allPixels[i * 3 + 2]; //2,5,8
      // allColor.add(red.toString() + "," + green.toString() + "," + blue.toString());
/*
      int rationalRed = (((0.5 * red * 32) / 256).floor());
      int rationalGreen = (((4 * green * 64) / 256).floor());
      int rationalBlue = (((blue * 32) / 256).floor());

      String redHex = rationalRed.toRadixString(16);
      String greenHex = rationalGreen.toRadixString(16);
      String blueHex = rationalBlue.toRadixString(16);

      redHex = redHex.substring(redHex.length - 1);
      blueHex = blueHex.substring(blueHex.length - 1);

      if (greenHex.length == 1) {
        greenHex = "0" + greenHex;
      }

      String fourCharColor = redHex + greenHex + blueHex;

 */
      int r = red >> 3;
      int g = green >> 2;
      int b = blue >> 3;
      int color16Bit = (r << 11) | (g << 5) | (b << 0);

      print(color16Bit);
      print(color16Bit.toRadixString(16));
      String cc = color16Bit.toRadixString(16).toUpperCase();
      String cc2;
      cc2 = cc;
      Color ccc = Color(color16Bit);
      allColor.add(color16Bit);

      if (cc.length == 3) {
        cc2 = "0" + cc;
      }
      if (cc.length == 2) {
        cc2 = "00" + cc;
      }
      if (cc.length == 1) {
        cc2 = "000" + cc;
      }
      // ColorToSend.add(cc.length==4?cc:"FFFF");
      print("see nxt");
      print("length " + cc.length.toString());
      print("old  " + cc);
      //print( "corrected  "+ cc2);
      //print( "red => "+red.toString()+"green=> "+"blue=> "+blue.toString()+"=="+"converted color " + cc2);
      ColorToSend.add(cc2);
    }
    //  print(inpPIx);
    // print(ColorToSend.toString());

    //  List<int> allPixBinary = getImagesDataInt(pickedFile.path);
    //  for (int i = 0; i < allPixBinary.length; i++) {
    //  ColorToSend.add(allPixBinary[i]>127?"0000":"FFFF");
    // }
    //  print(ColorToSend[0].toString());

    // initState();

    List RGBAList;

    String red = "F800";
    String green = "07E0";
    String blue = "001F";
    String white = "FFFF";
    String index = "1";
    String ending = "@";
    String imageWriteCode = "SET|26|1||A55A80A0|@";

    int PixelPerCommand = 55;

    String streaRestart = "SET|26|0|00|@";
    // print(ColorToSend.toString());assets/splash_images/staht_org_id
    // FirebaseFirestore.instance
    //     .collection("splash_images")
    //     .doc("staht_org_id")
    //     .delete();
    // FirebaseFirestore.instance
    //     .collection("splash_images")
    //     .doc("staht_org_id")
    //     .set({
    //   "data": jsonEncode(ColorToSend),
    //   "height": imageModelCustom.height.toRadixString(16).toUpperCase(),
    //   "width": imageModelCustom.width.toRadixString(16).toUpperCase(),
    //   "intvalue": allColor.toString()
    // });
    if (true) {
      Duration duration = Duration(milliseconds: 1000);
      Future.delayed(duration, () async {
        await widget.characteristicWritePurpose
            .write(StringToASCII(streaRestart), withoutResponse: OsDependentSettings().writeWithresponse);
        Future.delayed(duration, () async {
         // List<int> respnse1 = await widget.characteristicReadPurpose.read();

          Future.delayed(duration, () async {
            await widget.characteristicWritePurpose
                .write(StringToASCII(imageWriteCode), withoutResponse: OsDependentSettings().writeWithresponse);
            Future.delayed(duration, () async {
             // List<int> respnse1 = await widget.characteristicReadPurpose.read();

              Future.delayed(duration, () async {
                int totalPixel = ColorToSend.length;
                double iteration = totalPixel / PixelPerCommand;
                List<List<String>> subListArray = [];
                for (int i = 0; i < iteration; i++) {
                  if (((i * PixelPerCommand) + PixelPerCommand) <
                      ColorToSend.length) {
                    subListArray.add(ColorToSend.sublist((i * PixelPerCommand),
                        ((i * PixelPerCommand) + PixelPerCommand)));
                  } else {
                    subListArray.add(ColorToSend.sublist(
                        (i * PixelPerCommand), (ColorToSend.length - 1)));
                  }
                }

                int lastPrint = 0 ;
                int p = 0 ;




               int pushIndex = 0 ;
               bool checkNeed(){
                  if(pushIndex < subListArray.length-1){

                    return true;

                  }else return false;



                }

                pushData()async{
                  String BATCH_OF_PIXEL = "";
                  for (int q = 0; q < subListArray[pushIndex].length; q++) {
                    BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[pushIndex][q];
                  }
                  String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                  // List<int> commandData = StringToASCII(loodCommand);
                  List<int> commandData = utf8.encode(loodCommand);
                  // print("command to send " + loodCommand);
                  print("size " + commandData.length.toString());

                  if (commandData.length.isEven) {
                    //i have data length even

                  }
                  // int current = DateTime.now().millisecondsSinceEpoch;
                  //print("passed "+(lastPrint -current).toString());
                  // lastPrint = current;

                  print("before write "+DateTime.now().millisecondsSinceEpoch.toString());

                  await widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                  print("after write "+DateTime.now().millisecondsSinceEpoch.toString());

                  print("done " + (pushIndex * 100 / subListArray.length).toString() + "%");
                  setState(() {
                    widget.progressValue = (pushIndex / subListArray.length);
                  });
                  pushIndex++;

                  if(checkNeed() == true){
                    pushData();
                  }
                }


                if(checkNeed() == true){
                  pushData();
                }







/*
                for (int p = 0; p < subListArray.length; p++) {
                  Future.delayed(Duration(milliseconds: (0 + (100*p+100))), () async {
                    //delay 1+p
                    String BATCH_OF_PIXEL = "";
                    for (int q = 0; q < subListArray[p].length; q++) {
                      BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[p][q];
                    }
                    String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    // List<int> commandData = StringToASCII(loodCommand);
                    List<int> commandData = utf8.encode(loodCommand);
                   // print("command to send " + loodCommand);
                    print("size " + commandData.length.toString());

                    if (commandData.length.isEven) {
                      //i have data length even

                    }
                   // int current = DateTime.now().millisecondsSinceEpoch;
                    //print("passed "+(lastPrint -current).toString());
                   // lastPrint = current;

                    print("before write "+DateTime.now().millisecondsSinceEpoch.toString());

                    await widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                    print("after write "+DateTime.now().millisecondsSinceEpoch.toString());

                    print("done " + (p * 100 / subListArray.length).toString() + "%");
                    setState(() {
                      widget.progressValue = (p / subListArray.length);
                    });

                    // Future.delayed(Duration(seconds: (2 + p)), () async {
                    //   //delay 1+p
                    //   List<int> res =
                    //       await widget.characteristicReadPurpose.read();
                    //
                    //   print("response string " + utf8.decode(res));
                    // });
                  });
                }
                */


                //  print("prepared pixles   "+loodCommand);
              });
            });
          });
        });
      });
    }
     });
  }
  Future<void> writeImageP() async {
    // List<BluetoothService> allService = await widget.device.services.last;
    // print(allService.length.toString());
    // setState(() {
    //   widget.characteristicReadPurpose = allService[3].characteristics[1];
    //
    //   widget.characteristicWritePurpose = allService[3].characteristics[0];
    //   print("service size " + allService.length.toString());
    //   print("char size " + (allService[3].characteristics.length.toString()));
    // });

    widget.device.services.listen((event) async{
      setState(() {
       // widget.characteristicReadPurpose = event[3].characteristics[1];

       // widget.characteristicWritePurpose = event[3].characteristics[0];
        print("service size " + event.length.toString());
        print("char size " + (event[3].characteristics.length.toString()));
      });




      setState(() {
        widget.progressValue = 0;
      });
      await widget.device.requestMtu(244);
      print("method clicked ");
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      //Color color = Color(int.parse(""));
      // print("image " + pickedFile.path);

      // List<int> allPix = getImagesDataInt(pickedFile.path);
      List<int> allColor = [];
      List<String> ColorToSend = [];
      List<List<int>> triColor = [];
      // print("all piz size is " + allPix.length.toString());

      //  print("red " + color.red.toString());
      //print("g " + color.green.toString());
      //print("b " + color.blue.toString());
      // getImagesDataInt(pickedFile.path);

      ImageModelCustom imageModelCustom =await getImagesDataInt(pickedFile!.path);

      //  Uint8List uint8list =await pickedFile.readAsBytes();
      //  print("sampple one");
      //  print(uint8list);
      //  print(uint8list.length);
      print("sampple two");
      //  print(inpPIx.length);

      for (int i = 0; i < (imageModelCustom.allPixels.length / 3); i++) {
        //0,1,2

        int red = imageModelCustom.allPixels[i * 3]; //0,3,6
        int green = imageModelCustom.allPixels[i * 3 + 1]; //1,4,7
        int blue = imageModelCustom.allPixels[i * 3 + 2]; //2,5,8
        // allColor.add(red.toString() + "," + green.toString() + "," + blue.toString());
/*
      int rationalRed = (((0.5 * red * 32) / 256).floor());
      int rationalGreen = (((4 * green * 64) / 256).floor());
      int rationalBlue = (((blue * 32) / 256).floor());

      String redHex = rationalRed.toRadixString(16);
      String greenHex = rationalGreen.toRadixString(16);
      String blueHex = rationalBlue.toRadixString(16);

      redHex = redHex.substring(redHex.length - 1);
      blueHex = blueHex.substring(blueHex.length - 1);

      if (greenHex.length == 1) {
        greenHex = "0" + greenHex;
      }

      String fourCharColor = redHex + greenHex + blueHex;

 */
        int r = red >> 3;
        int g = green >> 2;
        int b = blue >> 3;
        int color16Bit = (r << 11) | (g << 5) | (b << 0);

        print(color16Bit);
        print(color16Bit.toRadixString(16));
        String cc = color16Bit.toRadixString(16).toUpperCase();
        String cc2;
        cc2 = cc;
        Color ccc = Color(color16Bit);
        allColor.add(color16Bit);

        if (cc.length == 3) {
          cc2 = "0" + cc;
        }
        if (cc.length == 2) {
          cc2 = "00" + cc;
        }
        if (cc.length == 1) {
          cc2 = "000" + cc;
        }
        // ColorToSend.add(cc.length==4?cc:"FFFF");
        print("see nxt");
        print("length " + cc.length.toString());
        print("old  " + cc);
        //print( "corrected  "+ cc2);
        //print( "red => "+red.toString()+"green=> "+"blue=> "+blue.toString()+"=="+"converted color " + cc2);
        ColorToSend.add(cc2);
      }
      //  print(inpPIx);
      // print(ColorToSend.toString());

      //  List<int> allPixBinary = getImagesDataInt(pickedFile.path);
      //  for (int i = 0; i < allPixBinary.length; i++) {
      //  ColorToSend.add(allPixBinary[i]>127?"0000":"FFFF");
      // }
      //  print(ColorToSend[0].toString());

      // initState();

      List RGBAList;

      String red = "F800";
      String green = "07E0";
      String blue = "001F";
      String white = "FFFF";
      String index = "1";
      String ending = "@";
      String imageWriteCode = "SET|26|1||A55AFFFF|@";

      int PixelPerCommand = 55;

      String streaRestart = "SET|26|0|00|@";
      // print(ColorToSend.toString());assets/splash_images/staht_org_id
      // FirebaseFirestore.instance
      //     .collection("splash_images")
      //     .doc("staht_org_id")
      //     .delete();
      // FirebaseFirestore.instance
      //     .collection("splash_images")
      //     .doc("staht_org_id")
      //     .set({
      //   "data": jsonEncode(ColorToSend),
      //   "height": imageModelCustom.height.toRadixString(16).toUpperCase(),
      //   "width": imageModelCustom.width.toRadixString(16).toUpperCase(),
      //   "intvalue": allColor.toString()
      // });
      if (true) {
        Duration duration = Duration(milliseconds: 1000);
        Future.delayed(duration, () async {
          await widget.characteristicWritePurpose
              .write(StringToASCII(streaRestart), withoutResponse: OsDependentSettings().writeWithresponse);
          Future.delayed(duration, () async {
            // List<int> respnse1 = await widget.characteristicReadPurpose.read();

            Future.delayed(duration, () async {
              await widget.characteristicWritePurpose
                  .write(StringToASCII(imageWriteCode), withoutResponse: OsDependentSettings().writeWithresponse);
              Future.delayed(duration, () async {
                // List<int> respnse1 = await widget.characteristicReadPurpose.read();

                Future.delayed(duration, () async {
                  int totalPixel = ColorToSend.length;
                  double iteration = totalPixel / PixelPerCommand;
                  List<List<String>> subListArray = [];
                  for (int i = 0; i < iteration; i++) {
                    if (((i * PixelPerCommand) + PixelPerCommand) <
                        ColorToSend.length) {
                      subListArray.add(ColorToSend.sublist((i * PixelPerCommand),
                          ((i * PixelPerCommand) + PixelPerCommand)));
                    } else {
                      subListArray.add(ColorToSend.sublist(
                          (i * PixelPerCommand), (ColorToSend.length - 1)));
                    }
                  }
                  //
                  // int lastPrint = 0 ;
                  // int p = 0 ;
                  //
                  //
                  //
                  //
                  // int pushIndex = 0 ;
                  // bool checkNeed(){
                  //   if(pushIndex < subListArray.length-1){
                  //
                  //     return true;
                  //
                  //   }else return false;
                  //
                  //
                  //
                  // }
                  //
                  // pushData()async{
                  //   String BATCH_OF_PIXEL = "";
                  //   for (int q = 0; q < subListArray[pushIndex].length; q++) {
                  //     BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[pushIndex][q];
                  //   }
                  //   String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                  //   // List<int> commandData = StringToASCII(loodCommand);
                  //   List<int> commandData = utf8.encode(loodCommand);
                  //   // print("command to send " + loodCommand);
                  //   print("size " + commandData.length.toString());
                  //
                  //   if (commandData.length.isEven) {
                  //     //i have data length even
                  //
                  //   }
                  //   // int current = DateTime.now().millisecondsSinceEpoch;
                  //   //print("passed "+(lastPrint -current).toString());
                  //   // lastPrint = current;
                  //
                  //   print("before write "+DateTime.now().millisecondsSinceEpoch.toString());
                  //
                  //   await widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                  //   print("after write "+DateTime.now().millisecondsSinceEpoch.toString());
                  //
                  //   print("done " + (pushIndex * 100 / subListArray.length).toString() + "%");
                  //   setState(() {
                  //     widget.progressValue = (pushIndex / subListArray.length);
                  //   });
                  //   pushIndex++;
                  //
                  //   if(checkNeed() == true){
                  //     pushData();
                  //   }
                  // }
                  //
                  //
                  // if(checkNeed() == true){
                  //   pushData();
                  // }








                for (int p = 0; p < subListArray.length; p++) {

                    //delay 1+p
                    String BATCH_OF_PIXEL = "";
                    for (int q = 0; q < subListArray[p].length; q++) {
                      BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[p][q];
                    }
                    String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    // List<int> commandData = StringToASCII(loodCommand);
                    List<int> commandData = utf8.encode(loodCommand);
                   // print("command to send " + loodCommand);
                    print("size " + commandData.length.toString());

                    if (commandData.length.isEven) {
                      //i have data length even

                    }
                   // int current = DateTime.now().millisecondsSinceEpoch;
                    //print("passed "+(lastPrint -current).toString());
                   // lastPrint = current;

                    print("before write "+DateTime.now().millisecondsSinceEpoch.toString());

                     widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                    print("after write "+DateTime.now().millisecondsSinceEpoch.toString());

                    print("done " + (p * 100 / subListArray.length).toString() + "%");
                    setState(() {
                      widget.progressValue = (p / subListArray.length);
                    });

                    // Future.delayed(Duration(seconds: (2 + p)), () async {
                    //   //delay 1+p
                    //   List<int> res =
                    //       await widget.characteristicReadPurpose.read();
                    //
                    //   print("response string " + utf8.decode(res));
                    // });

                }



                  //  print("prepared pixles   "+loodCommand);
                });
              });
            });
          });
        });
      }
    });
  }
  Future<void> writeImageGallary() async {
    // List<BluetoothService> allService = await widget.device.services.last;
    // print(allService.length.toString());
    // setState(() {
    //   widget.characteristicReadPurpose = allService[3].characteristics[1];
    //
    //   widget.characteristicWritePurpose = allService[3].characteristics[0];
    //   print("service size " + allService.length.toString());
    //   print("char size " + (allService[3].characteristics.length.toString()));
    // });

    widget.device.services.listen((event) async{
      setState(() {
       // widget.characteristicReadPurpose = event[3].characteristics[1];

       // widget.characteristicWritePurpose = event[3].characteristics[0];
        print("service size " + event.length.toString());
        print("char size " + (event[3].characteristics.length.toString()));
      });




      setState(() {
        widget.progressValue = 0;
      });
      await widget.device.requestMtu(244);
      print("method clicked ");
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);


      //Color color = Color(int.parse(""));
      // print("image " + pickedFile.path);

      // List<int> allPix = getImagesDataInt(pickedFile.path);
      List<int> allColor = [];
      List<String> ColorToSend = [];
      List<List<int>> triColor = [];
      // print("all piz size is " + allPix.length.toString());

      //  print("red " + color.red.toString());
      //print("g " + color.green.toString());
      //print("b " + color.blue.toString());
      // getImagesDataInt(pickedFile.path);
      
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot staht = await firestore.collection("Staht").get();
      String image = staht.docs.first.get("baseDeviceImage");
      //String imagePath =  "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/staht%20image%2FMicrosoftTeams-image%20(25).png?alt=media&token=56dbc86d-233f-4f10-9dea-64ddc330f144";
     // http.Response res= await http.get(Uri.parse(image));
      //Uint8List list = base64Decode(image);

      ImageModelCustom imageModelCustom =await getImagesDataInt(pickedFile!.path);
      //ImageModelCustom imageModelCustom =await getImagesDataIntByte(list);

      //  Uint8List uint8list =await pickedFile.readAsBytes();
      //  print("sampple one");
      //  print(uint8list);
      //  print(uint8list.length);
      print("sampple two");
      //  print(inpPIx.length);

      for (int i = 0; i < (imageModelCustom.allPixels.length / 3); i++) {
        //0,1,2

        int red = imageModelCustom.allPixels[i * 3]; //0,3,6
        int green = imageModelCustom.allPixels[i * 3 + 1]; //1,4,7
        int blue = imageModelCustom.allPixels[i * 3 + 2]; //2,5,8
        // allColor.add(red.toString() + "," + green.toString() + "," + blue.toString());
/*
      int rationalRed = (((0.5 * red * 32) / 256).floor());
      int rationalGreen = (((4 * green * 64) / 256).floor());
      int rationalBlue = (((blue * 32) / 256).floor());

      String redHex = rationalRed.toRadixString(16);
      String greenHex = rationalGreen.toRadixString(16);
      String blueHex = rationalBlue.toRadixString(16);

      redHex = redHex.substring(redHex.length - 1);
      blueHex = blueHex.substring(blueHex.length - 1);

      if (greenHex.length == 1) {
        greenHex = "0" + greenHex;
      }

      String fourCharColor = redHex + greenHex + blueHex;

 */
        int r = red >> 3;
        int g = green >> 2;
        int b = blue >> 3;
        int color16Bit = (r << 11) | (g << 5) | (b << 0);

        print(color16Bit);
        print(color16Bit.toRadixString(16));
        String cc = color16Bit.toRadixString(16).toUpperCase();
        String cc2;
        cc2 = cc;
        Color ccc = Color(color16Bit);
        allColor.add(color16Bit);

        if (cc.length == 3) {
          cc2 = "0" + cc;
        }
        if (cc.length == 2) {
          cc2 = "00" + cc;
        }
        if (cc.length == 1) {
          cc2 = "000" + cc;
        }
        // ColorToSend.add(cc.length==4?cc:"FFFF");
        print("see nxt");
        print("length " + cc.length.toString());
        print("old  " + cc);
        //print( "corrected  "+ cc2);
        //print( "red => "+red.toString()+"green=> "+"blue=> "+blue.toString()+"=="+"converted color " + cc2);
        ColorToSend.add(cc2);
      }
      //  print(inpPIx);
      // print(ColorToSend.toString());

      //  List<int> allPixBinary = getImagesDataInt(pickedFile.path);
      //  for (int i = 0; i < allPixBinary.length; i++) {
      //  ColorToSend.add(allPixBinary[i]>127?"0000":"FFFF");
      // }
      //  print(ColorToSend[0].toString());

      // initState();

      List RGBAList;

      String red = "F800";
      String green = "07E0";
      String blue = "001F";
      String white = "FFFF";
      String index = "1";
      String ending = "@";
      String imageWriteCode = "SET|26|1||A55A80A0|@";

      int PixelPerCommand = 55;

      String streaRestart = "SET|26|0|00|@";
      // print(ColorToSend.toString());assets/splash_images/staht_org_id
      // FirebaseFirestore.instance
      //     .collection("splash_images")
      //     .doc("staht_org_id")
      //     .delete();
      // FirebaseFirestore.instance
      //     .collection("splash_images")
      //     .doc("staht_org_id")
      //     .set({
      //   "data": jsonEncode(ColorToSend),
      //   "height": imageModelCustom.height.toRadixString(16).toUpperCase(),
      //   "width": imageModelCustom.width.toRadixString(16).toUpperCase(),
      //   "intvalue": allColor.toString()
      // });
      if (true) {
        Duration duration = Duration(milliseconds: 1000);
        Future.delayed(duration, () async {
          await widget.characteristicWritePurpose
              .write(StringToASCII(streaRestart), withoutResponse: OsDependentSettings().writeWithresponse);
          Future.delayed(duration, () async {
            // List<int> respnse1 = await widget.characteristicReadPurpose.read();

            Future.delayed(duration, () async {
              await widget.characteristicWritePurpose
                  .write(StringToASCII(imageWriteCode), withoutResponse: OsDependentSettings().writeWithresponse);
              Future.delayed(duration, () async {
                // List<int> respnse1 = await widget.characteristicReadPurpose.read();

                Future.delayed(duration, () async {
                  int totalPixel = ColorToSend.length;
                  double iteration = totalPixel / PixelPerCommand;
                  List<List<String>> subListArray = [];
                  for (int i = 0; i < iteration; i++) {
                    if (((i * PixelPerCommand) + PixelPerCommand) <
                        ColorToSend.length) {
                      subListArray.add(ColorToSend.sublist((i * PixelPerCommand),
                          ((i * PixelPerCommand) + PixelPerCommand)));
                    } else {
                      subListArray.add(ColorToSend.sublist(
                          (i * PixelPerCommand), (ColorToSend.length - 1)));
                    }
                  }

                  int lastPrint = 0 ;
                  int p = 0 ;




                  int pushIndex = 0 ;
                  bool checkNeed(){
                    if(pushIndex < subListArray.length-1){

                      return true;

                    }else return false;



                  }

                  pushData()async{
                    String BATCH_OF_PIXEL = "";
                    for (int q = 0; q < subListArray[pushIndex].length; q++) {
                      BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[pushIndex][q];
                    }
                    String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    // List<int> commandData = StringToASCII(loodCommand);
                    List<int> commandData = utf8.encode(loodCommand);
                    // print("command to send " + loodCommand);
                    print("size " + commandData.length.toString());

                    if (commandData.length.isEven) {
                      //i have data length even

                    }
                    // int current = DateTime.now().millisecondsSinceEpoch;
                    //print("passed "+(lastPrint -current).toString());
                    // lastPrint = current;

                    print("before write "+DateTime.now().millisecondsSinceEpoch.toString());

                    Future.delayed(Duration(milliseconds:10), () async {
                      try{
                        await widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                        print("after write "+DateTime.now().millisecondsSinceEpoch.toString());

                        print("done " + (pushIndex * 100 / subListArray.length).toString() + "%");
                        setState(() {
                          widget.progressValue = (pushIndex / subListArray.length);
                        });
                        pushIndex++;

                        if(checkNeed() == true){
                          pushData();
                        }
                      }catch(e){
                        print("in ed");
                        print(e);

                      }

                    });



                  }


                  if(checkNeed() == true){
                    pushData();
                  }







/*
                for (int p = 0; p < subListArray.length; p++) {
                  Future.delayed(Duration(milliseconds: (0 + (100*p+100))), () async {
                    //delay 1+p
                    String BATCH_OF_PIXEL = "";
                    for (int q = 0; q < subListArray[p].length; q++) {
                      BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[p][q];
                    }
                    String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    // List<int> commandData = StringToASCII(loodCommand);
                    List<int> commandData = utf8.encode(loodCommand);
                   // print("command to send " + loodCommand);
                    print("size " + commandData.length.toString());

                    if (commandData.length.isEven) {
                      //i have data length even

                    }
                   // int current = DateTime.now().millisecondsSinceEpoch;
                    //print("passed "+(lastPrint -current).toString());
                   // lastPrint = current;

                    print("before write "+DateTime.now().millisecondsSinceEpoch.toString());

                    await widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                    print("after write "+DateTime.now().millisecondsSinceEpoch.toString());

                    print("done " + (p * 100 / subListArray.length).toString() + "%");
                    setState(() {
                      widget.progressValue = (p / subListArray.length);
                    });

                    // Future.delayed(Duration(seconds: (2 + p)), () async {
                    //   //delay 1+p
                    //   List<int> res =
                    //       await widget.characteristicReadPurpose.read();
                    //
                    //   print("response string " + utf8.decode(res));
                    // });
                  });
                }
                */


                  //  print("prepared pixles   "+loodCommand);
                });
              });
            });
          });
        });
      }
    });
  }
  Future<void> writeImageGallaryP() async {
    // List<BluetoothService> allService = await widget.device.services.last;
    // print(allService.length.toString());
    // setState(() {
    //   widget.characteristicReadPurpose = allService[3].characteristics[1];
    //
    //   widget.characteristicWritePurpose = allService[3].characteristics[0];
    //   print("service size " + allService.length.toString());
    //   print("char size " + (allService[3].characteristics.length.toString()));
    // });

    widget.device.services.listen((event) async{
      setState(() {
       // widget.characteristicReadPurpose = event[3].characteristics[1];

    //    widget.characteristicWritePurpose = event[3].characteristics[0];
        print("service size " + event.length.toString());
        print("char size " + (event[3].characteristics.length.toString()));
      });




      setState(() {
        widget.progressValue = 0;
      });
      await widget.device.requestMtu(244);
      print("method clicked ");
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);


      //Color color = Color(int.parse(""));
      // print("image " + pickedFile.path);

      // List<int> allPix = getImagesDataInt(pickedFile.path);
      List<int> allColor = [];
      List<String> ColorToSend = [];
      List<List<int>> triColor = [];
      // print("all piz size is " + allPix.length.toString());

      //  print("red " + color.red.toString());
      //print("g " + color.green.toString());
      //print("b " + color.blue.toString());
      // getImagesDataInt(pickedFile.path);

      ImageModelCustom imageModelCustom =await getImagesDataIntW(pickedFile!.path);

      //  Uint8List uint8list =await pickedFile.readAsBytes();
      //  print("sampple one");
      //  print(uint8list);
      //  print(uint8list.length);
      print("sampple two");
      //  print(inpPIx.length);

      for (int i = 0; i < (imageModelCustom.allPixels.length / 3); i++) {
        //0,1,2

        int red = imageModelCustom.allPixels[i * 3]; //0,3,6
        int green = imageModelCustom.allPixels[i * 3 + 1]; //1,4,7
        int blue = imageModelCustom.allPixels[i * 3 + 2]; //2,5,8
        // allColor.add(red.toString() + "," + green.toString() + "," + blue.toString());
/*
      int rationalRed = (((0.5 * red * 32) / 256).floor());
      int rationalGreen = (((4 * green * 64) / 256).floor());
      int rationalBlue = (((blue * 32) / 256).floor());

      String redHex = rationalRed.toRadixString(16);
      String greenHex = rationalGreen.toRadixString(16);
      String blueHex = rationalBlue.toRadixString(16);

      redHex = redHex.substring(redHex.length - 1);
      blueHex = blueHex.substring(blueHex.length - 1);

      if (greenHex.length == 1) {
        greenHex = "0" + greenHex;
      }

      String fourCharColor = redHex + greenHex + blueHex;

 */
        int r = red >> 3;
        int g = green >> 2;
        int b = blue >> 3;
        int color16Bit = (r << 11) | (g << 5) | (b << 0);

        print(color16Bit);
        print(color16Bit.toRadixString(16));
        String cc = color16Bit.toRadixString(16).toUpperCase();
        String cc2;
        cc2 = cc;
        Color ccc = Color(color16Bit);
        allColor.add(color16Bit);

        if (cc.length == 3) {
          cc2 = "0" + cc;
        }
        if (cc.length == 2) {
          cc2 = "00" + cc;
        }
        if (cc.length == 1) {
          cc2 = "000" + cc;
        }
        // ColorToSend.add(cc.length==4?cc:"FFFF");
        print("see nxt");
        print("length " + cc.length.toString());
        print("old  " + cc);
        //print( "corrected  "+ cc2);
        //print( "red => "+red.toString()+"green=> "+"blue=> "+blue.toString()+"=="+"converted color " + cc2);
        ColorToSend.add(cc2);
      }
      //  print(inpPIx);
      // print(ColorToSend.toString());

      //  List<int> allPixBinary = getImagesDataInt(pickedFile.path);
      //  for (int i = 0; i < allPixBinary.length; i++) {
      //  ColorToSend.add(allPixBinary[i]>127?"0000":"FFFF");
      // }
      //  print(ColorToSend[0].toString());

      // initState();

      List RGBAList;

      String red = "F800";
      String green = "07E0";
      String blue = "001F";
      String white = "FFFF";
      String index = "1";
      String ending = "@";
      //String imageWriteCode = "SET|26|1||A55A80A0|@";
      String imageWriteCode = "SET|26|1||A55A80A0|@";

      int PixelPerCommand = 55;

      String streaRestart = "SET|26|0|00|@";
      // print(ColorToSend.toString());assets/splash_images/staht_org_id
      // FirebaseFirestore.instance
      //     .collection("splash_images")
      //     .doc("staht_org_id")
      //     .delete();
      // FirebaseFirestore.instance
      //     .collection("splash_images")
      //     .doc("staht_org_id")
      //     .set({
      //   "data": jsonEncode(ColorToSend),
      //   "height": imageModelCustom.height.toRadixString(16).toUpperCase(),
      //   "width": imageModelCustom.width.toRadixString(16).toUpperCase(),
      //   "intvalue": allColor.toString()
      // });
      if (true) {
        Duration duration = Duration(milliseconds: 0);
        Future.delayed(duration, () async {
          await widget.characteristicWritePurpose
              .write(StringToASCII(streaRestart), withoutResponse: OsDependentSettings().writeWithresponse);
          Future.delayed(duration, () async {
            // List<int> respnse1 = await widget.characteristicReadPurpose.read();

            Future.delayed(duration, () async {
              await widget.characteristicWritePurpose
                  .write(StringToASCII(imageWriteCode), withoutResponse: OsDependentSettings().writeWithresponse);
              Future.delayed(duration, () async {
                // List<int> respnse1 = await widget.characteristicReadPurpose.read();

                Future.delayed(duration, () async {
                  int totalPixel = ColorToSend.length;
                  double iteration = totalPixel / PixelPerCommand;
                  List<List<String>> subListArray = [];
                  for (int i = 0; i < iteration; i++) {
                    if (((i * PixelPerCommand) + PixelPerCommand) <
                        ColorToSend.length) {
                      subListArray.add(ColorToSend.sublist((i * PixelPerCommand),
                          ((i * PixelPerCommand) + PixelPerCommand)));
                    } else {
                      subListArray.add(ColorToSend.sublist(
                          (i * PixelPerCommand), (ColorToSend.length - 1)));
                    }
                  }

                  int lastPrint = 0 ;
                  int p = 0 ;



                  //
                  // int pushIndex = 0 ;
                  // bool checkNeed(){
                  //   if(pushIndex < subListArray.length-1){
                  //
                  //     return true;
                  //
                  //   }else return false;
                  //
                  //
                  //
                  // }
                  //
                  // pushData()async{
                  //   String BATCH_OF_PIXEL = "";
                  //   for (int q = 0; q < subListArray[pushIndex].length; q++) {
                  //     BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[pushIndex][q];
                  //   }
                  //   String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                  //   // List<int> commandData = StringToASCII(loodCommand);
                  //   List<int> commandData = utf8.encode(loodCommand);
                  //   // print("command to send " + loodCommand);
                  //   print("size " + commandData.length.toString());
                  //
                  //   if (commandData.length.isEven) {
                  //     //i have data length even
                  //
                  //   }
                  //   // int current = DateTime.now().millisecondsSinceEpoch;
                  //   //print("passed "+(lastPrint -current).toString());
                  //   // lastPrint = current;
                  //
                  //   print("before write "+DateTime.now().millisecondsSinceEpoch.toString());
                  //
                  //   Future.delayed(Duration(milliseconds:10), () async {
                  //     try{
                  //       await widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                  //       print("after write "+DateTime.now().millisecondsSinceEpoch.toString());
                  //
                  //       print("done " + (pushIndex * 100 / subListArray.length).toString() + "%");
                  //       setState(() {
                  //         widget.progressValue = (pushIndex / subListArray.length);
                  //       });
                  //       pushIndex++;
                  //
                  //       if(checkNeed() == true){
                  //         pushData();
                  //       }
                  //     }catch(e){
                  //       print("in ed");
                  //       print(e);
                  //
                  //     }
                  //
                  //   });
                  //
                  //
                  //
                  // }
                  //
                  //
                  // if(checkNeed() == true){
                  //   pushData();
                  // }








                for (int p = 0; p < subListArray.length; p++) {

                    //delay 1+p
                    String BATCH_OF_PIXEL = "";
                    for (int q = 0; q < subListArray[p].length; q++) {
                      BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[p][q];
                    }
                   // String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    // List<int> commandData = StringToASCII(loodCommand);
                    List<int> commandData = utf8.encode(loodCommand);
                   // print("command to send " + loodCommand);
                    print("size " + commandData.length.toString());

                    if (commandData.length.isEven) {
                      //i have data length even

                    }
                   // int current = DateTime.now().millisecondsSinceEpoch;
                    //print("passed "+(lastPrint -current).toString());
                   // lastPrint = current;

                    print("before write "+DateTime.now().millisecondsSinceEpoch.toString());

                     widget.characteristicWritePurpose.write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                    print("after write "+DateTime.now().millisecondsSinceEpoch.toString());

                    print("done " + (p * 100 / subListArray.length).toString() + "%");
                    setState(() {
                      widget.progressValue = (p / subListArray.length);
                    });

                    // Future.delayed(Duration(seconds: (2 + p)), () async {
                    //   //delay 1+p
                    //   List<int> res =
                    //       await widget.characteristicReadPurpose.read();
                    //
                    //   print("response string " + utf8.decode(res));
                    // });

                }



                  //  print("prepared pixles   "+loodCommand);
                });
              });
            });
          });
        });
      }
    });
  }
  Future<void> writeImageFromCloud(
      List<String> pixels, String width, String height) async {
    await widget.device.requestMtu(244);
    print("Cloud Writing started");

    String imageWriteCode = "SET|26|1|A55A" + width + height + "FFFF|@";

    print("command for first write " + imageWriteCode);

    int PixelPerCommand = 55;

    String streaRestart = "SET|26|0|00|@";

    if (true) {
      Duration duration = Duration(milliseconds: 1000);
      Future.delayed(duration, () async {
        await widget.characteristicWritePurpose
            .write(StringToASCII(streaRestart), withoutResponse: OsDependentSettings().writeWithresponse);
        Future.delayed(duration, () async {
          List<int> respnse1 = await widget.characteristicReadPurpose.read();

          Future.delayed(duration, () async {
            await widget.characteristicWritePurpose
                .write(StringToASCII(imageWriteCode), withoutResponse: OsDependentSettings().writeWithresponse);
            Future.delayed(duration, () async {
              List<int> respnse1 =
                  await widget.characteristicReadPurpose.read();

              Future.delayed(duration, () async {
                int totalPixel = pixels.length;
                double iteration = totalPixel / PixelPerCommand;
                List<List<String>> subListArray = [];
                for (int i = 0; i < iteration; i++) {
                  if (((i * PixelPerCommand) + PixelPerCommand) <
                      pixels.length) {
                    subListArray.add(pixels.sublist((i * PixelPerCommand),
                        ((i * PixelPerCommand) + PixelPerCommand)));
                  } else {
                    subListArray.add(pixels.sublist(
                        (i * PixelPerCommand), (pixels.length - 1)));
                  }
                }

                for (int p = 0; p < subListArray.length; p++) {
                  Future.delayed(Duration(seconds: (2 + p)), () async {
                    //delay 1+p
                    String BATCH_OF_PIXEL = "";
                    for (int q = 0; q < subListArray[p].length; q++) {
                      BATCH_OF_PIXEL = BATCH_OF_PIXEL + subListArray[p][q];
                    }
                    String loodCommand = "SET|26|1|" + BATCH_OF_PIXEL + "|@";
                    // List<int> commandData = StringToASCII(loodCommand);
                    List<int> commandData = utf8.encode(loodCommand);
                    print("command to send " + loodCommand);
                    print("size " + commandData.length.toString());

                    if (commandData.length.isEven) {
                      //i have data length even

                    }
                    await widget.characteristicWritePurpose
                        .write(commandData, withoutResponse: OsDependentSettings().writeWithresponse);
                    print("done " +
                        (p * 100 / subListArray.length).toString() +
                        "%");
                    // setState(() {
                    //   widget.progressValue = (p / subListArray.length);
                    // });

                    Future.delayed(Duration(seconds: (2 + p)), () async {
                      //delay 1+p
                      List<int> res =
                          await widget.characteristicReadPurpose.read();

                      print("response string " + utf8.decode(res));
                    });
                  });
                }

                //  print("prepared pixles   "+loodCommand);
              });
            });
          });
        });
      });
    }
  }

  Future<void> setDisplayForegroudColor(String color) async {
    String correctedValue = "0";

    if (isBLEbg == false) {
      isBLEbg = true;
      print(COMMAND_INDEX_21_SET_DISPLAY_FOREGROUND_COLOR +
          color +
          COMMAND_SUFFIX);

      await widget.characteristicWritePurpose.write(
          StringToASCII(COMMAND_INDEX_21_SET_DISPLAY_FOREGROUND_COLOR +
              color +
              COMMAND_SUFFIX),
          withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int> responseAray = await widget.characteristicReadPurpose.read();
      //String responseInString = utf8.decode(responseAray);

      // setState(() {widget.DISPLAY_BRIGHTNESS = double.parse(removeCodesFromStrings(responseInString, COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS));});
      isBLEbg = false;
    }
  }

  Future<void> setDisplayBackgroundColor(String color) async {
    String correctedValue = "0";

    if (isBLEbg == false) {
      isBLEbg = true;
      print(COMMAND_INDEX_21_SET_DISPLAY_FOREGROUND_COLOR +
          color +
          COMMAND_SUFFIX);

      await widget.characteristicWritePurpose.write(
          StringToASCII(COMMAND_INDEX_20_SET_DISPLAY_FOREGROUND_COLOR +
              color +
              COMMAND_SUFFIX),
          withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int> responseAray = await widget.characteristicReadPurpose.read();
      //String responseInString = utf8.decode(responseAray);

      // setState(() {widget.DISPLAY_BRIGHTNESS = double.parse(removeCodesFromStrings(responseInString, COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS));});
      isBLEbg = false;
    }
  }

  Future<void> conenctDevice() async {
    try {
      await widget.device.connect(autoConnect: false);
    } catch (e) {

    } finally {
      await widget.device.discoverServices();
    }
  }

  downloadSplashImage() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("splash_images")
        .doc("staht_org_id")
        .get();
    print("after downloading");
    print(documentSnapshot.data().toString());
    List allPIx = jsonDecode(documentSnapshot.get("data"));
    String width = documentSnapshot.get("width");
    String height = documentSnapshot.get("height");

    List<String> plsGo = [];
    for (int i = 0; i < allPIx.length; i++) {
      plsGo.add(allPIx[i]);
    }
    print("data length " + allPIx.length.toString());
    writeImageFromCloud(plsGo, width, height);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  //  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    ////_firebaseMessaging.subscribeToTopic("all");
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     //  downloadSplashImage();
    //     setState(() {
    //       widget.notoiceBoard = "onMessage: $message";
    //
    //       //  widget.image = message['data']['data'];
    //     });
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     //downloadSplashImage();
    //     setState(() {
    //       widget.notoiceBoard = "onLaunch: $message";
    //       //widget.image = message['data']['data'];
    //     });
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     //downloadSplashImage();
    //     setState(() {
    //       widget.notoiceBoard = "onResume: $message";
    //       // widget.image = message['data']['data'];
    //     });
    //   },
    // );

    this.fetchServices();
    //widget.device.requestMtu(244);
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 255, 0, 0),
        hexColor: "F800",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 0, 255, 0),
        hexColor: "07E0",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 0, 0, 255),
        hexColor: "001F",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 255, 255, 255),
        hexColor: "0000",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 0, 0, 0),
        hexColor: "FFFF",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 255, 255, 0),
        hexColor: "FFE0",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 255, 0, 255),
        hexColor: "F81F",
        isSelected: true));
    widget.allColors.add(CustomColorPallete(
        color: Color.fromARGB(255, 0, 255, 255),
        hexColor: "07FF",
        isSelected: true));
  }

  /*

   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                //  await conenctDevice();
                List<BluetoothService> allService =
                    await widget.device.services.first;
                print(allService.length.toString());
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => CalibartionStep4(
                //             device: widget.device,
                //             characteristicWrite:
                //                 allService[3].characteristics[0],
                //             characteristicRead:
                //                 allService[3].characteristics[1],
                //           )),
                // );
                // Stream st = widget.userBody.get("parentType") == "admin"
                //     ? widget.firestore
                //         .collection("calibAdmins")
                //         .where("userGroup", isEqualTo: "admin")
                //         .snapshots()
                //     : widget.firestore
                //         .collection("calibAdmins")
                //         .where("userGroup",
                //             isEqualTo: widget.userBody.get("parentType"))
                //         .where("groupId",
                //             isEqualTo: widget.userBody.get("parentId"))
                //         .snapshots();
               try{
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => Scaffold(
                           body: Scaffold(
                             appBar: AppBar(
                               title: Text("Product Information"),
                             ),
                             body: SingleChildScrollView(
                               child: Column(
                                 children: [
                                   //getAll5InaRow(bluetoothCharacteristicWrite: widget.characteristicWritePurpose,bluetoothCharacteristicRead: widget.characteristicReadPurpose),
                                   Directory_1_view_edit(
                                     bluetoothCharacteristicWrite: widget.characteristicWritePurpose,
                                     bluetoothCharacteristicRead: widget
                                         .characteristicReadPurpose,
                                   ),

                                   Directory_2_view_edit(
                                     bluetoothCharacteristicWrite: widget
                                         .characteristicWritePurpose,
                                     bluetoothCharacteristicRead: widget
                                         .characteristicReadPurpose,
                                   ),
                                   Directory_3_view_edit(
                                     bluetoothCharacteristicWrite: widget
                                         .characteristicWritePurpose,
                                     bluetoothCharacteristicRead: widget
                                         .characteristicReadPurpose,
                                   ),
                                   Directory_4_view_edit(
                                     bluetoothCharacteristicWrite: widget
                                         .characteristicWritePurpose,
                                     bluetoothCharacteristicRead: widget
                                         .characteristicReadPurpose,
                                   ),
                                   Directory_9_view_edit(
                                     bluetoothCharacteristicWrite: widget
                                         .characteristicWritePurpose,
                                     bluetoothCharacteristicRead: widget
                                         .characteristicReadPurpose,
                                   ),
                                   InkWell(
                                     onTap: () {
                                       // Navigator.push(
                                       //   context,
                                       //   MaterialPageRoute(
                                       //       builder: (context) =>
                                       //           CalibartionStep4(
                                       //             //profile: widget.userBody,
                                       //             calibAdmin:"admin",
                                       //             firestore: widget
                                       //                 .firestore,
                                       //             device:
                                       //             widget.device,
                                       //             characteristicWrite:
                                       //             allService[3]
                                       //                 .characteristics[0],
                                       //             characteristicRead:
                                       //             allService[3]
                                       //                 .characteristics[1],
                                       //             productInfo:
                                       //             productInfo, CoEf1: '', CoEf3: '', CoEf4: '', CoEf2: '',
                                       //           )),
                                       // );
                                     },
                                     child: Padding(
                                       padding:
                                       const EdgeInsets.fromLTRB(
                                           8, 25, 8, 0),
                                       child: Container(
                                         decoration: BoxDecoration(
                                             borderRadius:
                                             BorderRadius.all(
                                                 Radius.circular(
                                                     3)),
                                             color: Theme.of(context)
                                                 .primaryColor),
                                         child: Center(
                                           child: Padding(
                                             padding:
                                             const EdgeInsets
                                                 .all(15.0),
                                             child: Text(
                                               "Next",
                                               style: TextStyle(
                                                   color:
                                                   Colors.white),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         )));
               }catch(e){
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => Scaffold(body: Text("No Calibration Panel found"),)));
               }
              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.done,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Start Calibration",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           Visibility(visible:true ,child:  InkWell(
             onTap: () {
               //

               //List allDefaultValues = [1.427, (1 / 41145), 0.0, 0.0];
              // List allDefaultValues = [-0.3690374775313453, (0.000019344490491945945), 0.0, 0.0];
               //List allDefaultValues = [("-8.38E-02"), ("2.07E-05"), ("-1.17E-13"), ("4.94E-20")];
               List allDefaultValues = [("-1.79E-01"), ("2.00E-05"), ("4.5E-13"), ("-7.60E-20")];

               int current = 0;

               setCalCoefficient0thOrder(
                   characteristicWrite: widget.characteristicWritePurpose,
                   characteristicRead: widget.characteristicReadPurpose,
                   value: allDefaultValues[current])
                   .then((value) {
                 if (value == true) {
                   current++;
                   print("Done " + current.toString());

                   setCalCoefficient1stOrder(
                       characteristicWrite:
                       widget.characteristicWritePurpose,
                       characteristicRead:
                       widget.characteristicReadPurpose,
                       value: allDefaultValues[current])
                       .then((value) {
                     if (value == true) {
                       current++;
                       print("Done " + current.toString());
                       setCalCoefficient2ndOrder(
                           characteristicWrite:
                           widget.characteristicWritePurpose,
                           characteristicRead:
                           widget.characteristicReadPurpose,
                           value: allDefaultValues[current])
                           .then((value) {
                         if (value == true) {
                           current++;
                           print("Done " + current.toString());
                           setCalCoefficient3rdOrder(
                               characteristicWrite:
                               widget.characteristicWritePurpose,
                               characteristicRead:
                               widget.characteristicReadPurpose,
                               value: allDefaultValues[current])
                               .then((value) {
                             if (value == true) {
                               current++;
                               print("Done " + current.toString());
                             } else {
                               print("Failed at " + current.toString());
                             }
                           });
                         } else {
                           print("Failed at " + current.toString());
                         }
                       });
                     } else {
                       print("Failed at " + current.toString());
                     }
                   });
                 } else {
                   print("Failed at " + current.toString());
                 }
               });
             },
             child: Center(
               child: Container(
                 margin: const EdgeInsets.all(5.0),
                 padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                 decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor,
                     border: Border.all(color: Theme.of(context).primaryColor),
                     borderRadius: BorderRadius.circular(5)),
                 child: Padding(
                   padding: EdgeInsets.all(2),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Icon(
                           Icons.done,
                           color: Colors.white,
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           "Reset Calibration",
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                               fontSize: 16),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             ),
           ),),
            Visibility(visible:true ,child:  InkWell(
              onTap: () {
                TextEditingController controller0 = new TextEditingController(text: "-1.79E-01");
                TextEditingController controller1 = new TextEditingController(text: "2.00E-05");
                TextEditingController controller2 = new TextEditingController(text: "4.50E-13");
                TextEditingController controller3 = new TextEditingController(text: "-7.60E-20");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Scaffold(appBar: AppBar(title: Text("Raw Calibration"),),body: SingleChildScrollView(
                          child:Column(
                            children: [
                              TextFormField(controller: controller0,),
                              TextFormField(controller: controller1,),
                              TextFormField(controller: controller2,),
                              TextFormField(controller: controller3,),
                              RaisedButton(onPressed: (){
                                List allDefaultValues = [controller0.text, controller1.text,controller2.text,controller3.text,];

                                int current = 0;

                                setCalCoefficient0thOrder(
                                    characteristicWrite: widget.characteristicWritePurpose,
                                    characteristicRead: widget.characteristicReadPurpose,
                                    value: allDefaultValues[current])
                                    .then((value) {
                                  if (value == true) {
                                    current++;
                                    print("Done " + current.toString());

                                    setCalCoefficient1stOrder(
                                        characteristicWrite:
                                        widget.characteristicWritePurpose,
                                        characteristicRead:
                                        widget.characteristicReadPurpose,
                                        value: allDefaultValues[current])
                                        .then((value) {
                                      if (value == true) {
                                        current++;
                                        print("Done " + current.toString());
                                        setCalCoefficient2ndOrder(
                                            characteristicWrite:
                                            widget.characteristicWritePurpose,
                                            characteristicRead:
                                            widget.characteristicReadPurpose,
                                            value: allDefaultValues[current])
                                            .then((value) {
                                          if (value == true) {
                                            current++;
                                            print("Done " + current.toString());
                                            setCalCoefficient3rdOrder(
                                                characteristicWrite:
                                                widget.characteristicWritePurpose,
                                                characteristicRead:
                                                widget.characteristicReadPurpose,
                                                value: allDefaultValues[current])
                                                .then((value) {
                                              if (value == true) {
                                                current++;
                                                print("Done " + current.toString());
                                              } else {
                                                showErrorMsgAsAlertDialog(current.toString(),context);

                                                print("Failed at " + current.toString());
                                              }
                                            });
                                          } else {
                                            showErrorMsgAsAlertDialog(current.toString(),context);

                                            print("Failed at " + current.toString());
                                          }
                                        });
                                      } else {
                                        showErrorMsgAsAlertDialog(current.toString(),context);

                                        print("Failed at " + current.toString());
                                      }
                                    });
                                  } else {
                                    showErrorMsgAsAlertDialog(current.toString(),context);

                                    print("Failed at " + current.toString());
                                    showErrorMsgAsAlertDialog(current.toString(),context);
                                  }
                                });
                              },child: Center(child: Text("Apply Values"),),),

                            ],
                          ),
                        ),)));
                //


              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.vertical_align_center_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Put Raw Values",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),),

            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // StreamBuilder(
                        //   stream: FirebaseFirestore.instance
                        //       .collection("splash_images")
                        //       .doc("staht_org_id")
                        //       .snapshots(),
                        //   builder: (BuildContext context,
                        //       AsyncSnapshot<DocumentSnapshot> snapshot) {
                        //     print("data " + snapshot.data.data().toString());
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.active) {
                        //       if (snapshot.hasData &&
                        //           snapshot.data != null &&
                        //           snapshot.data.exists) {
                        //         List data = [];
                        //         String width,height;
                        //         if (snapshot.data.data()["intvalue"] != null) {
                        //           data = jsonDecode(
                        //               snapshot.data.data()["intvalue"]);
                        //            width = snapshot.data.data()["width"];
                        //            height = snapshot.data.data()["height"];
                        //         }
                        //
                        //         return snapshot.data.data()["intvalue"]== null
                        //             ? Text("Image is Processing")
                        //             : makeImage(data,width,height);
                        //       } else {
                        //         return const Center(
                        //           child: Text("No Data"),
                        //         );
                        //       }
                        //     } else {
                        //       return const Center(
                        //         child: Text("loading..."),
                        //       );
                        //     }
                        //   },
                        // ),

                        InkWell(onTap: (){
                          writeImageGallary();
                        },child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(color: ThemeManager().getDarkGreenColor,child: Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Choose Image to Write",style: TextStyle(color: Colors.white),),
                          ),),),
                        ),),
                        LinearProgressIndicator(
                          value: widget.progressValue,
                        ),

                      if(false)  ListTile(
                          title: Text(
                            "Sequential Write",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: widget.progressValue,
                          ),
                          trailing: RaisedButton(
                            child: Text("Camera"),
                            onPressed: writeImage,
                          ),
                        ),
                        if(false)   ListTile(
                          title: Text(
                            "Sequential Write",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: widget.progressValue,
                          ),
                          trailing: RaisedButton(
                            child: Text("Gallary"),
                            onPressed: writeImageGallary,
                          ),
                        ),


                        if(false) ListTile(
                          title: Text(
                            "Parallel Write",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: widget.progressValue,
                          ),
                          trailing: RaisedButton(
                            child: Text("Camera"),
                            onPressed: writeImageP,
                          ),
                        ),
                        if(false) ListTile(
                          title: Text(
                            "Parallel Write",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: widget.progressValue,
                          ),
                          trailing: RaisedButton(
                            child: Text("Gallary"),
                            onPressed: writeImageGallaryP,
                          ),
                        ),
                        if(false) ListTile(
                          title: Text(
                            "Device Name",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.DEVICE_TITLE),
                          trailing: RaisedButton(
                            child: Text("View"),
                            onPressed: fetchDeviceDisplayName,
                          ),
                        ),
                        if(false) ListTile(
                          title: Text(
                            "Battery Level",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.BATTERY_LEVEL),
                          trailing: RaisedButton(
                            child: Text("View"),
                            onPressed: fetchBatteryLevel,
                          ),
                        ),
                        if(false)  ListTile(
                          title: Text(
                            "Cal Coefficient 0th Order",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.COEFFICIENT_0_TH_ORDER),
                          trailing: InkWell(
                            child: Text("View"),
                            onTap: CalCoefficient0thOrder,
                            // onTap: () {
                            //   // Navigator.push(
                            //   //   context,
                            //   //   MaterialPageRoute(builder: (context) => CoEfZeroEditWidget(device:widget.device ,characteristicWritePurpose: widget.characteristicWritePurpose,characteristicReadPurpose:widget.characteristicReadPurpose ,)),
                            //   // );
                            //
                            //   showModalBottomSheet(
                            //       context: context,
                            //       builder: (context) {
                            //         return Container(
                            //           decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(15),
                            //                   topRight: Radius.circular(15))),
                            //           child: CoEfZeroEditWidget(
                            //             device: widget.device,
                            //             characteristicWritePurpose:
                            //                 widget.characteristicWritePurpose,
                            //             characteristicReadPurpose:
                            //                 widget.characteristicReadPurpose,
                            //           ),
                            //         );
                            //       });
                            // },
                          ),
                        ),
                        if(false) ListTile(
                          title: Text(
                            "Cal Coefficient 1th Order",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.COEFFICIENT_1_TH_ORDER),
                          trailing: RaisedButton(
                            child: Text("View"),
                            onPressed: CalCoefficient1thOrder,
                          ),
                        ),
                        if(false) ListTile(
                          title: Text(
                            "Cal Coefficient 2nd Order",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.COEFFICIENT_2_TH_ORDER),
                          trailing: RaisedButton(
                            child: Text("View"),
                            onPressed: CalCoefficient2thOrder,
                          ),
                        ),
                        if(false) ListTile(
                          title: Text(
                            "Cal Coefficient 3nd Order",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.COEFFICIENT_3_TH_ORDER),
                          trailing: RaisedButton(
                            child: Text("View"),
                            onPressed: CalCoefficient3thOrder,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Display Brightness",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(widget.DISPLAY_BRIGHTNESS.toString()),
                          trailing: RaisedButton(
                            child: Text("View"),
                            onPressed: getDisplayBrightness,
                          ),
                        ),
                        Slider(
                            value: widget.DISPLAY_BRIGHTNESS,
                            onChanged: (value) {
                              setState(() {
                                setDisplayBrightness(value);
                                widget.DISPLAY_BRIGHTNESS = value;
                              });
                            }),
                        ListTile(
                          title: Text(
                            "Foreground Color",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text("Click to change color"),
                        ),
                        Container(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: widget.allColors.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: widget.allColors[index].color,
                                  child: InkWell(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                    ),
                                    onTap: () {
                                      print("changing to color " +
                                          "0x" +
                                          widget.allColors[index].hexColor);
                                      setDisplayForegroudColor("0x" +
                                          widget.allColors[index].hexColor);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Background Color",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text("Click to change color"),
                        ),
                        Container(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: widget.allColors.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: widget.allColors[index].color,
                                  child: InkWell(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                    ),
                                    onTap: () {
                                      print("changing to color " +
                                          "0x" +
                                          widget.allColors[index].hexColor);
                                      setDisplayBackgroundColor("0x" +
                                          widget.allColors[index].hexColor);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Future<Widget> getAll5InaRow({required BluetoothCharacteristic bluetoothCharacteristicWrite,required BluetoothCharacteristic  bluetoothCharacteristicRead}) async{

    List<Widget> allWidget = [];
     await bluetoothCharacteristicWrite
         .write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);

     List<int> responseAray2 = await bluetoothCharacteristicRead.read();
     String responseInString = utf8.decode(responseAray2);
     String data =
     removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
     print("1 " + data);
     allWidget.add(Text(data));

     return Column(children: allWidget,);


  }
}

List<int> StringToASCII(String command) {
  return AsciiEncoder().convert(command);
}
//
// Widget getBatterylevel(
//     BluetoothCharacteristic write, BluetoothCharacteristic read) {
//   for (int i = 0; i < LOOP_COUNT_TO_REMOVE_CACHE; i++) {
//     return FutureBuilder(
//         future: write.write(StringToASCII(COMMAND_INDEX_22_GET_BATTERY)),
//         builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//           return FutureBuilder(
//               future: read.read(),
//               builder:
//                   (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
//                 if (snapshot.hasData)
//                   return ListTile(
//                     title: Text("Battery Level"),
//                   //  subtitle: Text(utf8.decode(snapshot.data)),
//                   );
//                 else {
//                   return Center(
//                     child: Text("No Data"),
//                   );
//                 }
//               });
//         });
//   }
// }

// Widget getDeviceName(
//     BluetoothCharacteristic write, BluetoothCharacteristic read) {
//   for (int i = 0; i < LOOP_COUNT_TO_REMOVE_CACHE; i++) {
//     return FutureBuilder(
//         future: write.write(StringToASCII(COMMAND_INDEX_9_GET_DEVICE_NAME)),
//         builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//           return FutureBuilder(
//               future: read.read(),
//               builder:
//                   (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
//                 if (snapshot.hasData)
//                   return ListTile(
//                     title: Text("Device Name"),
//                     subtitle: Text(utf8.decode(snapshot.data)),
//                   );
//                 else {
//                   return Center(
//                     child: Text("No Data"),
//                   );
//                 }
//               });
//         });
//   }
// }

double byteArrayTofloat(List<int> data) {
  Float returnValue;

  final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
  print('bytes: ${result}');
  HexEncoder _hexEncoder;
  var bd = ByteData(data.length);
  for (int i = 0; i < data.length; i++) {
    //String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
    //returnValue = returnValue+tempVal;

    bd.setUint8(i, data[i].toInt());
  }
  double f = bd.getFloat32(0);
  print(f);
  bd.setUint32(0, 0x41480000);
  double f1 = bd.getFloat32(0);
  print(f1);
  // print(_hexEncoder.);
//  returnValue =data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0');
  return f;
}

String returnColorCode2(Color color) {
  if (color.red > 127) {
    //r = 1
    if (color.green > 127) {
      //r = 1 g= 1
      if (color.blue > 127) {
        //r = 1 g= 1 b = 1
        print("white");
        return "0000";
      } else {
        //r = 1 g= 1 b = 0
        print("yellow");
        return "FFE0";
      }
    } else if (color.blue > 127) {
      //r = 1 g= 0 b = 1
      print("magenta");
      return "F81F";
    } else {
      //r = 1 g= 0 b = 0
      print("red");
      return "F800";
    }
  } else {
    //r = 0
    if (color.green > 127) {
      //r = 0 g= 1
      if (color.blue > 127) {
        //r = 0 g= 1 b= 1
        print("cyan");
        return "07FF";
      } else {
        //r = 0 g= 1 b= 0
        print("green");
        return "07E0";
      }
    } else if (color.blue > 127) {
      //r = 0 g= 0 b= 1
      print("blue");
      return "001F";
    } else {
      //r = 0 g= 0 b= 0
      print("black");
      return "FFFF";
    }
  }
}

String returnColorCode(Color color) {
  if (color.red > 127) {
    //r = 1
    if (color.green > 127) {
      //r = 1 g= 1
      if (color.blue > 127) {
        //r = 1 g= 1 b = 1
        print("white");
        return "0000";
      } else {
        //r = 1 g= 1 b = 0
        print("yellow");
        return "FFE0";
      }
    } else if (color.blue > 127) {
      //r = 1 g= 0 b = 1
      print("magenta");
      return "F81F";
    } else {
      //r = 1 g= 0 b = 0
      print("red");
      return "F800";
    }
  } else {
    //r = 0
    if (color.green > 127) {
      //r = 0 g= 1
      if (color.blue > 127) {
        //r = 0 g= 1 b= 1
        print("cyan");
        return "07FF";
      } else {
        //r = 0 g= 1 b= 0
        print("green");
        return "07E0";
      }
    } else if (color.blue > 127) {
      //r = 0 g= 0 b= 1
      print("blue");
      return "001F";
    } else {
      //r = 0 g= 0 b= 0
      print("black");
      return "FFFF";
    }
  }
}

String convert2(List<int> data) {
  String returnValue = "";

  final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
  print('bytes: ${result}');
  HexEncoder _hexEncoder;
  var bd = ByteData(data.length);
  for (int i = 0; i < data.length; i++) {
    String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
    //returnValue = returnValue+tempVal;

    bd.setUint8(i, data[i].toInt());
  }
  var f = bd.getFloat32(0);
  print(f);
  bd.setUint32(0, 0x41480000);
  var f1 = bd.getFloat32(0);
  print(f1);
  // print(_hexEncoder.);
//  returnValue =data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0');
  return f.toString();
}

Widget makeImage(List data, String wight_, String height_) {
  //return Text("no image yet");
  print("imnage printing working");
  int width = int.parse(wight_, radix: 16);
  int height = int.parse(height_, radix: 16);
  List<Widget> allRows = [];
  int number = 0;

  List<Widget> w = [];
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      try {
        // Color c = Color(data[i * j]);
        // List<String> datas = data[number].split(",");
        //  number++;
        // print(datas.toString());
        // data[i * j]
        // List<String> datas = "255,255,255".split(",");

        /* List<String> result = "255,255,255".split(',');
        print("before");
        print(data[i * j].toString());
        print(result.toString());
        print("end");

        */
        Color color2 = Color(data[number]);
        //
        //  Color color = Color.fromARGB(255, int.parse(datas[0]), int.parse(datas[1]), int.parse(datas[2]));
        Color colo33r =
            Color.fromARGB(255, color2.red, color2.green, color2.blue);
        // print("you are fine "+colo33r.toString());
        number++;
        w.add(Container(height: 1, width: 1, color: colo33r)); //data[i*j]
        // print(data[i*j]);
      } catch (Exception) {
        print("Exception  " + Exception.toString());

        //print(data[i*j]);
      }
    }
    allRows.add(Row(
      children: w,
    ));
    w = [];
  }

  return Column(
    children: allRows,
  );
}

class CoEfZeroEditWidget extends StatefulWidget {
  int number = 0;

  bool bleBG = false;

  BluetoothCharacteristic characteristicWritePurpose;
  BluetoothCharacteristic characteristicReadPurpose;
  BluetoothDevice device;

  //BluetoothCharacteristic characteristicRead;
  CoEfZeroEditWidget(
      {required this.device,
        required this.characteristicWritePurpose,
        required this.characteristicReadPurpose});

  String COEFFICIENT_0_TH_ORDER = "Please wait";

  @override
  _CoEfZeroEditWidgetState createState() => _CoEfZeroEditWidgetState();
}

class _CoEfZeroEditWidgetState extends State<CoEfZeroEditWidget> {
  Future<void> setCalCoefficient0thOrder(double value) async {
    print("going to set " + value.toString());
    if (true) {
      setState(() {
        widget.bleBG = true;
      });

      print("going to set 2 " + value.toString());
      String commandToWrite = COMMAND_INDEX_14_SET_CalCoefficient0thOrder +
          value.toStringAsFixed(6) +
          COMMAND_SUFFIX;
      print("command " + commandToWrite);

      try {
        await widget.characteristicWritePurpose
            .write(StringToASCII(commandToWrite), withoutResponse: OsDependentSettings().writeWithresponse);
        setState(() {
          widget.bleBG = false;
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          widget.bleBG = false;
        });
      }
    } else {
      print("BLE was busy");
    }
  }

  Future<String> CalCoefficient0thOrder() async {
    if (true) {
      print("write " + COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
      await widget.characteristicWritePurpose.write(
          StringToASCII(COMMAND_INDEX_14_GET_CalCoefficient0thOrder),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.characteristicReadPurpose.read();
      String responseInString = utf8.decode(responseAray);
      print("read " + responseInString);
      // setState(() {
      //   widget.COEFFICIENT_0_TH_ORDER = removeCodesFromStrings(responseInString, COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
      // });

      return removeCodesFromStrings(
          responseInString, COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //return Text("ss");
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setCalCoefficient0thOrder(
                      double.parse(widget.COEFFICIENT_0_TH_ORDER) + 0.0001)
                  .then((value) {
                getData();
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "+",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          Text(
            widget.COEFFICIENT_0_TH_ORDER,
            style: TextStyle(fontSize: 40),
          ),
          InkWell(
            onTap: () {
              setCalCoefficient0thOrder(
                      double.parse(widget.COEFFICIENT_0_TH_ORDER) - 0.0001)
                  .then((value) {
                getData();
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "-",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );


  }

  void getData() {
    CalCoefficient0thOrder().then((value) {
      setState(() {
        widget.COEFFICIENT_0_TH_ORDER = value;
      });
    });
  }
}

class CalibartionStep1 extends StatefulWidget {
 late BluetoothDevice device;
 late BluetoothCharacteristic characteristicRead;
 late BluetoothCharacteristic characteristicWrite;
 late String val;

  CalibartionStep1(
      {required this.device, required this.characteristicRead,required this.characteristicWrite});

  @override
  _CalibartionStep1State createState() => _CalibartionStep1State();
}

class _CalibartionStep1State extends State<CalibartionStep1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step 1 of 10"),
      ),
      body: Column(
        children: [
          StreamBuilder<String>(
              stream: null,
              builder: (c, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => CalibartionStep2(
                    //             device: widget.device,
                    //             characteristicWrite: widget.characteristicWrite,
                    //             characteristicRead: widget.characteristicRead,
                    //             CoEf1: snapshot.data,
                    //           )),
                    // );
                  });

                  return Center(
                      child: Text(
                    "snapshot.data",
                    style: TextStyle(fontSize: 30),
                  ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CalibartionStep2(
                          device: widget.device,
                          characteristicWrite: widget.characteristicRead,
                          characteristicRead: widget.characteristicWrite,
                          CoEf1: widget.val,
                        )),
              );
            },
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NEXT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CalibartionStep2 extends StatefulWidget {
  BluetoothDevice device;
  BluetoothCharacteristic characteristicRead;
  BluetoothCharacteristic characteristicWrite;
  String CoEf1;

  CalibartionStep2(
      {required this.CoEf1,
        required this.device,
        required this.characteristicRead,
        required this.characteristicWrite});

  @override
  _CalibartionStep2State createState() => _CalibartionStep2State();
}

class _CalibartionStep2State extends State<CalibartionStep2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step 2 of 10"),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
              future: CalCoefficient1thOrder(
                  characteristicRead: widget.characteristicRead,
                  characteristicWrite: widget.characteristicWrite),
              builder: (c, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalibartionStep3(
                                device: widget.device,
                                characteristicWrite: widget.characteristicWrite,
                                characteristicRead: widget.characteristicRead,
                                CoEf1: widget.CoEf1,
                                CoEf2: "snapshot.data",
                              )),
                    );
                  });

                  return Center(
                      child: Text(
                    "snapshot.data",
                    style: TextStyle(fontSize: 30),
                  ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          InkWell(
            onTap: () {},
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NEXT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CalibartionStep3 extends StatefulWidget {
  BluetoothDevice device;
  BluetoothCharacteristic characteristicRead;
  BluetoothCharacteristic characteristicWrite;
  String CoEf1;
  String CoEf2;

  CalibartionStep3(
      {required this.CoEf2,
        required this.CoEf1,
        required this.device,
        required this.characteristicRead,
        required this.characteristicWrite});

  @override
  _CalibartionStep3State createState() => _CalibartionStep3State();
}

class _CalibartionStep3State extends State<CalibartionStep3> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step 3 of 10"),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
              future: CalCoefficient2thOrder(
                  characteristicRead: widget.characteristicRead,
                  characteristicWrite: widget.characteristicWrite),
              builder: (c, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalibartionStep3_1(
                                device: widget.device,
                                characteristicWrite: widget.characteristicWrite,
                                characteristicRead: widget.characteristicRead,
                                CoEf1: widget.CoEf1,
                                CoEf2: widget.CoEf2,
                                CoEf3: "snapshot.data",
                              )),
                    );
                  });

                  return Center(
                      child: Text(
                    "snapshot.data",
                    style: TextStyle(fontSize: 30),
                  ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          InkWell(
            onTap: () {},
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NEXT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CalibartionStep3_1 extends StatefulWidget {
  BluetoothDevice device;
  BluetoothCharacteristic characteristicRead;
  BluetoothCharacteristic characteristicWrite;
  String CoEf1;
  String CoEf2;
  String CoEf3;

  CalibartionStep3_1(
      {required this.CoEf2,
        required   this.CoEf1,
        required this.CoEf3,
        required this.device,
        required this.characteristicRead,
        required  this.characteristicWrite});

  @override
  _CalibartionStep3_1State createState() => _CalibartionStep3_1State();
}

class _CalibartionStep3_1State extends State<CalibartionStep3_1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step 3 of 10"),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
              future: CalCoefficient2thOrder(
                  characteristicRead: widget.characteristicRead,
                  characteristicWrite: widget.characteristicWrite),
              builder: (c, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => CalibartionStep4(
                    //             device: widget.device,
                    //             characteristicWrite: widget.characteristicWrite,
                    //             characteristicRead: widget.characteristicRead,
                    //             CoEf1: widget.CoEf1,
                    //             CoEf2: widget.CoEf2,
                    //             CoEf3: widget.CoEf3,
                    //             CoEf4: "snapshot.data", calibAdmin: '', profile: null,
                    //           )),
                    // );
                  });

                  return Center(
                      child: Text(
                    "snapshot.data",
                    style: TextStyle(fontSize: 30),
                  ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          InkWell(
            onTap: () {},
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NEXT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CalibartionStep4 extends StatefulWidget {
  late BluetoothDevice device;
  late  BluetoothCharacteristic characteristicRead;
  late  BluetoothCharacteristic characteristicWrite;
  late String CoEf1;
  late String CoEf2;
  late String CoEf3;
  late String CoEf4;
 late BluetoothCharacteristic chaForStream;
  double currentValue = 00;

  late List data;

  String raw = "0";
  String rawManipulated = "0";
  List allRefData = [];
  String changeStatus = "";
  List coeff = [];
  HashMap productInfo ;

  String equation = "";
  FirebaseFirestore firestore;
  String calibAdmin;
  //QueryDocumentSnapshot profile;
   QueryDocumentSnapshot productProfile;
   late dynamic customerProfile;

  //using this activity


  CalibartionStep4(
      { this.customerProfile, required this.productProfile,required this.calibAdmin,
        required  this.firestore,
        required   this.CoEf3,
        required   this.CoEf2,
        required  this.CoEf1,
        required  this.CoEf4,
        required this.device,
        required this.characteristicRead,
        required this.characteristicWrite,
        required this.productInfo});

  @override
  _CalibartionStep4State createState() => _CalibartionStep4State();
}

class _CalibartionStep4State extends State<CalibartionStep4> {
  Future<void> set3rdCoefficient(String value) async {
    String correctedValue = "0";

    print(COMMAND_INDEX_11_SET_CalCoefficient3thOrder + value + COMMAND_SUFFIX);

    await widget.characteristicWrite.write(
        StringToASCII(COMMAND_INDEX_11_SET_CalCoefficient3thOrder +
            value +
            COMMAND_SUFFIX),
        withoutResponse: OsDependentSettings().writeWithresponse);
    // List<int> responseAray = await widget.characteristicReadPurpose.read();
    //String responseInString = utf8.decode(responseAray);

    // setState(() {widget.DISPLAY_BRIGHTNESS = double.parse(removeCodesFromStrings(responseInString, COMMAND_INDEX_18_GET_DISPLAY_BRIGTNESS));});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // gettingDatafromPCBStream.getInstance().outData.listen((event) {
    //   if(event == true){
    //     progressDialog.show();
    //   }else {
    //     progressDialog.dismiss();
    //   }
    // });
    getProductInformations(
        characteristicWrite: widget.characteristicWrite,
        characteristicRead: widget.characteristicRead);

    // listenGauseValue();
  }

  @override
  Widget build(BuildContext contextMaster) {
    return Container(color: Colors.white,child: SafeArea(child: Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size(0,kToolbarHeight),
      //   child:  ApplicationAppbar(). getAppbar(title: "Input Ref. Values"),
      // ),
      body: Stack(children: [
        Align(alignment: Alignment.topCenter,child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   color: Theme.of(context).primaryColor,
              //   child: ListTile(
              //     leading: Text("#", style: TextStyle(color: Colors.white)),
              //     title: Text(
              //       "Raw Value",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     trailing:
              //         Text("Ref Value", style: TextStyle(color: Colors.white)),
              //   ),
              // ),
              ApplicationAppbar(). getAppbar(title: "Calibration"),
              Container(
              //  color: ThemeManager().getLightGrey10Color,
                height: height * 0.061,
                child: Container(
                  margin: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
                  ),

                  child: Row(
                    children: [

                      //------------------Back button---------
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: width * 0.045,
                              color: ThemeManager().getDarkGreenColor,
                            ),
                            Text(
                              TextConst.backText,
                              style: interMedium.copyWith(
                                  color: ThemeManager().getDarkGreenColor,
                                  fontSize: width * 0.045),
                            ),
                          ],
                        ),
                      ),

                      //-----------------Input Ref. values Header text------
                      Container(
                        margin: EdgeInsets.only(
                          left: width * 0.15,
                        ),
                        child: Text(
                          TextConst.inputRefValuesText,
                          style: interSemiBold.copyWith(
                              color: ThemeManager().getBlackColor,
                              fontSize: width * 0.043),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: height * 0.06,
                color: ThemeManager().getDarkGreenColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 25,
                      child: Container(
                          margin: EdgeInsets.only(
                              top: height * 0.003, bottom: height * 0.003),
                          child: Text(
                            "SN",
                            style: interMedium.copyWith(
                                color: ThemeManager().getWhiteColor,
                                fontSize: width * 0.035),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    VerticalDivider(
                      thickness: width * 0.0003,
                      color: ThemeManager().getWhiteColor,
                    ),
                    Expanded(
                        flex: 25,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: height * 0.003, bottom: height * 0.003),
                            padding: EdgeInsets.only(right: width * 0.05),
                            child: Text(
                              "Current Output",
                              style: interMedium.copyWith(
                                  color: ThemeManager().getWhiteColor,
                                  fontSize: width * 0.035),
                              textAlign: TextAlign.center,
                            ))),
                    VerticalDivider(
                      thickness: width * 0.0003,
                      color: ThemeManager().getWhiteColor,
                    ),
                    Expanded(
                        flex: 25,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: height * 0.003, bottom: height * 0.003),
                            child: Text(
                              "Raw Reading",
                              style: interMedium.copyWith(
                                  color: ThemeManager().getWhiteColor,
                                  fontSize: width * 0.035),
                              textAlign: TextAlign.center,
                            ))),
                    VerticalDivider(
                      thickness: width * 0.0004,
                      color: ThemeManager().getWhiteColor,
                    ),
                    Expanded(
                      flex: 25,
                      child: Container(
                          margin: EdgeInsets.only(
                              top: height * 0.003, bottom: height * 0.003),
                          child: Text(
                            "Ref Value",
                            style: interMedium.copyWith(
                                color: ThemeManager().getWhiteColor,
                                fontSize: width * 0.035),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allRefData.length,
                  itemBuilder: (_, index) {


                    return Container(
                      height: height * 0.035,
                      color: ThemeManager().getWhiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 25,
                            child: Container(
                                child: Text((index+1).toString(),
                                  style: interMedium.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          Expanded(
                              flex: 25,
                              child: Container(
                                  padding: EdgeInsets.only(right: width * 0.05),
                                  child: Text(widget.allRefData[index]["gause"].toString(),
                                    style: interMedium.copyWith(
                                        color: ThemeManager().getBlackColor,
                                        fontSize: width * 0.035),
                                    textAlign: TextAlign.center,
                                  ))),
                          Expanded(
                              flex: 25,
                              child: Container(
                                  child: Text(widget.allRefData[index]["data"].toString(),
                                    style: interMedium.copyWith(
                                        color: ThemeManager().getBlackColor,
                                        fontSize: width * 0.035),
                                    textAlign: TextAlign.center,
                                  ))),
                          Expanded(
                            flex: 25,
                            child: Container(
                                child: Text(widget.allRefData[index]["ref"].toString(),
                                  style: interMedium.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    );
                    return Row(children: [
                      Container(width: 50,child: Center(child: Text((index+1).toString()))),
                      Container(width: (MediaQuery.of(context).size.width-50)/3,child: Center(child: Text(widget.allRefData[index]["gause"].toString()))),

                      Container(width: (MediaQuery.of(context).size.width-50)/3,child: Center(child: Text(widget.allRefData[index]["data"].toString()))),

                      Container(width: (MediaQuery.of(context).size.width-50)/3,child: Center(child: Text(widget.allRefData[index]["ref"].toString()))),
                    ],);
                    return ListTile(
                      leading: Container(
                        width: 30,
                        height: 30,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.allRefData.removeAt(index);
                              });
                            },
                            child: Center(child: Icon(Icons.delete))),
                      ),
                      title: Text(widget.allRefData[index]["data"].toString()),
                      trailing: Text(widget.allRefData[index]["ref"].toString()),
                    );
                  }),
              InkWell(
                onTap: () {


                  // FutureBuilder<dynamic>(
                  //     future: fetchRawValue(
                  //         characteristicRead: widget.characteristicRead,
                  //         characteristicWrite: widget.characteristicWrite), // async work
                  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  //       if(snapshot.hasData){
                  //         progressDialog.dismiss();
                  //         String rawValue = snapshot.data["25"];
                  //         String gauseValue = snapshot.data["23"];
                  //         TextEditingController c = TextEditingController();
                  //         showModalBottomSheet(
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.vertical(
                  //                     top: Radius.circular(25.0))),
                  //             backgroundColor: Colors.white,
                  //             context: context,
                  //             isScrollControlled: true,
                  //             builder: (context) => Padding(
                  //               padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                  //               child: Column(
                  //                 children: [
                  //                   Container(
                  //                     width: MediaQuery.of(context).size.width,
                  //                     height: 50,
                  //                     child: Stack(
                  //                       children: [
                  //                         Align(
                  //                           alignment: Alignment.centerLeft,
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.all(8.0),
                  //                             child: Text("Current Raw Value "),
                  //                           ),
                  //                         ),
                  //                         Align(
                  //                           alignment: Alignment.centerRight,
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.all(8.0),
                  //                             child: Text(rawValue),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: TextFormField(
                  //                       autofocus: true,
                  //                       controller: c,
                  //                       decoration: InputDecoration(
                  //                           contentPadding:
                  //                           EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //                           hintText: "Input ref. value"),
                  //                     ),
                  //                   ),
                  //                   InkWell(
                  //                     onTap: () {
                  //                       setState(() {
                  //                         widget.allRefData.add(
                  //                             {"data": rawValue, "ref": c.text,"gause":gauseValue});
                  //                         Navigator.pop(context);
                  //                       });
                  //                     },
                  //                     child: Padding(
                  //                       padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                  //                       child: Card(
                  //                         color: Theme.of(context).primaryColor,
                  //                         shape: RoundedRectangleBorder(
                  //                           borderRadius:
                  //                           BorderRadius.circular(0.0),
                  //                         ),
                  //                         child: Container(
                  //                             height: 50,
                  //                             width:
                  //                             MediaQuery.of(context).size.width,
                  //                             child: Center(
                  //                                 child: Text(
                  //                                   "Add",
                  //                                   style:
                  //                                   TextStyle(color: Colors.white),
                  //                                 ))),
                  //                       ),
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ));
                  //       }else{
                  //         progressDialog.show();
                  //
                  //       }
                  //
                  //     });

                  gettingDatafromPCBStream.getInstance().dataReload(true);

                  fetchRawValue(
                      characteristicRead: widget.characteristicRead,
                      characteristicWrite: widget.characteristicWrite)
                      .then((value) {
                    String rawValue = value["25"];
                    String gauseValue = value["23"];
                    TextEditingController c = TextEditingController();

                    //   gettingDatafromPCBStream.getInstance().dataReload(false);

                    showDialog(
                       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                        //backgroundColor: Colors.white,
                        context: context,
                       // isScrollControlled: true,
                        builder: (context) => Dialog(elevation: 4,child: Wrap(
                          children: [


                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.01,
                                  left: width * 0.04,
                                  right: width * 0.04),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //------PopUp header Add Ref. value text--
                                  Text(
                                    TextConst.addRefValueDialogText,
                                    style: interSemiBold.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.045,
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: width * 0.06,
                                        color: ThemeManager().getLightGrey4Color,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.015),
                              height: height * 0.001,
                              color: ThemeManager().getBlackColor.withOpacity(0.19),
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.04,
                                  right: width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      //---------Current Raw value text-------
                                      Text(
                                        TextConst.currentRawValueText,
                                        style: interMedium.copyWith(
                                          color: ThemeManager().getPopUpTextGreyColor,
                                          fontSize: width * 0.036,
                                        ),
                                      ),

                                      //-------Current Raw value data-------
                                      Text(rawValue,
                                        style: interMedium.copyWith(
                                          color: ThemeManager().getPopUpTextGreyColor,
                                          fontSize: width * 0.036,
                                        ),
                                      ),
                                    ],
                                  ),

                                  //-------------Text field to add Ref. value---------
                                  Container(
                                    margin: EdgeInsets.only(top: height * 0.015),
                                    child: TextFormField(   keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}'))
                                      ],controller: c,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "5",
                                        hintStyle: interMedium.copyWith(
                                          color: ThemeManager().getLightGrey1Color,
                                          fontSize: width * 0.036,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(width * 0.014)),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: height * 0.0,
                                            horizontal: width * 0.045),
                                        fillColor: ThemeManager().getLightGreenTextFieldColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),

                                  //-----------------Save button----------------
                                  GestureDetector(
                                    onTap: () {

                                      setState(() {
                                        widget.allRefData.add(
                                            {"data": rawValue, "ref": c.text,"gause":gauseValue});
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.04, bottom: height * 0.02),
                                        height: height * 0.065,
                                        width: width,
                                        child: ButtonView(
                                            buttonLabel: TextConst.saveButtonText)),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),));


                  });
                },
                child:  Container(
                    margin: EdgeInsets.only(
                        right: width * 0.05, left: width * 0.05, top: height * 0.02),
                    child: ButtonView(buttonLabel: TextConst.addRefValueText)),
              ),
              widget.allRefData.length > 4
                  ? InkWell(
                onTap: () async {
                  setState(() {
                    widget.coeff.clear();
                  });
                  const int degree = 3;
                  var x = [];

                  var y = [];

                  for (int i = 0; i < widget.allRefData.length; i++) {
                    x.add(double.parse(widget.allRefData[i]["data"]));
                    y.add(double.parse(widget.allRefData[i]["ref"]));
                  }

                  var b = jsonEncode(<String, dynamic> {   "x":x.toString(),"y":y.toString()});

                  final http.Response response = await http.post(
                      Uri.parse("https://staht-connect-322113.uc.r.appspot.com/calibration"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body:b


                  );
                  var r = jsonDecode(response.body);

                  setState(() {
                    widget.coeff.add({
                      "name": (3).toString() + " rd Co ef.",
                      "value": r["1"],
                      "tag": (3).toString()
                    });
                    widget.coeff.add({
                      "name": (2).toString() + " nd Co ef.",
                      "value": r["2"],
                      "tag": (2).toString()
                    });
                    widget.coeff.add({
                      "name": (1).toString() + " st Co ef.",
                      "value": r["3"],
                      "tag": (1).toString()
                    });
                    widget.coeff.add({
                      "name": (0).toString() + " th Co ef.",
                      "value": r["4"],
                      "tag": (0).toString()
                    });
                  });






                  //
                  // print(widget.allRefData);
                  // print(y);
                  // print(x);
                  //
                  //
                  //
                  // var p = PolyFit(y, x, degree);
                  // print(p);
                  // print("print finished");
                  // setState(() {
                  //   widget.equation = p.toString();
                  // });
                  // print(p);
                  // int foundDegree = p.coefficients().length;
                  // int diff = 4 - p.coefficients().length;
                  //
                  // for (int i = 0; i < p.coefficients().length; i++) {
                  //
                  // }
                  // if (diff > 0) {
                  //   for (int i = 0; i < diff; i++) {
                  //     setState(() {
                  //       widget.coeff.add({
                  //         "name": (diff + i).toString() + " th Co ef.",
                  //         "value": double.parse("0"),
                  //         "tag": (diff + i).toString()
                  //       });
                  //     });
                  //   }
                  // }
                  DocumentReference writeResponse;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>Container(color: Colors.white,
                      child: SafeArea(
                        child: Scaffold(
                          body: Column(children: [
                            ApplicationAppbar().getAppbar(title: "Calibration"),

                            Container(
                              color: ThemeManager().getLightGrey10Color,
                              height: height * 0.061,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: width * 0.05,
                                  right: width * 0.05,
                                ),

                                child: Row(
                                  children: [

                                    //------------------Back button---------
                                    InkWell(
                                      onTap: () {

                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            size: width * 0.043,
                                            color: ThemeManager().getDarkGreenColor,
                                          ),
                                          Text(
                                            TextConst.backText,
                                            style: interMedium.copyWith(
                                                color: ThemeManager().getDarkGreenColor,
                                                fontSize: width * 0.043),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //-----------------Calculated Coefficients Header text------
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: width * 0.09,
                                      ),
                                      child: Text(
                                        TextConst.calculatedCoefficientsText,
                                        style: interSemiBold.copyWith(
                                            color: ThemeManager().getBlackColor,
                                            fontSize: width * 0.043),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.coeff.length,
                                itemBuilder: (_, index) {
                                  String apply = "Apply";

                                  return Container(
                                    padding:
                                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                                    decoration: BoxDecoration(
                                      color: ThemeManager().getWhiteColor,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: ThemeManager().getLightGrey3Color,
                                              width: height * 0.0007)),
                                    ),
                                    height: height * 0.055,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.coeff[index]["name"].toString(),
                                          style: interMedium.copyWith(fontSize: width * 0.038),
                                        ),
                                        Text(widget.coeff[widget.coeff.length-(index+1)]["value"].toString(),
                                          style: interSemiBold.copyWith(
                                              fontSize: width * 0.034,
                                              color: ThemeManager().getDarkGreenColor),
                                        ),
                                      ],
                                    ),
                                  );


                                  return ListTile(
                                    // leading: InkWell(onTap: (){
                                    //   //widget.coeff[index]["value"].toString()
                                    //   set3rdCoefficient("0.000000").then((value) {
                                    //     setState(() {
                                    //       apply = "Done";
                                    //     });
                                    //
                                    //   });
                                    //
                                    //
                                    //
                                    //
                                    // },child: Icon(Icons.done)),
                                    title: Text(widget
                                        .coeff[index]["name"]
                                        .toString()),
                                    trailing: Text(widget.coeff[widget.coeff.length-(index+1)]["value"].toString()),
                                  );
                                }),

                            InkWell(
                              onTap: () async {
                                //

                                int current = 0;

                                //widget.allRefData
                                DateTime now = DateTime.now();
                                DateTime expieryDaya = now.add(Duration(days: 365));

                                String formattedDate =
                                DateFormat('dd MMM yyy')
                                    .format(now);
                                String ExDate =
                                DateFormat('dd MMM yyy')
                                    .format(expieryDaya);
                                print(formattedDate);

                                try{
                                  writeCalibrationDate(
                                      characteristicWrite: widget
                                          .characteristicWrite,
                                      value: formattedDate)
                                      .then((value) {
                                    if (value == true) {
                                      writeCalibrationExpieryDate(
                                          characteristicWrite:
                                          widget
                                              .characteristicWrite,
                                          value: ExDate)
                                          .then((value) {
                                        if (value == true) {
                                          double maxVal = 0.0;
                                          for(int i = 0 ; i < widget.allRefData.length ; i++){
                                            if(maxVal< double.parse(widget.allRefData[i]["ref"].toString())){
                                              maxVal =  double.parse(widget.allRefData[i]["ref"].toString());
                                            }
                                          }

                                          String dataRange =maxVal.toString();
                                          writeCalibrationDataRanger(
                                              characteristicWrite:
                                              widget
                                                  .characteristicWrite,
                                              value: dataRange)
                                              .then((value) async{
                                            if ( value == true) {

                                              String readCounter =  await readTestCounter(read: widget.characteristicRead,write: widget.characteristicWrite);
                                              print("read count "+readCounter);

                                              String readGain =  await readAnalogGain(read: widget.characteristicRead,write: widget.characteristicWrite);
                                              print("read analogGain "+readGain);

                                              print(widget.productProfile);
                                              print(widget.customerProfile);

                                              writeResponse = await widget
                                                  .firestore
                                                  .collection("calibrations")
                                                  .add({"doneBy":widget.calibAdmin,"readCounter":readCounter,"readAnalogGain":readGain,
                                                "date": DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                "coeff": widget.coeff,
                                                "product": widget.productInfo,
                                                "dataUsedToCalibration":
                                                widget.allRefData,
                                                "userId":FirebaseAuth.instance.currentUser!.uid,
                                                "productProfile":widget.productProfile.data(),"customerInfo":widget.customerProfile
                                              });
                                              String id = writeResponse.id;
                                              var r1 = await setCalCoefficient0thOrder(
                                                  characteristicWrite: widget
                                                      .characteristicWrite,
                                                  characteristicRead: widget
                                                      .characteristicRead,
                                                  value:
                                                  widget.coeff[current]
                                                  ["value"]);

                                              if (r1 == true) {
                                                current++;
                                                print("Done " + current.toString());
                                                setState(() {
                                                  widget.changeStatus = widget
                                                      .changeStatus +
                                                      "\n" +
                                                      "0th Coef Change Done";
                                                });

                                                var r2 = await   setCalCoefficient1stOrder(
                                                    characteristicWrite:
                                                    widget
                                                        .characteristicWrite,
                                                    characteristicRead: widget
                                                        .characteristicRead,
                                                    value: widget.coeff[
                                                    current]["value"]);

                                                if(r2 == true){
                                                  current++;
                                                  setState(() {
                                                    widget
                                                        .changeStatus = widget
                                                        .changeStatus +
                                                        "\n" +
                                                        "1st Coef Change Done";
                                                  });

                                                  var r3 = await   setCalCoefficient2ndOrder(
                                                      characteristicWrite:
                                                      widget
                                                          .characteristicWrite,
                                                      characteristicRead:
                                                      widget
                                                          .characteristicRead,
                                                      value: widget
                                                          .coeff[
                                                      current]
                                                      ["value"]);

                                                  if(r3 == true){
                                                    current++;
                                                    setState(() {
                                                      widget
                                                          .changeStatus = widget
                                                          .changeStatus +
                                                          "\n" +
                                                          "2nd Coef Change Done";
                                                    });

                                                    var r4 = await   setCalCoefficient3rdOrder(
                                                        characteristicWrite:
                                                        widget
                                                            .characteristicWrite,
                                                        characteristicRead:
                                                        widget
                                                            .characteristicRead,
                                                        value: widget
                                                            .coeff[
                                                        current]
                                                        ["value"]);

                                                    if(r4 == true){

                                                      await  setRange63(value: "", characteristicRead: widget
                                                          .characteristicRead, characteristicWrite: widget
                                                          .characteristicWrite);
                                                      current++;
                                                      print("Done " +
                                                          current
                                                              .toString());

                                                      setState(() {
                                                        widget
                                                            .changeStatus = widget
                                                            .changeStatus +
                                                            "\n" +
                                                            "3rd co Coef Change Done";
                                                      });

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CheckCalibFrom25Directory(
                                                                  calibrationSavedId: id,
                                                                  characteristicWrite: widget
                                                                      .characteristicWrite,
                                                                  characteristicRead: widget
                                                                      .characteristicRead,
                                                                )),
                                                      );


                                                    }else{
                                                      print("faield 4");
                                                    }

                                                  }else{
                                                    print("faield 3");
                                                  }
                                                }else{
                                                  print("faield 2");
                                                }


                                              }else{
                                                print("faield 1");
                                              }



                                              //
                                              // writeResponse = await widget
                                              //     .firestore
                                              //     .collection("calibrations")
                                              //     .add({"doneBy":widget.calibAdmin,"readCounter":readCounter,"readAnalogGain":readGain,
                                              //   "date": DateTime.now()
                                              //       .millisecondsSinceEpoch,
                                              //   "coeff": widget.coeff,
                                              //   "product": widget.productInfo,
                                              //   "dataUsedToCalibration":
                                              //   widget.allRefData,
                                              //  "userId":FirebaseAuth.instance.currentUser!.uid,
                                              //   "productProfile":widget.productProfile,"customerInfo":widget.customerProfile
                                              // }).then((value) {
                                              //   String id = value.id;
                                              //
                                              //   setCalCoefficient0thOrder(
                                              //       characteristicWrite: widget
                                              //           .characteristicWrite,
                                              //       characteristicRead: widget
                                              //           .characteristicRead,
                                              //       value:
                                              //       widget.coeff[current]
                                              //       ["value"])
                                              //       .then((value) {
                                              //     if (value == true) {
                                              //       current++;
                                              //       print("Done " + current.toString());
                                              //       setState(() {
                                              //         widget.changeStatus = widget
                                              //             .changeStatus +
                                              //             "\n" +
                                              //             "0th Coef Change Done";
                                              //       });
                                              //
                                              //       setCalCoefficient1stOrder(
                                              //           characteristicWrite:
                                              //           widget
                                              //               .characteristicWrite,
                                              //           characteristicRead: widget
                                              //               .characteristicRead,
                                              //           value: widget.coeff[
                                              //           current]["value"])
                                              //           .then((value) {
                                              //         if (value == true) {
                                              //           current++;
                                              //           setState(() {
                                              //             widget
                                              //                 .changeStatus = widget
                                              //                 .changeStatus +
                                              //                 "\n" +
                                              //                 "1st Coef Change Done";
                                              //           });
                                              //           print("Done " +
                                              //               current.toString());
                                              //           setCalCoefficient2ndOrder(
                                              //               characteristicWrite:
                                              //               widget
                                              //                   .characteristicWrite,
                                              //               characteristicRead:
                                              //               widget
                                              //                   .characteristicRead,
                                              //               value: widget
                                              //                   .coeff[
                                              //               current]
                                              //               ["value"])
                                              //               .then((value) {
                                              //             if (value == true) {
                                              //               current++;
                                              //               setState(() {
                                              //                 widget
                                              //                     .changeStatus = widget
                                              //                     .changeStatus +
                                              //                     "\n" +
                                              //                     "2nd Coef Change Done";
                                              //               });
                                              //               print("Done " +
                                              //                   current
                                              //                       .toString());
                                              //               setCalCoefficient3rdOrder(
                                              //                   characteristicWrite:
                                              //                   widget
                                              //                       .characteristicWrite,
                                              //                   characteristicRead:
                                              //                   widget
                                              //                       .characteristicRead,
                                              //                   value: widget
                                              //                       .coeff[
                                              //                   current]
                                              //                   ["value"])
                                              //                   .then((value) {
                                              //                 if (value == true) {
                                              //                   current++;
                                              //                   print("Done " +
                                              //                       current
                                              //                           .toString());
                                              //
                                              //                   setState(() {
                                              //                     widget
                                              //                         .changeStatus = widget
                                              //                         .changeStatus +
                                              //                         "\n" +
                                              //                         "3rd co Coef Change Done";
                                              //                   });
                                              //
                                              //
                                              //                   Navigator.push(
                                              //                     context,
                                              //                     MaterialPageRoute(
                                              //                         builder: (context) =>
                                              //                             CheckCalibFrom25Directory(
                                              //                               calibrationSavedId: id,
                                              //                               characteristicWrite: widget
                                              //                                   .characteristicWrite,
                                              //                               characteristicRead: widget
                                              //                                   .characteristicRead,
                                              //                             )),
                                              //                   );
                                              //
                                              //
                                              //
                                              //                 } else {
                                              //                   print("Failed at " +
                                              //                       current
                                              //                           .toString());
                                              //                   setState(() {
                                              //                     widget
                                              //                         .changeStatus = widget
                                              //                         .changeStatus +
                                              //                         "\n" +
                                              //                         "Failed at " +
                                              //                         current
                                              //                             .toString();
                                              //                   });
                                              //                 }
                                              //               });
                                              //             } else {
                                              //               print("Failed at " +
                                              //                   current
                                              //                       .toString());
                                              //               setState(() {
                                              //                 widget
                                              //                     .changeStatus = widget
                                              //                     .changeStatus +
                                              //                     "\n" +
                                              //                     "Failed at " +
                                              //                     current
                                              //                         .toString();
                                              //               });
                                              //             }
                                              //           });
                                              //         } else {
                                              //           print("Failed at " +
                                              //               current.toString());
                                              //           setState(() {
                                              //             widget.changeStatus =
                                              //                 widget.changeStatus +
                                              //                     "\n" +
                                              //                     "Failed at " +
                                              //                     current
                                              //                         .toString();
                                              //           });
                                              //         }
                                              //       });
                                              //     } else {
                                              //       print("Failed at " +
                                              //           current.toString());
                                              //       setState(() {
                                              //         widget.changeStatus =
                                              //             widget.changeStatus +
                                              //                 "\n" +
                                              //                 "Failed at " +
                                              //                 current.toString();
                                              //       });
                                              //     }
                                              //   });
                                              //
                                              //
                                              //
                                              // });



                                            }
                                          });

                                        }
                                      });
                                    }
                                  });
                                }catch(e){
                                  print(e);
                                }

                              },
                              child:  Container(
                                  margin: EdgeInsets.only(
                                      right: width * 0.05, left: width * 0.05, top: height * 0.02),
                                  child: ButtonView(buttonLabel: "Apply Changes")),
                            ),

                          ],),
                        ),
                      ),
                    )),
                  );




                  // showModalBottomSheet(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.vertical(
                  //             top: Radius.circular(25.0))),
                  //     backgroundColor: Colors.white,
                  //     context: context,
                  //     isScrollControlled: true,
                  //     builder: (context) => Padding(
                  //       padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  //       child: Scaffold(
                  //         appBar: AppBar(centerTitle: true,leading: Container(),
                  //           title: Text("Calculated Coefficients"),
                  //         ),
                  //         body: SingleChildScrollView(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Column(
                  //               children: [
                  //                 //  Text(response.body),
                  //
                  //
                  //                 // InkWell(
                  //                 //   onTap: () {
                  //                 //     //CheckCalibrationActivity
                  //                 //
                  //                 //     Navigator.push(
                  //                 //       context,
                  //                 //       MaterialPageRoute(
                  //                 //           builder: (context) =>
                  //                 //               CheckCalibrationActivity(
                  //                 //                 calibrationSavedId:
                  //                 //                     writeResponse.id,
                  //                 //                 device: widget.device,
                  //                 //                 characteristicRead: widget
                  //                 //                     .characteristicRead,
                  //                 //                 characteristicWrite:
                  //                 //                     widget
                  //                 //                         .characteristicWrite,
                  //                 //               )),
                  //                 //     );
                  //                 //   },
                  //                 //   child: Center(
                  //                 //     child: Container(
                  //                 //       margin:
                  //                 //           const EdgeInsets.all(15.0),
                  //                 //       padding:
                  //                 //           const EdgeInsets.fromLTRB(
                  //                 //               3, 3, 3, 3),
                  //                 //       decoration: BoxDecoration(
                  //                 //           border: Border.all(
                  //                 //               color: Theme.of(context)
                  //                 //                   .primaryColor),
                  //                 //           borderRadius:
                  //                 //               BorderRadius.circular(
                  //                 //                   5)),
                  //                 //       child: Padding(
                  //                 //         padding: EdgeInsets.all(2),
                  //                 //         child: Row(
                  //                 //           mainAxisAlignment:
                  //                 //               MainAxisAlignment
                  //                 //                   .center,
                  //                 //           crossAxisAlignment:
                  //                 //               CrossAxisAlignment
                  //                 //                   .center,
                  //                 //           children: [
                  //                 //             Padding(
                  //                 //               padding:
                  //                 //                   const EdgeInsets
                  //                 //                       .all(8.0),
                  //                 //               child: Icon(
                  //                 //                 Icons.done,
                  //                 //                 color:
                  //                 //                     Theme.of(context)
                  //                 //                         .primaryColor,
                  //                 //               ),
                  //                 //             ),
                  //                 //             Padding(
                  //                 //               padding:
                  //                 //                   const EdgeInsets
                  //                 //                       .all(8.0),
                  //                 //               child: Text(
                  //                 //                 "Check Calibration",
                  //                 //                 style: TextStyle(
                  //                 //                     fontWeight:
                  //                 //                         FontWeight
                  //                 //                             .bold,
                  //                 //                     color: Theme.of(
                  //                 //                             context)
                  //                 //                         .primaryColor,
                  //                 //                     fontSize: 16),
                  //                 //               ),
                  //                 //             ),
                  //                 //           ],
                  //                 //         ),
                  //                 //       ),
                  //                 //     ),
                  //                 //   ),
                  //                 // ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ));
                },
                child:  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.3, right: width * 0.3, top: height * 0.015),
                    alignment: Alignment.center,
                    height: height * 0.058,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height * 0.05),
                        gradient: LinearGradient(
                            colors: [Color(0xffFF7500), Color(0xffFFB400)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.45, 0.99])),
                    child: Center(
                      child: Text(
                        "Calculate",
                        style: interSemiBold.copyWith(
                            fontSize: width * 0.038, color: Colors.white),
                      ),
                    )),
              )
                  : Container(
                height: 0,
                width: 0,
              ),
             // Text(widget.changeStatus)
            ],
          ),
        ),),
        Align(alignment: Alignment.center,child: SingleChildScrollView(
          child: StreamBuilder(
              stream: gettingDatafromPCBStream.getInstance().outData,
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data == true){
                  return  Center(
                    child: new ClipRect(
                      child: new BackdropFilter(
                        filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          height:MediaQuery.of(context).size.height,
                          decoration: new BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.5)
                          ),
                          child: Center(
                            child: Center(child: Text("Please wait"),),
                          ),
                        ),
                      ),
                    ),
                  );



                }else {
                  return Container(width: 0,height: 0,);
                }

              }),
        ),),
      ],),
    ),),);
  }

  void listenGauseValue() {
    widget.device.discoverServices().then((value) {
      setState(() {
        widget.chaForStream = value[3].characteristics[2];
        widget.chaForStream.setNotifyValue(true).then((value) {
          widget.chaForStream.value.listen((event) {
            print(convert(event));
            setState(() {
              widget.currentValue = double.parse(convert(event));
            });
          });
        });
      });
    });
  }

  void getProductInformations(
      {required BluetoothCharacteristic characteristicRead,
        required  BluetoothCharacteristic characteristicWrite}) async {
    dynamic productData;

    try {
      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_1_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await characteristicRead.read();
      String responseInString = utf8.decode(responseAray);
      String data =
          removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
      print("1 " + data);
      // productData["ice_sl"]=data;
      //print(data);

      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2 = await characteristicRead.read();

      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2_2 = await characteristicRead.read();
      String responseInString2_2 = utf8.decode(responseAray2_2);
      String data2_2 =
          removeCodesFromStrings(responseInString2_2, COMMAND_INDEX_2_GET_);
      print("2 " + data2_2);
      //productData["sl"]=data2;
      // print(data);

      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray3_0 = await characteristicRead.read();
      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray3 = await characteristicRead.read();
      String responseInString3 = utf8.decode(responseAray3);
      String data3 =
          removeCodesFromStrings(responseInString3, COMMAND_INDEX_3_GET_);
      print("3 " + data3);
      // productData["t_sl"]=data3;
      print(data);

      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray4_0 = await characteristicRead.read();
      await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_),
          withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray4 = await characteristicRead.read();
      String responseInString4 = utf8.decode(responseAray4);
      String data4 =
          removeCodesFromStrings(responseInString4, COMMAND_INDEX_4_GET_);
      print("4 " + data4);
      // productData["t_sl"]=data3;
      print(data);
    } catch (e) {
      print("my exception");
      print(e);
    }
  }

  Future<bool> writeCalibrationDate(
      {required BluetoothCharacteristic characteristicWrite,required String value}) async {
    String commandToWrite =
        COMMAND_INDEX_5_SET_CalCoefficient0thOrder + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> writeCalibrationExpieryDate(
      {required BluetoothCharacteristic characteristicWrite, required String value}) async {
    String commandToWrite =
        COMMAND_INDEX_6_SET_CalCoefficient0thOrder + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> writeCalibrationDataRanger(
      {required BluetoothCharacteristic characteristicWrite,required String value}) async {
    String commandToWrite =
        COMMAND_INDEX_7_SET_CalCoefficient0thOrder + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);



      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> readTestCounter({required BluetoothCharacteristic write,required BluetoothCharacteristic read})async {

    await write
        .write(StringToASCII(COMMAND_INDEX_10_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await read.read();
    await write.write(StringToASCII(COMMAND_INDEX_10_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray2 = await read.read();
    String responseInString = utf8.decode(responseAray2);
    String data =
    removeCodesFromStrings(responseInString, COMMAND_INDEX_10_GET_);
    print("1 " + data);
    return data;


  }

  Future<String> readAnalogGain({required BluetoothCharacteristic write,required BluetoothCharacteristic read})async {

    await write
        .write(StringToASCII(COMMAND_INDEX_15_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray = await read.read();
    await write.write(StringToASCII(COMMAND_INDEX_15_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
    List<int> responseAray2 = await read.read();
    String responseInString = utf8.decode(responseAray2);
    String data =
    removeCodesFromStrings(responseInString, COMMAND_INDEX_15_GET_);
    print("1 " + data);
    return data;


  }

  double getNumber(double input, {required int precision }) =>
      double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
}

Future<String> CalCoefficient0thOrder(
    {required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  print("write " + COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
  await characteristicWrite.write(
      StringToASCII(COMMAND_INDEX_14_GET_CalCoefficient0thOrder),
      withoutResponse: OsDependentSettings().writeWithresponse);
  List<int> responseAray = await characteristicRead.read();
  String responseInString = utf8.decode(responseAray);
  print("read " + responseInString);
  // setState(() {
  //   widget.COEFFICIENT_0_TH_ORDER = removeCodesFromStrings(responseInString, COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
  // });

  return removeCodesFromStrings(
      responseInString, COMMAND_INDEX_14_GET_CalCoefficient0thOrder);
}

Future<String> CalCoefficient1thOrder(
    {required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  await characteristicWrite.write(
      StringToASCII(COMMAND_INDEX_13_GET_CalCoefficient1thOrder),
      withoutResponse: OsDependentSettings().writeWithresponse);
  List<int> responseAray = await characteristicRead.read();
  String responseInString = utf8.decode(responseAray);
  return removeCodesFromStrings(
      responseInString, COMMAND_INDEX_13_GET_CalCoefficient1thOrder);
}

Future<String> CalCoefficient2thOrder(
    {required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  await characteristicWrite.write(
      StringToASCII(COMMAND_INDEX_12_GET_CalCoefficient2thOrder),
      withoutResponse: OsDependentSettings().writeWithresponse);
  List<int> responseAray = await characteristicRead.read();
  String responseInString = utf8.decode(responseAray);
  return removeCodesFromStrings(
      responseInString, COMMAND_INDEX_12_GET_CalCoefficient2thOrder);
}

Future<dynamic> fetchRawValue(
    {required BluetoothCharacteristic characteristicRead,
      required   BluetoothCharacteristic characteristicWrite}) async {
 // String responseInString;

  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_25_1),
      withoutResponse: OsDependentSettings().writeWithresponse);
  print("command  to go " + COMMAND_INDEX_25_1);
  List<int> responseAray = await characteristicRead.read();
  String responseInString = utf8.decode(responseAray);
  print("resonse  " + responseInString);

  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_25_1),
      withoutResponse: OsDependentSettings().writeWithresponse);
  print("command  to go " + COMMAND_INDEX_25_1);
  List<int> responseAray1 = await characteristicRead.read();
  String responseInString1 = utf8.decode(responseAray);
  print("resonse  " + responseInString);



  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_25_1),
      withoutResponse: OsDependentSettings().writeWithresponse);
  print("command  to go " + COMMAND_INDEX_25_1);
  List<int> responseAray2 = await characteristicRead.read();
  String responseInString2 = utf8.decode(responseAray2);
  print("resonse  " + responseInString);



  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_23_1),
      withoutResponse: OsDependentSettings().writeWithresponse);
  print("command  to go " + COMMAND_INDEX_23_1);
  List<int> responseAray23 = await characteristicRead.read();
  String responseInString23 = utf8.decode(responseAray23);
  print("resonse  " + responseInString);


  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_23_1),
      withoutResponse: OsDependentSettings().writeWithresponse);
  print("command  to go " + COMMAND_INDEX_23_1);
  responseAray23 = await characteristicRead.read();
   responseInString23 = utf8.decode(responseAray23);
  print("resonse  " + responseInString);

  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_23_1),
      withoutResponse: OsDependentSettings().writeWithresponse);
  print("command  to go " + COMMAND_INDEX_23_1);
  responseAray23 = await characteristicRead.read();
  responseInString23 = utf8.decode(responseAray23);
  print("resonse  " + responseInString);

  gettingDatafromPCBStream.getInstance().dataReload(false);
  return {"25":removeCodesFromStrings(responseInString2, COMMAND_INDEX_25_1),"23":double.parse(removeCodesFromStrings(responseInString23, COMMAND_INDEX_23_1)).toStringAsFixed(1)};
}

Future<String> fetchGauseValueFrom25(
    {required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {

  bool withoutResponse = false;
  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_23_1),
      withoutResponse: withoutResponse);
  print("command  to go " + COMMAND_INDEX_23_1);
  List<int> responseAray = await characteristicRead.read();
  String responseInString = utf8.decode(responseAray);
  print("resonse  " + responseInString);

  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_23_1),
      withoutResponse: withoutResponse);
  print("command  to go " + COMMAND_INDEX_23_1);
  List<int> responseAray1 = await characteristicRead.read();
  String responseInString1 = utf8.decode(responseAray);
  print("resonse  " + responseInString);

  await characteristicWrite.write(StringToASCII(COMMAND_INDEX_23_1),
      withoutResponse: withoutResponse);
  print("command  to go " + COMMAND_INDEX_23_1);
  List<int> responseAray2 = await characteristicRead.read();
  String responseInString2 = utf8.decode(responseAray2);
  // responseInString2 =( double.parse(responseInString2)).toStringAsFixed(1);
  print("resonse  " + responseInString);
  return removeCodesFromStrings(responseInString2, COMMAND_INDEX_23_1);
}

Future<String> CalCoefficient3thOrder(
    {required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  await characteristicWrite.write(
      StringToASCII(COMMAND_INDEX_11_GET_CalCoefficient3thOrder),
      withoutResponse: OsDependentSettings().writeWithresponse);
  List<int> responseAray = await characteristicRead.read();
  String responseInString = utf8.decode(responseAray);
  return removeCodesFromStrings(
      responseInString, COMMAND_INDEX_11_SET_CalCoefficient3thOrder);
}

Future<bool> setCalCoefficient0thOrder(
    {required String value,
      required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  String commandToWrite = COMMAND_INDEX_14_SET_CalCoefficient0thOrder +
      value +
      COMMAND_SUFFIX;
  print("command " + commandToWrite);

  try {
    await characteristicWrite.write(StringToASCII(commandToWrite),
        withoutResponse: OsDependentSettings().writeWithresponse);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> setCalCoefficient1stOrder(
    {required String value,
      required  BluetoothCharacteristic characteristicRead,
      required   BluetoothCharacteristic characteristicWrite}) async {
  String commandToWrite = COMMAND_INDEX_13_SET_CalCoefficient1thOrder +
      value +
      COMMAND_SUFFIX;
  print("command " + commandToWrite);

  try {
    await characteristicWrite.write(StringToASCII(commandToWrite),
        withoutResponse: OsDependentSettings().writeWithresponse);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
//COMMAND_INDEX_11_SET_CalCoefficient3thOrder

Future<bool> setCalCoefficient2ndOrder(
    {required String value,
      required  BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  String commandToWrite = COMMAND_INDEX_12_SET_CalCoefficient2thOrder  +value +
      COMMAND_SUFFIX;
  print("command " + commandToWrite);

  try {
    await characteristicWrite.write(StringToASCII(commandToWrite),
        withoutResponse: OsDependentSettings().writeWithresponse);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
Future<bool> setRange63(
    {required String value,
      required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  String commandToWrite = "SET|7|63" +value +
      COMMAND_SUFFIX;
  print("command " + commandToWrite);

  try {
    await characteristicWrite.write(StringToASCII(commandToWrite),
        withoutResponse: OsDependentSettings().writeWithresponse);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
Future<bool> setCalCoefficient3rdOrder(
    {required String value,
      required BluetoothCharacteristic characteristicRead,
      required BluetoothCharacteristic characteristicWrite}) async {
  String commandToWrite = COMMAND_INDEX_11_SET_CalCoefficient3thOrder +value +
      COMMAND_SUFFIX;
  print("command " + commandToWrite);

  try {
    await characteristicWrite.write(StringToASCII(commandToWrite),
        withoutResponse: OsDependentSettings().writeWithresponse);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

class CheckCalibrationActivity extends StatefulWidget {
  BluetoothDevice device;
  BluetoothCharacteristic characteristicRead;
  BluetoothCharacteristic characteristicWrite;
  String calibrationSavedId;
  List calibratedDataList;

  CheckCalibrationActivity(
      {required this.calibratedDataList,
        required  this.calibrationSavedId,
        required  this.device,
        required  this.characteristicRead,
        required  this.characteristicWrite});

  @override
  _CheckCalibrationActivityState createState() =>
      _CheckCalibrationActivityState();
}

class _CheckCalibrationActivityState extends State<CheckCalibrationActivity> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tryToConnect();
  }
  void tryToConnect() async {
    widget.device.state.listen((event) async {
      print("1");
      try {
        await widget.device.connect(autoConnect: false);
      } catch (e) {
        print("2");
        print(e);
        // if (e.code != 'already_connected') {
        //   print('already_connected');
        //   throw e;
        // }
      } finally {
        print('discover');
        await widget.device.discoverServices();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Calibration"),
      ),
      body: StreamBuilder<BluetoothDeviceState>(
          stream: widget.device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (context, snapshot) {
            if (snapshot.data == BluetoothDeviceState.connected) {
              return StreamBuilder<List<BluetoothService>>(
                  // Initialize FlutterFire:
                  //  future: Firebase.initializeApp(),
                  stream: widget.device.services,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.length > 0) {
                      // return Text("size "+snapshot.data.length.toString());

                    late  BluetoothCharacteristic cha;
                      //print( cha.);
                      // print("data  "+snapshot.data[3].characteristics[2].uuid.toString());

                     if(true) {
                       for (int i = 0; i < snapshot.data!.length; i++) {
                         print("h5");
                         print(snapshot.data![i].uuid.toString());
                         for (int j = 0; j <
                             snapshot.data![i].characteristics.length; j++) {
                           print("h6");
                           if ("f0001113-0451-4000-b000-000000000000" ==
                               snapshot.data![i].characteristics[j].uuid
                                   .toString()) {
                             print("h7");
                             cha = snapshot.data![i].characteristics[j];
                             break;
                           }
                         }
                       }
                     }
                      cha.setNotifyValue(true);
                      print("Hope i write here");
                     // print(snapshot.data[3].characteristics[0].uuid.toString());
                      //print(snapshot.data[3].characteristics[0].write(StringToByteArray("GET|1|")));
                      // snapshot.data[3].characteristics[0].write(StringToByteArray("GET|9|mukulDevice")).then((value) => {
                      //  print("print done, value is "+cha.value);
                      // });


                      return StreamBuilder<List<int>>(
                          stream: cha.value,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      convert(snapshot.data!).trim(),
                                      style: TextStyle(fontSize: 50),
                                    )),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                            child: Text(
                                          "Calib. Again",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                                      )),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          //CheckCalibFrom25Directory
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckCalibFrom25Directory(
                                                      calibrationSavedId: widget
                                                          .calibrationSavedId,
                                                      characteristicWrite: widget
                                                          .characteristicWrite,
                                                      characteristicRead: widget
                                                          .characteristicRead,
                                                    )),
                                          );
                                        },
                                        child: Center(
                                            child: Text(
                                          "Check Calibration",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                                      )),
                                    ],
                                  )
                                ],
                              );
                            } else
                              return Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 50),
                                    )),
                                  ),
                                ],
                              );
                          });
                    } else {
                      return Container(
                          height: 100,
                          child: Center(
                            child: InkWell(
                                onTap: () {},
                                child: Card(
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      "Start Reading",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          ));
                    }
                  });
            } else {
              return Container(
                  height: 300,
                  child: Center(
                    child: InkWell(
                        onTap: () {},
                        child: Card(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "Device is not connected",
                              style: TextStyle(color: Colors.white),
                            ))),
                  ));
            }
          }),
    );
  }
}

class CheckCalibFrom25Directory extends StatefulWidget {
  BluetoothCharacteristic characteristicRead;
  BluetoothCharacteristic characteristicWrite;
  List allRefData = [];
  String calibrationSavedId;

  CheckCalibFrom25Directory(
      {required this.calibrationSavedId,
        required  this.characteristicWrite,
        required  this.characteristicRead});

  @override
  _CheckCalibFrom25DirectoryState createState() =>
      _CheckCalibFrom25DirectoryState();
}

class _CheckCalibFrom25DirectoryState extends State<CheckCalibFrom25Directory> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,child: SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            children: [
              ApplicationAppbar().getAppbar(title: "Calibration"),
              Container(
                color: ThemeManager().getLightGrey10Color,
                height: height * 0.061,
                child: Container(
                  margin: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
                  ),

                  child: Row(
                    children: [

                      //------------------Back button---------
                      InkWell(
                        onTap: () {

                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: width * 0.043,
                              color: ThemeManager().getDarkGreenColor,
                            ),
                            Text(
                              TextConst.backText,
                              style: interMedium.copyWith(
                                  color: ThemeManager().getDarkGreenColor,
                                  fontSize: width * 0.043),
                            ),
                          ],
                        ),
                      ),

                      //-----------------Calculated Coefficients Header text------
                      Container(
                        margin: EdgeInsets.only(
                          left: width * 0.09,
                        ),
                        child: Text(
                          TextConst.inputRefValuesText,

                          style: interSemiBold.copyWith(
                              color: ThemeManager().getBlackColor,
                              fontSize: width * 0.043),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: height * 0.06,
                color: ThemeManager().getDarkGreenColor,

                //----------------------Table Title texts--------------------
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    //----------------Gauge value text----------
                    Expanded(
                      flex: 50,
                      child: Text(
                        TextConst.gaugeValueText,
                        style: interMedium.copyWith(
                            color: ThemeManager().getWhiteColor,
                            fontSize: width * 0.035),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    VerticalDivider(
                      thickness: width * 0.0003,
                      color: ThemeManager().getWhiteColor,
                    ),

                    //----------------Ref value Text----------
                    Expanded(
                        flex: 50,
                        child: Container(

                            padding: EdgeInsets.only(right: width * 0.05),
                            child: Text(
                              "Ref Value(kN)",
                              style: interMedium.copyWith(
                                  color: ThemeManager().getWhiteColor,
                                  fontSize: width * 0.035),
                              textAlign: TextAlign.center,
                            ))),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allRefData.length,
                  itemBuilder: (_, index) {

                    return Container(
                      padding:
                      EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                      decoration: BoxDecoration(
                        color: ThemeManager().getWhiteColor,
                        border: Border(
                            bottom: BorderSide(
                                color: ThemeManager().getLightGrey3Color,
                                width: height * 0.0007)),
                      ),
                      height: height * 0.055,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.allRefData[index]["data"].toString(),
                            style: interMedium.copyWith(fontSize: width * 0.038),
                          ),
                          Text(widget.allRefData[index]["ref"].toString(),
                            style: interSemiBold.copyWith(
                                fontSize: width * 0.034,
                                color: ThemeManager().getDarkGreenColor),
                          ),
                        ],
                      ),
                    );


                    return ListTile(
                      leading: Container(
                        width: 30,
                        height: 30,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.allRefData.removeAt(index);
                              });
                            },
                            child: Center(child: Icon(Icons.delete))),
                      ),
                      title: Text(widget.allRefData[index]["data"].toString()),
                      trailing: Text(widget.allRefData[index]["ref"].toString()),
                    );
                  }),


              GestureDetector(
                onTap: () {
                  fetchGauseValueFrom25(
                      characteristicRead: widget.characteristicRead,
                      characteristicWrite: widget.characteristicWrite)
                      .then((value) {
                    String rawValue = value.toString();
                    TextEditingController c = TextEditingController();
                    Widget dialogBody =   Wrap(
                    //  crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.01,
                              left: width * 0.04,
                              right: width * 0.04),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              //------PopUp header Add Ref. value text--
                              Text(
                                TextConst.addRefValueDialogText,
                                style: interSemiBold.copyWith(
                                  color: ThemeManager().getBlackColor,
                                  fontSize: width * 0.045,
                                ),
                              ),
                              InkWell(
                                  onTap: () {

                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: width * 0.06,
                                    color: ThemeManager().getLightGrey4Color,
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.015),
                          height: height * 0.001,
                          color: ThemeManager().getBlackColor.withOpacity(0.19),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.02,
                              left: width * 0.04,
                              right: width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  //---------Current Raw value text-------
                                  Text(
                                    TextConst.currentGaugeValueText,
                                    style: interMedium.copyWith(
                                      color: ThemeManager().getPopUpTextGreyColor,
                                      fontSize: width * 0.036,
                                    ),
                                  ),

                                  //-------Current Raw value data-------
                                  Text(
                                    rawValue.toString(),
                                    style: interMedium.copyWith(
                                      color: ThemeManager().getPopUpTextGreyColor,
                                      fontSize: width * 0.036,
                                    ),
                                  ),
                                ],
                              ),

                              //-------------Text field to add Ref. value---------
                              Container(
                                margin: EdgeInsets.only(top: height * 0.015),
                                child: TextFormField(  keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}'))
                    ],controller: c,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "5",
                                    hintStyle: interMedium.copyWith(
                                      color: ThemeManager().getLightGrey1Color,
                                      fontSize: width * 0.036,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(width * 0.014)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: height * 0.0,
                                        horizontal: width * 0.045),
                                    fillColor: ThemeManager().getLightGreenTextFieldColor,
                                    filled: true,
                                  ),
                                ),
                              ),

                              //-----------------Save button----------------
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.allRefData.add(
                                        {"data": rawValue, "ref": c.text});
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: height * 0.04, bottom: height * 0.02),
                                    height: height * 0.065,
                                    width: width,
                                    child: ButtonView(
                                        buttonLabel: TextConst.saveButtonText)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );

                    showDialog(
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                      // backgroundColor: Colors.white,
                        context: context,
                        //isScrollControlled: true,
                        builder: (context) => Dialog(elevation: 5,child:   dialogBody,));
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(
                      left: width * 0.057,
                      right: width * 0.057,
                      top: height * 0.03,
                    ),
                    height: height * 0.065,
                    width: width,
                    child: ButtonView(buttonLabel: TextConst.addRefValueText)),
              ),


            false?  InkWell(
                onTap: () {
                  fetchGauseValueFrom25(
                      characteristicRead: widget.characteristicRead,
                      characteristicWrite: widget.characteristicWrite)
                      .then((value) {
                    String rawValue = value.toString();
                    TextEditingController c = TextEditingController();

                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Current Gauge Value "),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(rawValue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  autofocus: true,
                                  controller: c,
                                  decoration: InputDecoration(
                                      contentPadding:
                                      EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      hintText: "Input ref. value"),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.allRefData.add(
                                        {"data": rawValue, "ref": c.text});
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                                  child: Card(
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(0.0),
                                    ),
                                    child: Container(
                                        height: 50,
                                        width:
                                        MediaQuery.of(context).size.width,
                                        child: Center(
                                            child: Text(
                                              "Add",
                                              style:
                                              TextStyle(color: Colors.white),
                                            ))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  });
                },
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add Ref Value",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ):Container(width: 0,height: 0,),
              widget.allRefData.length > 4
                  ? InkWell(
                onTap: () {

                  try{
                    print("calibration test save clicked");
                    FirebaseFirestore.instance
                        .collection("calibrations")
                        .doc(widget.calibrationSavedId)
                        .update({
                      "checkAfterCalibration": widget.allRefData
                    }).then((value) async {

                      DocumentSnapshot savedCalibration =await   FirebaseFirestore.instance
                          .collection("calibrations")
                          .doc(widget.calibrationSavedId).get();
                      List calibAdminInfoArray = [] ;
                      Uint8List list ;
                      String calibrationAdminId = savedCalibration.get("doneBy");
                      Uint8List seal ;
                      if(calibrationAdminId == "admin"){
                        QuerySnapshot data  = await FirebaseFirestore.instance.collection("Staht").get();

                        calibAdminInfoArray.add(["Issued By",data.docs.first.get("company_name")]);
                        calibAdminInfoArray.add(["Address",data.docs.first.get("company_address")]);
                        calibAdminInfoArray.add(["Telephone",data.docs.first.get("telephone")]);
                        seal = base64Decode(data.docs.first.get("seal"));
                        list = base64Decode(data.docs.first.get("logo"));
                      }else{
                        DocumentSnapshot calibAdminInfo = await FirebaseFirestore.instance.collection("calibratorPartners").doc(calibrationAdminId).get();

                        calibAdminInfoArray.add(["Issued By",calibAdminInfo.get("company_name")]);
                        calibAdminInfoArray.add(["Address",calibAdminInfo.get("company_address")]);
                        calibAdminInfoArray.add(["Telephone",calibAdminInfo.get("telephone")]);
                        seal = base64Decode(calibAdminInfo.get("seal"));


                        list = base64Decode(calibAdminInfo.get("logo"));
                      }







                      String productName = savedCalibration.get("productProfile")["productName"];
                      String sN =(1).toString();
                      String certificateId = savedCalibration.id;

                      String calibrationStandard =savedCalibration.get("productProfile")["standards"];
                      String calibrationprocedure = savedCalibration.get("productProfile")["procedure"];




                      List customerInfoArray = [] ;
                      customerInfoArray.add(["Issued to", savedCalibration.get("customerInfo")["prjectName"]]);
                      customerInfoArray.add(["Address",savedCalibration.get("customerInfo")["address"]]);
                      customerInfoArray.add(["Telephone",savedCalibration.get("customerInfo")["telephone"]]);
                      customerInfoArray.add(["Email",savedCalibration.get("customerInfo")["email"]]);

                      String approvedSignatory = savedCalibration.get("productProfile")["signatory"];
                      String code = savedCalibration.get("productProfile")["code"];
                      Uint8List signatorySignature = base64Decode( savedCalibration.get("productProfile")["signature"]);
                      String approvedSignatoryPosition = savedCalibration.get("productProfile")["signatory_position"];






                      //MediaQuery.of(context).size.width
                      List  refValData  = [];
                      //refValData.add(["Ref Read",]);
                      // refValData.add(["Output Read",]);

                      List dataAfterCalibration  =savedCalibration
                          .get(
                          "checkAfterCalibration");
                      List allref = ["CALIBRATED\nREFERENCE\nREADING",];
                      if(dataAfterCalibration!=null && dataAfterCalibration.length>0){
                        for(int i = 0 ; i < dataAfterCalibration.length ; i++){
                          allref.add(dataAfterCalibration[i]["ref"].toString());
                        }
                      }
                      refValData.add(allref);

                      List allOutput = ["PRODUCT\nOUTPUT\nREADING",];
                      if(dataAfterCalibration!=null && dataAfterCalibration.length>0){
                        for(int i = 0 ; i < dataAfterCalibration.length ; i++){
                          allOutput.add(double.parse(dataAfterCalibration[i]["data"].toString()).toStringAsFixed(1).toString());
                        }
                      }
                      refValData.add(allOutput);
                      var all = await FirebaseFirestore.instance.collection("calibrations").get();
                      String certNo = "STC000"+(500+all.docs.length).toString();

                      calCert(signatorySignature : signatorySignature,
                          productCode:code ,procedure: calibrationStandard,issuedByLogo: list,issuedBySeal:seal,issuedBy: calibAdminInfoArray[0][1],issuedByAddess:calibAdminInfoArray[1][1],issuedBytelephone: calibAdminInfoArray[2][1],productSN: savedCalibration.get("product")["2"] !=null?savedCalibration.get("product")["2"]:"--" ,
                          certificateNo: certNo,reffVal: allref,output: allOutput,condition: calibrationprocedure,issuedTo: customerInfoArray[0][1],issuedToAddress: customerInfoArray[1][1],issuedTotele:  customerInfoArray[2][1],issuedToEMail:  customerInfoArray[3][1],temp: "24.8 °C",signatoryName:approvedSignatory,signatoryPOsition:approvedSignatoryPosition, productName: savedCalibration.get("productProfile")["productName"]
                      );
                      // generateCalibrationCirtificate(context,500.00,list,refValData,calibAdminInfoArray,productName,sN,certificateId,calibrationStandard,calibrationprocedure,customerInfoArray,approvedSignatory,approvedSignatoryPosition);


                      dataSavedPopUp(context);





                      showAlertDialog(BuildContext context) {

                        // set up the button
                        Widget okButton = TextButton(
                          child: Text("Go to Home"),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Success"),
                          content: Text("Calibration has been done successfully"),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }

                      //showAlertDialog(context);

                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                    });
                  }catch(e){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                Scaffold(body: Center(child: Text(e.toString()),),)));

                  }

                },
                child: Container(
                    margin: EdgeInsets.only(
                      left: width * 0.057,
                      right: width * 0.057,
                      top: height * 0.03,
                    ),
                    height: height * 0.065,
                    width: width,
                    decoration: BoxDecoration(color: ThemeManager().getYellowGradientColor,borderRadius: BorderRadius.circular(height*0.008)),
                    child: Center(
                      child: Text("Save",
                        style: interSemiBold.copyWith(
                            fontSize: width*0.04, color: ThemeManager().getWhiteColor),
                      ),
                    )),
              )
                  : Container(
                height: 0,
                width: 0,
              )
            ],
          ),
        ),
      ),
    ),);
  }
}

class Directory_1_view_edit extends StatefulWidget {
  BluetoothCharacteristic bluetoothCharacteristicWrite;
  BluetoothCharacteristic bluetoothCharacteristicRead;
  String value = "Please wait";

  Directory_1_view_edit(
      {required this.bluetoothCharacteristicRead,required this.bluetoothCharacteristicWrite});

  @override
  _Directory_1_view_editState createState() => _Directory_1_view_editState();
}

class _Directory_1_view_editState extends State<Directory_1_view_edit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<bool> set(
      {required String value,
        required  BluetoothCharacteristic characteristicRead,
        required   BluetoothCharacteristic characteristicWrite}) async {
    String commandToWrite = COMMAND_INDEX_1_SET + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: InkWell(
        onTap: () {
          TextEditingController controler =
              TextEditingController(text: widget.value);
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controler,
                              decoration: InputDecoration(
                                labelText: 'ICE Serial',
                                //errorText: 'Please give  a name',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              set(
                                      value: controler.text,
                                      characteristicWrite:
                                          widget.bluetoothCharacteristicWrite,
                                      characteristicRead:
                                          widget.bluetoothCharacteristicRead)
                                  .then((value) {
                                print(value);
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.edit),
        ),
      ),
      title: Text("ICE Serial"),
      subtitle: Text(widget.value),
    );
  }

  void getData() async {
    dynamic productData;

    try {
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.bluetoothCharacteristicRead.read();
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2 = await widget.bluetoothCharacteristicRead.read();
      String responseInString = utf8.decode(responseAray2);
      String data =
          removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
      print("1 " + data);

      setState(() {
        widget.value = data;
      });
      productInfoGlobal["1"] = data;
      currentProductInfo.add(data);
      //currentProductInfo["1"]=data;
      // productData["ice_sl"]=data;
      //print(data);

      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2 = await characteristicRead.read();
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2_2 = await characteristicRead.read();
      // String  responseInString2_2 = utf8.decode(responseAray2_2);
      // String  data2_2 = removeCodesFromStrings(
      //     responseInString2_2, COMMAND_INDEX_2_GET_);
      // print("2 "+data2_2);
      // //productData["sl"]=data2;
      // // print(data);
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3 = await characteristicRead.read();
      // String  responseInString3 = utf8.decode(responseAray3);
      // String  data3 = removeCodesFromStrings(
      //     responseInString3, COMMAND_INDEX_3_GET_);
      // print("3 "+data3);
      // // productData["t_sl"]=data3;
      // print(data);
      //
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4 = await characteristicRead.read();
      // String  responseInString4 = utf8.decode(responseAray4);
      // String  data4 = removeCodesFromStrings(
      //     responseInString4, COMMAND_INDEX_4_GET_);
      // print("4 "+data4);
      // // productData["t_sl"]=data3;
      // print(data);

    } catch (e) {
      print("my exception");
      print(e);
    }
  }
}

class Directory_2_view_edit extends StatefulWidget {
  BluetoothCharacteristic bluetoothCharacteristicWrite;
  BluetoothCharacteristic bluetoothCharacteristicRead;
  String value = "Please wait";

  Directory_2_view_edit(
      {required this.bluetoothCharacteristicRead, required this.bluetoothCharacteristicWrite});

  @override
  _Directory_2_view_editState createState() => _Directory_2_view_editState();
}

class _Directory_2_view_editState extends State<Directory_2_view_edit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: InkWell(
        onTap: () {
          TextEditingController controler =
              TextEditingController(text: widget.value);
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controler,
                              decoration: InputDecoration(
                                labelText: 'Serial',
                                //errorText: 'Please give  a name',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              set(
                                      value: controler.text,
                                      characteristicWrite:
                                          widget.bluetoothCharacteristicWrite,
                                      characteristicRead:
                                          widget.bluetoothCharacteristicRead)
                                  .then((value) {
                                print(value);
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.edit),
        ),
      ),
      title: Text("Serial"),
      subtitle: Text(widget.value),
    );
  }

  void getData() async {
    dynamic productData;

    try {
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.bluetoothCharacteristicRead.read();
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2 = await widget.bluetoothCharacteristicRead.read();
      String responseInString = utf8.decode(responseAray2);
      String data =
          removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
      print("1 " + data);

      setState(() {
        widget.value = data;
      });
      productInfoGlobal["2"] = data;
      currentProductInfo.add(data);
      // productData["ice_sl"]=data;
      //print(data);

      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2 = await characteristicRead.read();
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2_2 = await characteristicRead.read();
      // String  responseInString2_2 = utf8.decode(responseAray2_2);
      // String  data2_2 = removeCodesFromStrings(
      //     responseInString2_2, COMMAND_INDEX_2_GET_);
      // print("2 "+data2_2);
      // //productData["sl"]=data2;
      // // print(data);
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3 = await characteristicRead.read();
      // String  responseInString3 = utf8.decode(responseAray3);
      // String  data3 = removeCodesFromStrings(
      //     responseInString3, COMMAND_INDEX_3_GET_);
      // print("3 "+data3);
      // // productData["t_sl"]=data3;
      // print(data);
      //
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4 = await characteristicRead.read();
      // String  responseInString4 = utf8.decode(responseAray4);
      // String  data4 = removeCodesFromStrings(
      //     responseInString4, COMMAND_INDEX_4_GET_);
      // print("4 "+data4);
      // // productData["t_sl"]=data3;
      // print(data);

    } catch (e) {
      print("my exception");
      print(e);
    }
  }

  set(
      {required String value,
        required   BluetoothCharacteristic characteristicWrite,
        required  BluetoothCharacteristic characteristicRead}) async {
    String commandToWrite = COMMAND_INDEX_2_SET + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Directory_3_view_edit extends StatefulWidget {
  BluetoothCharacteristic bluetoothCharacteristicWrite;
  BluetoothCharacteristic bluetoothCharacteristicRead;
  String value = "Please wait";

  Directory_3_view_edit(
      {required this.bluetoothCharacteristicRead,required this.bluetoothCharacteristicWrite});

  @override
  _Directory_3_view_editState createState() => _Directory_3_view_editState();
}

class _Directory_3_view_editState extends State<Directory_3_view_edit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(

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
                  Text("Transducer Serial",
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
                    child: Text(widget.value,
                      style: interRegular.copyWith(
                          color: ThemeManager().getLightGrey5Color,
                          fontSize: width * 0.030),
                    ),
                  ),
                ],
              ),

              //-------------------- Edit Detail PopUp ---------------------
              InkWell(
                onTap: () {
                  TextEditingController controler =
                  TextEditingController(text: widget.value);
                  Widget body = Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: height * 0.02, left: width * 0.04, right: width * 0.04),
                        child: Stack(
                          children: [
                            Align(alignment: Alignment.centerLeft,child:  Text('Transducer Serial',
                              style: interSemiBold.copyWith(
                                color: ThemeManager().getBlackColor,
                                fontSize: width * 0.039,
                              ),
                            ),),
                            Align(alignment: Alignment.centerRight,child:   GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: width * 0.06,
                                  color: ThemeManager().getLightGrey4Color,
                                )),)


                            //----------------------Close icon-----------------------

                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.015),
                        height: height * 0.001,
                        color: ThemeManager().getBlackColor.withOpacity(0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controler,
                          decoration:InputDecoration(
                              border: InputBorder.none,fillColor: ThemeManager().getLightGrey10Color,filled: true
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          set(
                              value: controler.text,
                              characteristicWrite:
                              widget.bluetoothCharacteristicWrite,
                              characteristicRead:
                              widget.bluetoothCharacteristicRead)
                              .then((value) {
                            print(value);
                            getData();
                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              color: ThemeManager().getDarkGreenColor,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Update",
                                  style: interSemiBold.copyWith(
                                    color: ThemeManager().getWhiteColor,
                                    fontSize: width * 0.039,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );


                  showDialog(
                      context: context,
                      builder: (_) => Dialog(elevation: 5,child:body ,)
                  );

                  // showModalBottomSheet(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //         BorderRadius.vertical(top: Radius.circular(25.0))),
                  //     backgroundColor: Colors.white,
                  //     context: context,
                  //     isScrollControlled: true,
                  //     builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
                  //       child: Padding(
                  //         padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                  //         child: body,
                  //       ),
                  //     ));
                },
                child: Image.asset(
                  "assets/icons/editIcon.png",
                  color: ThemeManager().getDarkGreenColor,
                ),
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
    );
    return ListTile(
      trailing: InkWell(
        onTap: () {
          TextEditingController controler =
              TextEditingController(text: widget.value);
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controler,
                              decoration: InputDecoration(
                                labelText: 'Transducer Serial',
                                //errorText: 'Please give  a name',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              set(
                                      value: controler.text,
                                      characteristicWrite:
                                          widget.bluetoothCharacteristicWrite,
                                      characteristicRead:
                                          widget.bluetoothCharacteristicRead)
                                  .then((value) {
                                print(value);
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.edit),
        ),
      ),
      title: Text("Transducer Serial"),
      subtitle: Text(widget.value),
    );
  }

  void getData() async {
    dynamic productData;

    try {
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.bluetoothCharacteristicRead.read();
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2 = await widget.bluetoothCharacteristicRead.read();
      String responseInString = utf8.decode(responseAray2);
      String data =
          removeCodesFromStrings(responseInString, COMMAND_INDEX_3_GET_);
      print("1 " + data);

      setState(() {
        widget.value = data;
      });
      productInfoGlobal["3"] = data;
      currentProductInfo.add(data);
      // productData["ice_sl"]=data;
      //print(data);

      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2 = await characteristicRead.read();
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2_2 = await characteristicRead.read();
      // String  responseInString2_2 = utf8.decode(responseAray2_2);
      // String  data2_2 = removeCodesFromStrings(
      //     responseInString2_2, COMMAND_INDEX_2_GET_);
      // print("2 "+data2_2);
      // //productData["sl"]=data2;
      // // print(data);
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3 = await characteristicRead.read();
      // String  responseInString3 = utf8.decode(responseAray3);
      // String  data3 = removeCodesFromStrings(
      //     responseInString3, COMMAND_INDEX_3_GET_);
      // print("3 "+data3);
      // // productData["t_sl"]=data3;
      // print(data);
      //
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4 = await characteristicRead.read();
      // String  responseInString4 = utf8.decode(responseAray4);
      // String  data4 = removeCodesFromStrings(
      //     responseInString4, COMMAND_INDEX_4_GET_);
      // print("4 "+data4);
      // // productData["t_sl"]=data3;
      // print(data);

    } catch (e) {
      print("my exception");
      print(e);
    }
  }

  set(
      {required String value,
        required BluetoothCharacteristic characteristicWrite,
        required BluetoothCharacteristic characteristicRead}) async {
    //COMMAND_INDEX_3_SET_

    String commandToWrite = COMMAND_INDEX_3_SET_ + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Directory_4_view_edit extends StatefulWidget {
  BluetoothCharacteristic bluetoothCharacteristicWrite;
  BluetoothCharacteristic bluetoothCharacteristicRead;
  String value = "Please wait";
  String dateV = "Choose Date";

  Directory_4_view_edit(
      {required this.bluetoothCharacteristicRead, required this.bluetoothCharacteristicWrite});

  @override
  _Directory_4_view_editState createState() => _Directory_4_view_editState();
}

class _Directory_4_view_editState extends State<Directory_4_view_edit> {
  TextEditingController controler = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {

    return  InkWell(onTap: (){

      Widget body = Wrap(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextButton(
          //       onPressed: () {
          //         DatePicker.showDatePicker(context,
          //             showTitleActions: true,
          //             minTime: DateTime(2021, 1, 1),
          //             maxTime: DateTime(2022, 12,31), onChanged: (date) {
          //               print('change $date');
          //             }, onConfirm: (date) {
          //               setState(() {
          //                 widget.dateV = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
          //               });
          //               print(widget.dateV);
          //             }, currentTime: DateTime.now(), locale: LocaleType.en);
          //       },
          //       child: Text(
          //         widget.dateV,
          //         style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold),
          //       )),
          // ),


          Container(
            margin: EdgeInsets.only(
                top: height * 0.02, left: width * 0.04, right: width * 0.04),
            child: Stack(
              children: [
                Align(alignment: Alignment.centerLeft,child:  Text("Menufacture Date",
                  style: interSemiBold.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.039,
                  ),
                ),),
                Align(alignment: Alignment.centerRight,child:   GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.clear,
                      size: width * 0.06,
                      color: ThemeManager().getLightGrey4Color,
                    )),)


                //----------------------Close icon-----------------------

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.015),
            height: height * 0.001,
            color: ThemeManager().getBlackColor.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controler,
              decoration: InputDecoration(
                  border: InputBorder.none,fillColor: ThemeManager().getLightGrey10Color,filled: true
              ),
            ),
          ),

          InkWell(
            onTap: () {
              set(
                  value: controler.text,
                  characteristicWrite:
                  widget.bluetoothCharacteristicWrite,
                  characteristicRead:
                  widget.bluetoothCharacteristicRead)
                  .then((value) {
                print(value);
                getData();
                Navigator.pop(context);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: ThemeManager().getDarkGreenColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Update",
                      style: interSemiBold.copyWith(
                        color: ThemeManager().getWhiteColor,
                        fontSize: width * 0.039,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );



      showDialog(
          context: context,
          builder: (_) => Dialog(elevation: 5,child:body ,)
      );


      // showModalBottomSheet(
      //     shape: RoundedRectangleBorder(
      //         borderRadius:
      //         BorderRadius.vertical(top: Radius.circular(25.0))),
      //     backgroundColor: Colors.white,
      //     context: context,
      //     isScrollControlled: true,
      //     builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
      //       child: Padding(
      //         padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
      //         child:body ,
      //       ),
      //     ));
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
                    Text("Manufacture Date",
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
                        child :Text(widget.value,style: interRegular.copyWith(
                            color: ThemeManager().getLightGrey5Color,
                            fontSize: width * 0.030))
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
    );
    return ListTile(
      trailing: InkWell(
        onTap: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                      child: Wrap(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextButton(
                          //       onPressed: () {
                          //         DatePicker.showDatePicker(context,
                          //             showTitleActions: true,
                          //             minTime: DateTime(2021, 1, 1),
                          //             maxTime: DateTime(2022, 12,31), onChanged: (date) {
                          //               print('change $date');
                          //             }, onConfirm: (date) {
                          //               setState(() {
                          //                 widget.dateV = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                          //               });
                          //               print(widget.dateV);
                          //             }, currentTime: DateTime.now(), locale: LocaleType.en);
                          //       },
                          //       child: Text(
                          //         widget.dateV,
                          //         style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold),
                          //       )),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controler,
                              decoration: InputDecoration(
                                labelText: 'Menufacture Date',
                                //errorText: 'Please give  a name',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              set(
                                      value: controler.text,
                                      characteristicWrite:
                                          widget.bluetoothCharacteristicWrite,
                                      characteristicRead:
                                          widget.bluetoothCharacteristicRead)
                                  .then((value) {
                                print(value);
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.edit),
        ),
      ),
      title: Text("Manufacture Date"),
      subtitle: Text(widget.value),
    );
  }

  void getData() async {
    dynamic productData;

    try {
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.bluetoothCharacteristicRead.read();
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2 = await widget.bluetoothCharacteristicRead.read();
      String responseInString = utf8.decode(responseAray2);
      String data =
          removeCodesFromStrings(responseInString, COMMAND_INDEX_4_GET_);
      print("1 " + data);

      setState(() {
        widget.value = data;
      });
      productInfoGlobal["4"] = data;
      currentProductInfo.add(data);
      // productData["ice_sl"]=data;
      //print(data);

      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2 = await characteristicRead.read();
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2_2 = await characteristicRead.read();
      // String  responseInString2_2 = utf8.decode(responseAray2_2);
      // String  data2_2 = removeCodesFromStrings(
      //     responseInString2_2, COMMAND_INDEX_2_GET_);
      // print("2 "+data2_2);
      // //productData["sl"]=data2;
      // // print(data);
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3 = await characteristicRead.read();
      // String  responseInString3 = utf8.decode(responseAray3);
      // String  data3 = removeCodesFromStrings(
      //     responseInString3, COMMAND_INDEX_3_GET_);
      // print("3 "+data3);
      // // productData["t_sl"]=data3;
      // print(data);
      //
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4 = await characteristicRead.read();
      // String  responseInString4 = utf8.decode(responseAray4);
      // String  data4 = removeCodesFromStrings(
      //     responseInString4, COMMAND_INDEX_4_GET_);
      // print("4 "+data4);
      // // productData["t_sl"]=data3;
      // print(data);

    } catch (e) {
      print("my exception");
      print(e);
    }
  }

  set(
      {required String value,
      required BluetoothCharacteristic characteristicWrite,
        required  BluetoothCharacteristic characteristicRead}) async {
    String commandToWrite = COMMAND_INDEX_4_SET_ + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);


    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      return false;
    }
  }
}
double getNumber(double input, {int precision = 1}) =>
    double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
class Directory_9_view_edit extends StatefulWidget {
  BluetoothCharacteristic bluetoothCharacteristicWrite;
  BluetoothCharacteristic bluetoothCharacteristicRead;
  String value = "Please wait";

  Directory_9_view_edit(
      {required this.bluetoothCharacteristicRead, required this.bluetoothCharacteristicWrite});

  @override
  _Directory_9_view_editState createState() => _Directory_9_view_editState();
}

class _Directory_9_view_editState extends State<Directory_9_view_edit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: widget.value);

    return  InkWell(onTap: (){
      Widget body  = Wrap(
        children: [

          Container(
            margin: EdgeInsets.only(
                top: height * 0.02, left: width * 0.04, right: width * 0.04),
            child: Stack(
              children: [
                Align(alignment: Alignment.centerLeft,child:  Text("Broadcast name",
                  style: interSemiBold.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.039,
                  ),
                ),),
                Align(alignment: Alignment.centerRight,child:   GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.clear,
                      size: width * 0.06,
                      color: ThemeManager().getLightGrey4Color,
                    )),)


                //----------------------Close icon-----------------------

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.015),
            height: height * 0.001,
            color: ThemeManager().getBlackColor.withOpacity(0.2),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextButton(
          //       onPressed: () {
          //         DatePicker.showDatePicker(context,
          //             showTitleActions: true,
          //             minTime: DateTime(2021, 1, 1),
          //             maxTime: DateTime(2022, 12,31), onChanged: (date) {
          //               print('change $date');
          //             }, onConfirm: (date) {
          //               setState(() {
          //                 widget.dateV = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
          //               });
          //               print(widget.dateV);
          //             }, currentTime: DateTime.now(), locale: LocaleType.en);
          //       },
          //       child: Text(
          //         widget.dateV,
          //         style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold),
          //       )),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller,
              decoration:InputDecoration(
                  border: InputBorder.none,fillColor: ThemeManager().getLightGrey10Color,filled: true
              ),
            ),
          ),

          InkWell(
            onTap: () {
              set(
                  value: controller.text,
                  characteristicWrite:
                  widget.bluetoothCharacteristicWrite,
                  characteristicRead:
                  widget.bluetoothCharacteristicRead)
                  .then((value) {
                print(value);
                getData();
                Navigator.pop(context);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: ThemeManager().getDarkGreenColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Update",
                      style: interSemiBold.copyWith(
      color: ThemeManager().getWhiteColor,
      fontSize: width * 0.039,
      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );


      showDialog(
          context: context,
          builder: (_) => Dialog(elevation: 5,child:body ,)
      );

      // showModalBottomSheet(
      //     shape: RoundedRectangleBorder(
      //         borderRadius:
      //         BorderRadius.vertical(top: Radius.circular(25.0))),
      //     backgroundColor: Colors.white,
      //     context: context,
      //     isScrollControlled: true,
      //     builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
      //       child: Padding(
      //         padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
      //         child: body,
      //       ),
      //     ));
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
                    Text("Broadcast Name",
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
                        child :Text(widget.value,style: interRegular.copyWith(
                            color: ThemeManager().getLightGrey5Color,
                            fontSize: width * 0.030))
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
    );
    return ListTile(
      trailing: InkWell(
        onTap: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(height: SizePannel(context: context).broadcastNameBottomSheetHeight,
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                      child: Wrap(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextButton(
                          //       onPressed: () {
                          //         DatePicker.showDatePicker(context,
                          //             showTitleActions: true,
                          //             minTime: DateTime(2021, 1, 1),
                          //             maxTime: DateTime(2022, 12,31), onChanged: (date) {
                          //               print('change $date');
                          //             }, onConfirm: (date) {
                          //               setState(() {
                          //                 widget.dateV = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                          //               });
                          //               print(widget.dateV);
                          //             }, currentTime: DateTime.now(), locale: LocaleType.en);
                          //       },
                          //       child: Text(
                          //         widget.dateV,
                          //         style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold),
                          //       )),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: 'Broadcast name',
                                //errorText: 'Please give  a name',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              set(
                                      value: controller.text,
                                      characteristicWrite:
                                          widget.bluetoothCharacteristicWrite,
                                      characteristicRead:
                                          widget.bluetoothCharacteristicRead)
                                  .then((value) {
                                print(value);
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.edit),
        ),
      ),
      title: Text("Broadcast Name"),
      subtitle: Text(widget.value),
    );
  }

  void getData() async {
    dynamic productData;

    try {
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_9_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray = await widget.bluetoothCharacteristicRead.read();
      await widget.bluetoothCharacteristicWrite
          .write(StringToASCII(COMMAND_INDEX_9_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      List<int> responseAray2 = await widget.bluetoothCharacteristicRead.read();
      String responseInString = utf8.decode(responseAray2);
      String data =
          removeCodesFromStrings(responseInString, COMMAND_INDEX_9_GET_);
      print("1 " + data);

      setState(() {
        widget.value = data;
      });
      productInfoGlobal["9"] = data;
      currentProductInfo.add(data);
      print(productInfoGlobal);
      // productData["ice_sl"]=data;
      //print(data);

      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2 = await characteristicRead.read();
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray2_2 = await characteristicRead.read();
      // String  responseInString2_2 = utf8.decode(responseAray2_2);
      // String  data2_2 = removeCodesFromStrings(
      //     responseInString2_2, COMMAND_INDEX_2_GET_);
      // print("2 "+data2_2);
      // //productData["sl"]=data2;
      // // print(data);
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_3_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray3 = await characteristicRead.read();
      // String  responseInString3 = utf8.decode(responseAray3);
      // String  data3 = removeCodesFromStrings(
      //     responseInString3, COMMAND_INDEX_3_GET_);
      // print("3 "+data3);
      // // productData["t_sl"]=data3;
      // print(data);
      //
      //
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4_0 = await characteristicRead.read();
      // await characteristicWrite.write(StringToASCII(COMMAND_INDEX_4_GET_), withoutResponse: OsDependentSettings().writeWithresponse);
      // List<int>   responseAray4 = await characteristicRead.read();
      // String  responseInString4 = utf8.decode(responseAray4);
      // String  data4 = removeCodesFromStrings(
      //     responseInString4, COMMAND_INDEX_4_GET_);
      // print("4 "+data4);
      // // productData["t_sl"]=data3;
      // print(data);

    } catch (e) {
      print("my exception");
      print(e);
    }
  }

  set(
      {required String value,
      required BluetoothCharacteristic characteristicWrite,
      required BluetoothCharacteristic characteristicRead}) async {
    String commandToWrite = COMMAND_INDEX_9__2 + value + COMMAND_SUFFIX;
    print("command " + commandToWrite);

    try {
      await characteristicWrite.write(StringToASCII(commandToWrite),
          withoutResponse: OsDependentSettings().writeWithresponse);
      return true;
    } catch (e) {
      return false;
    }
  }
}
showErrorMsgAsAlertDialog(String msg,BuildContext context){
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Occured"),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialog(context);
}

Widget dataSavedPopUp(BuildContext context){
  return Container(
    margin: EdgeInsets.only(
        right: width * 0.05, left: width * 0.05),

    child: Dialog(
      backgroundColor: Colors.transparent.withOpacity(0.0001),
      insetPadding: EdgeInsets.zero,

      child: Container(
        width: width,
        height: height*0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.012),
          color: ThemeManager().getWhiteColor,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.03,bottom: height*0.038),
              width: double.infinity,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    "Data Saved. ",textAlign: TextAlign.center,
                    style: interMedium.copyWith(
                        fontSize: width * 0.047,
                        color: ThemeManager().getBlackColor),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: height*0.006),
                    child: Text("Remove Load to 0.0 kN",textAlign: TextAlign.center,
                        style: interMedium.copyWith(
                            fontSize: width * 0.047,
                            color: ThemeManager().getBlackColor)),
                  )
                ],
              ),
            ),


            Container(
                margin: EdgeInsets.only(
                    right: width * 0.05,
                    left: width * 0.05),
                child: InkWell(
                    onTap: () {

                      Navigator.pop(context);
                    },
                    child: ButtonView(
                        buttonLabel: TextConst.okText)))
          ],
        ),
      ),

    ),
  );
}