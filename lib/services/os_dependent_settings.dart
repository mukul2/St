import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue/flutter_blue.dart';

class OsDependentSettings {
  late Platform platform;





  String get TI_OAD_IMAGE_BLOCK_REQUEST => "f000ffc2-0451-4000-b000-000000000000";

  bool get writeWithresponse => Platform.isAndroid?true:false;
  String get writeUid => "F0001111-0451-4000-B000-000000000000";
  String get readUid => "F0001112-0451-4000-B000-000000000000";
  String get TI_OAD_IMAGE_CONTROL => "f000ffc5-0451-4000-b000-000000000000";


/*! Characteristic used to identify and approve a new image */
  String get  TI_OAD_IMAGE_NOTIFY  => "f000ffc1-0451-4000-b000-000000000000";

  Future<Map<String,BluetoothCharacteristic>> getOADCharacters({required BluetoothDevice device})async{
  late  BluetoothCharacteristic header;
  late  BluetoothCharacteristic image;
  late BluetoothCharacteristic startStop;





    List<BluetoothService> allService = await device.discoverServices();

    for (int i = 0;
    i < allService.length;
    i++) {

      for (int j = 0;
      j <
          allService[i].characteristics.length;
      j++) {
       // print(i.toString()+"  "+j.toString());
       // print(allService[i].toString());
        print("check "+allService[i].characteristics[j].uuid.toString());

        if (TI_OAD_IMAGE_BLOCK_REQUEST.toLowerCase() ==
            allService[i].characteristics[j].uuid
                .toString().toLowerCase()) {


          image = allService[i].characteristics[j];

          print("image found");

        }
        if (TI_OAD_IMAGE_CONTROL.toLowerCase() ==
            allService[i].characteristics[j].uuid
                .toString().toLowerCase()) {


          startStop = allService[i].characteristics[j];

          print("stopstart found");

        }
        if (TI_OAD_IMAGE_NOTIFY.toLowerCase() ==
            allService[i].characteristics[j].uuid
                .toString().toLowerCase()) {


          header = allService[i].characteristics[j];

          print("header found");
        //  break;
        }
      }
    }

    return {"header": header, "image": image, "startStop": startStop};

    }


  Future getReadWriteCharacters({required BluetoothDevice device})async{
    List<BluetoothService> allService = await await device.discoverServices();;
    BluetoothCharacteristic read = allService.first.characteristics.first;
    BluetoothCharacteristic write = allService.first.characteristics.first;




    print(allService.length.toString());

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

    return {"read":read,"write":write};
  }


}