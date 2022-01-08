import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io';
import 'package:connect/models/CustomImageModel.dart';
import 'package:image/image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'dart:math';
import 'package:convert/convert.dart';
import 'dart:io' as Io;
import 'package:image/image.dart';
List<String> getImagesData(String path) {
  List<String> allPixels = [];

  var image = decodeImage(File(path).readAsBytesSync());
  image!.getBytes(format: Format.luminance);
  print("the whole image");
  print(image.getBytes(format: Format.luminance).toString());

  List<int>all = image.getBytes(format: Format.luminance);
  int highest = 0 ;
  int losest = 0 ;
  int temp =  0 ;
  for(int i = 0 ;i<all.length;i++){
    if(all[i]>highest) highest = all[i];
    if(all[i]<losest) losest = all[i];
  }
  print("low "+losest.toString());
  print("high "+highest.toString());
  print("my pixel " + image.getPixel(0, 0).toRadixString(16));
  int height = image.height;
  int width = image.width;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      allPixels.add("0x"+image.getPixel(i, j).toRadixString(16));
    }
  }
  return allPixels;
}
List<String> getImagesData2(String path) {
  List<String> allPixels = [];

  var image = decodeImage(File(path).readAsBytesSync());
  image!.getBytes(format: Format.luminance);
 // print("the whole image");
  print(image.getBytes(format: Format.luminance).toString());

  List<int>all = image.getBytes(format: Format.luminance);


 // print("my pixel " + image.getPixel(0, 0).toRadixString(16));
  int height = image.height;
  int width = image.width;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      allPixels.add("0x"+image.getPixel(i, j).toRadixString(16));

    //  allPixels.add(image.getPixel(i, j).toSigned(5));
    }
  }
  return allPixels;
}

Future<ImageModelCustom> getImagesDataInt(String path) {
  var image = decodeImage(File(path).readAsBytesSync());




  //List<int> pix = [255,255,255];

  //convert2(pix);
  print("now read");
 // print(image.getBytes(format: Format.rgb));
  var thumbnail = copyResize(image!, width: 128,height: 160);
  ImageModelCustom imageModelCustom = ImageModelCustom(width: thumbnail.width,height:thumbnail.height,allPixels: thumbnail.getBytes(format: Format.rgb));
  print("picked image "+imageModelCustom.height.toString());
  print("picked image "+imageModelCustom.width.toString());
 return  Future.value(imageModelCustom);
}
Future<ImageModelCustom> getImagesDataIntByte(Uint8List data) {
  var image = decodeImage(data);




  //List<int> pix = [255,255,255];

  //convert2(pix);
  print("now read");
 // print(image.getBytes(format: Format.rgb));
 // var thumbnail = copyResize(image!, width: 128,height: 160);
  ImageModelCustom imageModelCustom = ImageModelCustom(width: image!.width,height:image!.height,allPixels: image!.getBytes(format: Format.rgb));
  print("picked image "+imageModelCustom.height.toString());
  print("picked image "+imageModelCustom.width.toString());
 return  Future.value(imageModelCustom);
}
Future<ImageModelCustom> getImagesDataIntW(String path) {
  var image = decodeImage(File(path).readAsBytesSync());




  //List<int> pix = [255,255,255];

  //convert2(pix);
  print("now read");
  // print(image.getBytes(format: Format.rgb));
  var thumbnail = copyResize(image!, width: 200,height: 200);
  ImageModelCustom imageModelCustom = ImageModelCustom(width: thumbnail.width,height:thumbnail.height,allPixels: thumbnail.getBytes(format: Format.rgb));
  print("picked image "+imageModelCustom.height.toString());
  print("picked image "+imageModelCustom.width.toString());
  return  Future.value(imageModelCustom);
}

CustomImageModel(){

}


String convert2(List<int> data) {

  print("doing some extra");
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

// Widget generateImage(List<int> allpixel){
//
// //  var image =
//
//   // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
// //  var thumbnail = copyResize(image, width: 128);
//  // var image = Im.fromBytes(width, height, bytes)
//  base64Encode(allpixel)
//   return Image.file('thumbnail.png');
//
//   // Save the thumbnail as a PNG.
//
// }
