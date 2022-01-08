/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:io';

import 'package:intl/intl.dart';
import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';


final lorem = pw.LoremText();
Future<void> calCert({required Uint8List signatorySignature,required String procedure,required String productCode,required Uint8List issuedByLogo,required Uint8List issuedBySeal,required String issuedBy,required String issuedByAddess,required String issuedBytelephone,required String productName,required String productSN,required String certificateNo,required List reffVal,required List output,required String condition,required String issuedTo,required String issuedToAddress,required String issuedTotele,required String issuedToEMail,required String temp,required String signatoryName,required String signatoryPOsition}) async {


  final font = await rootBundle.load("assets/fonts/Inter-Regular.ttf");
  final fontB = await rootBundle.load("assets/fonts/Inter-SemiBold.ttf");

  double fontSize = 11;

  final ttf = pw.Font.ttf(font);
  final ttfBold = pw.Font.ttf(fontB);
 // List<String>typeOne = ["Calibrated\nReference\nReading","1","2","3","4","5"];
  // List<String>typeOne = ["Reference","1","2","3","4","5"];
  //List<String>typeTwo = ["Product\nOutput\nReading","1","4","9","16","25"];
  // List<String>typeTwo = ["Output","1","4","9","16","25"];

  List<pw.Container> list1= [];
  List<pw.Container> list2= [];
  for(int i = 0 ; i <reffVal.length ; i++ ){
    if(i == 0) {
      list1.add(pw.Container(decoration: pw.BoxDecoration(color: PdfColors.grey300,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width: 116,height: 77,child: pw.Padding(padding: pw.EdgeInsets.only(left: 15),child: pw.Center(child: pw.Stack(children: [
        pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text(reffVal[i],style: pw.TextStyle(lineSpacing: 1.5,font: ttfBold,fontSize: fontSize,fontWeight: pw.FontWeight.normal)))
      ])))));
      list2.add(pw.Container(decoration: pw.BoxDecoration(color: PdfColors.grey300,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width: 116,height: 77,child: pw.Padding(padding: pw.EdgeInsets.only(left: 15),child:pw.Stack(children: [
        pw.Align(child: pw.Text(output[i],style: pw.TextStyle(lineSpacing: 1.5,font: ttfBold,fontSize: fontSize,fontWeight: pw.FontWeight.normal)),alignment: pw.Alignment.centerLeft)
      ]))));
    }else{
      list1.add(pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width: 66,height: 77,child:  pw.Center(child:pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Center(child: pw.Text(reffVal[i],style: pw.TextStyle(font: ttf,fontSize: fontSize,fontWeight: pw.FontWeight.normal)))))));
      list2.add(pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width: 66,height: 77,child: pw.Center(child:  pw.Padding(padding: pw.EdgeInsets.all(5),child:pw.Center(child: pw.Text(output[i],style: pw.TextStyle(font: ttf,fontSize: fontSize,fontWeight: pw.FontWeight.normal)))))));
    }

  }
  int len = issuedByAddess.length;
  int inde = (len/30).ceil();
  final pdf = pw.Document();
  if(false) pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text("Hello World"),
        ); // Center
      }));
  if(true) pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.applyMargin(left:0, top:0, right:0, bottom:0),
      margin: pw.EdgeInsets.fromLTRB(50, 45, 50, 0),
      build: (pw.Context context) {
        return pw.Column(
            children: [
              pw.Container(
                height: 75,
                child:   pw.Stack(
                    children: [
                      pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text("Certification of Calibration",style: pw.TextStyle(font: ttfBold,fontSize: fontSize*2,fontWeight: pw.FontWeight.normal)), ),
                      pw.Align(alignment: pw.Alignment.centerRight,child:pw.Container( width: 75 ,
                          child: pw.Container(color: PdfColors.grey,height: 75,width: 75,child: pw.Image(pw.MemoryImage(
                            issuedByLogo,
                          )))
                      ), )


                    ]
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                  children: [
                    pw.TableRow(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),
                        children: [

                          pw.Container(height: 60,decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width:75,child: pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topCenter,child: pw.Text("Issued By :",style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ]),),
                          ),
                          pw.Container(height: 60,decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width:100,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child: pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topLeft,child: pw.Text(issuedBy,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ])  , ),
                          ),

                          pw.Container(height: 60,decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width:85,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topRight,child: pw.Text("Address :",style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ]) , ),
                          ),
                          pw.Container(height: 60,decoration: pw.BoxDecoration(color:PdfColors.white,border:  pw.Border.all(width: 0.3,color: PdfColors.grey)),width:inde*63,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topLeft,child: pw.Text(issuedByAddess,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ])    , ),
                          ),
                        ]
                    ),
                    pw.TableRow(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),
                        children: [
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width:75,child: pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topCenter,child: pw.Text("Telephone :",style:  pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ]) ,),
                          ),
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width:100,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.centerLeft,child:  pw.Text(issuedBytelephone,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ]), ),
                          ),
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border:  pw.Border.all(width: 0.3,color: PdfColors.grey)),width:85,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child: pw.Stack(
                            children: [
                              pw.Align(alignment: pw.Alignment.topRight,child: pw.Text(productCode,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                            ]
                          ) , ),
                          ),
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border:  pw.Border.all(width: 0.3,color: PdfColors.grey)),width:190,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(
                            children: [
                              pw.Align(alignment: pw.Alignment.topLeft,child: pw.Text(productName,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                            ]
                          )    , ),
                          ),
                        ]
                    ),
                    pw.TableRow(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),
                        children: [
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border : pw.Border.all(width: 0.3,color: PdfColors.grey)),width:75,child: pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topCenter,child: pw.Text("Serial No :",style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ]) ,),
                          ),
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border:  pw.Border.all(width: 0.3,color: PdfColors.grey)),width:100,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text(productSN,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal) ))
                          ]), ),
                          ),
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),width:85,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child:pw.Stack(
                            children: [
                              pw.Align(alignment: pw.Alignment.topRight,child: pw.Text("Certificate No :",style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)) )
                            ]
                          ) , ),
                          ),
                          pw.Container(decoration: pw.BoxDecoration(color:PdfColors.white,border:  pw.Border.all(width: 0.3,color: PdfColors.grey)),width:190,child:pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 8,horizontal: 5),child: pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.topLeft,child: pw.Text(certificateNo,style: pw.TextStyle(font: ttfBold,fontSize: fontSize,color: PdfColors.black,fontWeight: pw.FontWeight.normal)))
                          ])   , ),
                          ),









                        ]
                    )
                  ]
              ),



              pw.Padding(padding:pw.EdgeInsets.only(top: 20,bottom: 10,),child: pw.Table(
                  children: [
                    pw.TableRow(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),children:list1 ),
                    pw.TableRow(decoration: pw.BoxDecoration(color:PdfColors.white,border: pw.Border.all(width: 0.3,color: PdfColors.grey)),children:list2 ),
                  ]
              ),),
              pw.Center(child: pw.Text(procedure,style: pw.TextStyle(font: ttf,fontSize: fontSize,color: PdfColors.grey))),

              pw.Padding(padding: pw.EdgeInsets.only(top: 15,bottom: 15),child: pw.Text(condition,style: pw.TextStyle(font: ttf,fontSize: fontSize,lineSpacing: 2))),
              pw.SizedBox(height: 5),
              pw.Stack(
                  children: [
                    pw.Align(child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [

                          pw.Padding(padding: pw.EdgeInsets.fromLTRB(0,5, 0, 0),child: pw.Row(
                              children: [
                                pw.Container(width: 105,child: pw.Text("Issued To : ",style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.normal,fontSize: fontSize)),),
                                pw.Text(issuedTo,style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                              ]
                          ),),
                          pw.Padding(padding: pw.EdgeInsets.fromLTRB(0,5, 0, 0),child: pw.Row(
                              children: [
                                pw.Container(width: 105,child: pw.Text("Address : ",style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.normal,fontSize: fontSize)),),
                                pw.Text(issuedToAddress,style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                              ]
                          ),),

                          pw.Padding(padding: pw.EdgeInsets.fromLTRB(0,5, 0, 0),child: pw.Row(
                              children: [
                                pw.Container(width: 105,child: pw.Text("Telephone : ",style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.normal,fontSize: fontSize)),),
                                pw.Text(issuedTotele,style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                              ]
                          ),),
                          pw.Padding(padding: pw.EdgeInsets.fromLTRB(0,5, 0, 0),child:  pw.Row(
                              children: [
                                pw.Container(width: 105,child: pw.Text("Email : ",style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.normal,fontSize: fontSize)),),
                                pw.Text(issuedToEMail,style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                              ]
                          ),),
                          pw.SizedBox(height: 15),
                          pw.Padding(padding: pw.EdgeInsets.fromLTRB(0,5, 0, 0),child: pw.Row(
                              children: [
                                pw.Container(width: 105,child: pw.Text("Temperature : ",style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.bold,fontSize: fontSize)),),
                                pw.Text(temp,style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                              ]
                          ),),










                          pw.SizedBox(height: 15),

                          pw.Container(height: 70,width: 260,child: pw.Stack(children: [
                            pw.Align(alignment: pw.Alignment.centerLeft,child:  pw.Text("Approved Signatory",style: pw.TextStyle(font: ttf,fontSize: fontSize))),
                            pw.Align(alignment: pw.Alignment.bottomRight,child: pw.Container(margin: pw.EdgeInsets.only(bottom: 20),width: 150,height: 1,color: PdfColors.grey300)),
                            pw.Align(alignment: pw.Alignment.centerRight,child:pw.Padding(padding: pw.EdgeInsets.fromLTRB(25, 0, 0,0),child:  pw.Image(pw.MemoryImage(signatorySignature),height: 70)),),


                          ]), ),



                          pw.Text(signatoryName,style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                          pw.Text(signatoryPOsition,style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.normal,fontSize: fontSize)),
                          pw.SizedBox(height: 15),
                          pw.Row(
                              children: [
                                pw.Container(margin: pw.EdgeInsets.only(right: 15),child: pw.Text("Date",style: pw.TextStyle(font: ttfBold,fontWeight: pw.FontWeight.normal,fontSize: fontSize)),),
                                pw.Text(DateFormat("dd/MM/yyyy").format(DateTime.now()),style: pw.TextStyle(font: ttf,fontSize: fontSize)),
                              ]
                          ),

                        ]
                    )),
                    pw.Align(alignment: pw.Alignment.bottomRight, child:pw.Container(margin: pw.EdgeInsets.only(top: 70),height: 195,width: 195,color: PdfColors.white,child: pw.Image(pw.MemoryImage(
                      issuedBySeal,
                    )))),

                  ]
              ),
            ]
        ) ;// Center
      }));

  Uint8List uint8list2 =await pdf.save();
  print("PDf gen compleate");
  //String content = base64Encode(uint8list2);

  final directory = (await getExternalStorageDirectory())!.path;
  File imgFile = new File('$directory/staht.pdf');
  await  imgFile.writeAsBytes(uint8list2);

  Share.shareFiles([imgFile.path],subject: "Calibration Certificate");
  // final anchor = AnchorElement(
  //     href:
  //     "data:application/octet-stream;charset=utf-16le;base64,$content")
  //   ..setAttribute(
  //       "download",
  //       "file.pdf")
  //   ..click();// Pa
}

 generateCalibrationCirtificate(BuildContext context,double width,Uint8List logo,List  refValData,List calibAdmin,String productName,String sN,String certificateId,String calibrationStandard,String calibrationProcedure,List customerInfoArray,String approvedSignatory,String approvedSignatoryPosition) async {
  final pdf = pw.Document(deflate: zlib.encode);




  // List  calibratonCustomerData  = [];
  // calibratonCustomerData.add(["Issued To","ACME Testing Ltd"]);
  // calibratonCustomerData.add(["Address","13 Bradgate Drive Sutton Coldfield, B74 4XG, UK"]);
  // calibratonCustomerData.add(["Telephone","0121 352 1234"]);
  // calibratonCustomerData.add(["Email","acmetesting@gmail.com"]);


  // List  calibrationAuthorityInfo  = [];
  // calibrationAuthorityInfo.add(["Issued By","Staht Limited"]);
  // calibrationAuthorityInfo.add(["Address","C/O Freeths LLP, Routco Office Park Davy Avenue, Knowlhill, Milton Keynes, MK5 8HJ, UK"]);
  // calibrationAuthorityInfo.add(["Telephone","0121 352 1234"]);
  // calibrationAuthorityInfo.add(["Email","calibrations@staht.com"]);






  makeFromList(List data){
    return
      pw.Table.fromTextArray(
        border: pw.TableBorder.all(color: PdfColors.black),
        cellAlignment: pw.Alignment.center,
        headerDecoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            color: PdfColors.white
        ),
        headerHeight: 25,
        cellHeight: 25,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          // 2: pw.Alignment.center,
          // 3: pw.Alignment.center,
          // 4: pw.Alignment.center,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.black,
          fontSize: 10,
          //fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 10,
        ),
        rowDecoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColors.black,
              width: .5,
            ),
          ),
        ),

        // headers: List<String>.generate(
        //   tableHeaders.length,
        //       (col) => tableHeaders[col],
        // ),
        data: List<List<String>>.generate(
          data.length,
              (row) => List<String>.generate(
            data[row].length,
                (col) => data[row][col],
          ),
        ),
      );
  }



  pdf.addPage(pw.Page(

      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return   pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Container(
                height: 100,
                child:   pw.Stack(
                    children: [
                      pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text("Certification of Calibration",style: pw.TextStyle(fontSize: 30,fontWeight: pw.FontWeight.bold)), ),
                      pw.Align(alignment: pw.Alignment.centerRight,child:pw.Container( width: width*0.2 - 10,
                          child: pw.Image(pw.MemoryImage(logo))
                      ), )


                    ]
                ),
              ),

            // pw.Table(
            //   children: [
            //     pw.TableRow(
            //       children: [
            //         pw.Text(),
            //       ]
            //     )
            //   ]
            // ),





              pw.Row(
                  children: [
                    pw.Container(height: 200,
                        width: width*0.8,
                        child: makeFromList(calibAdmin)
                      // child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center,crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //     children: [
                      //       pw.Text("Cirtificate of Calibration",style: pw.TextStyle(fontSize: 20)),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //               child: pw.Text("Issued By",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //               child: pw.Text("Staht Limited",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             // pw.Padding(
                      //             //   padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //             //
                      //             //   child: pw.Text("Address",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             // ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //
                      //               child: pw.Text("C/O Freeths,LLP,Routco, Office Park Davy Avenue ,Kownlhill , Milton Keynes , MK5 8HJ , UK",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //
                      //               child: pw.Text("Telephone",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //
                      //               child: pw.Text("0123456789",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //
                      //               child: pw.Text("Email",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //               child: pw.Text("calibrations@staht.com",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //               child: pw.Text("600-009",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //               child: pw.Text("Digital Tensile Tester Kit",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //               child: pw.Text("Serial No",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //               child: pw.Text("ST001",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //       pw.Wrap(
                      //           children: [
                      //
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //               child: pw.Text("Cirtificate No.",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //             ),
                      //             pw.Padding(
                      //               padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      //               child: pw.Text("AA00000",style: pw.TextStyle()),
                      //             ),
                      //
                      //           ]
                      //       ),
                      //     ]
                      // ),

                    ),
                    pw.Padding(padding: pw.EdgeInsets.all(3)),

                  ]
              ),
              pw.Padding(padding: pw.EdgeInsets.all(10)),
              pw.Text("Product Name : "+productName),
              pw.Text("Serial : "+sN),
              pw.Text("Certificate No : "+certificateId),

              pw.Padding(padding: pw.EdgeInsets.all(10)),
              makeFromList(refValData),
              pw.Padding(padding: pw.EdgeInsets.all(10)),
              pw.Text(calibrationStandard),
              pw.Text(calibrationProcedure),
              pw.Padding(padding: pw.EdgeInsets.all(10)),
              pw.Wrap(
                  children: [

                    pw.Padding(
                      padding: pw.EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: pw.Text("Temparature",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.fromLTRB(10, 0, 00, 0),
                      child: pw.Text("20 °",style: pw.TextStyle()),
                    ),

                  ]
              ),
              pw.Padding(padding: pw.EdgeInsets.all(10)),
              makeFromList(customerInfoArray),

              pw.Padding(padding: pw.EdgeInsets.all(10)),
              pw.Container(width: width,
                  child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Approved Signatory ......................."),
                        pw.Text(approvedSignatory),
                        pw.Text(approvedSignatoryPosition),
                        pw.Padding(padding: pw.EdgeInsets.all(5)),
                        pw.Text("Date "+DateFormat("dd/MM/yyyy").format(DateTime.now())),

                      ]
                  )
              )


            ]
        ) ; // Center
      })); // Page
  // pdf.addPage(
  //   pw.MultiPage(
  //
  //     // build: (context) => [
  //     //   _contentTable(alldata[0]["head"],alldata[0]["body"],context),
  //     //
  //     // ],
  //
  //
  //     build: (context) =>  List<pw.Widget>.generate(
  //       alldata.length,
  //       (col) =>  _contentTable(alldata[col]["head"],alldata[col]["body"],context),
  // ),
  //   ),
  // );// Page






  // Page
  Uint8List uint8list2 =await pdf.save();
 // String content = base64Encode(uint8list2);
  final directory = (await getExternalStorageDirectory())!.path;
  File imgFile = new File('$directory/staht.pdf');
   await  imgFile.writeAsBytes(uint8list2);

  Share.shareFiles([imgFile.path],subject: "Calibration Cirtificate");

 // Share.shareFiles(['${directory.path}/yourPdf.pdf'], text: 'Your PDF!');

}

 generateInvoice(dynamic alldata,List mapPics,List allGraph,List<int> allMaxX,List<int> allMaxY,double width,List<pw.Column> allMetaData , List<List<Uint8List>>allAttachments ,List<pw.Widget> locationTables,List<pw.Widget> titles,List<pw.Widget> notes,Uint8List signature,List customerInformation,List<Uint8List> allGraphSTATIC) async {
  final pdf = pw.Document();
  final signatureImage = pw.MemoryImage(
    signature,
  );


  pdf.addPage(pw.Page(
    //  pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return    pw.Stack(
            children: [
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Column(
                    children: [
                      _contentTable(alldata[0]["head"],alldata[0]["body"],context),
                      pw.Padding(padding: pw.EdgeInsets.all(10)),
                      _customerInfoTable(customerInformation,context),
                    ]
                ),
              ),
              pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Padding(padding: pw.EdgeInsets.all(10),child: pw.Container(width: 100,height: 100,child: pw.Image(signatureImage)))
              )
            ]
        ); // Center
      })); // Page
  // pdf.addPage(
  //   pw.MultiPage(
  //
  //     // build: (context) => [
  //     //   _contentTable(alldata[0]["head"],alldata[0]["body"],context),
  //     //
  //     // ],
  //
  //
  //     build: (context) =>  List<pw.Widget>.generate(
  //       alldata.length,
  //       (col) =>  _contentTable(alldata[col]["head"],alldata[col]["body"],context),
  // ),
  //   ),
  // );// Page




  // Left curved line chart

  for(int i = 0 ; i < mapPics.length ; i ++){
    final image = pw.MemoryImage(
      mapPics[i],
    );

    final chart2 = pw.Chart(
      right: pw.ChartLegend(),
      grid: pw.CartesianGrid(

        xAxis: pw.FixedAxis([0, (allMaxY[i]).ceil()]),
        yAxis: pw.FixedAxis([ 0,(allMaxX[i]*1.1).ceil()], divisions: true,),
      ),
      datasets: [
        pw.LineDataSet(
          legend: 'Force kN',

          drawSurface: true,
          isCurved: true,
          drawPoints: false,
          color: PdfColors.blue,
          lineWidth: 1,
          data: List<pw.LineChartValue>.generate(
            allGraph[i].length,
                (j) {
              // final v = allGraph[i][j][1] as num;
              return pw.LineChartValue(j.toDouble()*100,allGraph[i][j][1]);
            },
          ),
        ),
      ],
    );


    pdf.addPage(pw.Page(build: (pw.Context context) {

      return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // pw.Text("Title"),
            // titles[i],
            // pw.Text("Note"),
            // notes[i],

            pw.Padding(padding: pw.EdgeInsets.all(10),child: pw.Container(width:width ,height: 200,child: pw.Center(
              child:pw.Image(pw.MemoryImage(allGraphSTATIC[i])),
            )), ),
            // pw.Padding(padding: pw.EdgeInsets.all(10),child: pw.Container(width:width ,height: 100,child: pw.Center(
            //   child:chart2,
            // )), ),
            pw.Padding(padding: pw.EdgeInsets.all(10),child: pw.Container(width:width ,child: pw.Center(
              child:allMetaData[i],
            )), ),
            //show attachment grid
            generateWIdgets(allAttachments[i]),


            pw.Padding(padding: pw.EdgeInsets.all(10),child: pw.Container(width: width,child: pw.Center(
              child: pw.Image(image),
            )), ),
            pw.Padding(padding: pw.EdgeInsets.all(3),child: pw.Container(width: width,child: pw.Center(
              child: locationTables[i],
            )), ),


          ]
      );
      return pw.Center(
        child: pw.Image(image),
      ); // Center
    }));
  }

  // Page
  Uint8List uint8list2 =await pdf.save();
  String content = base64Encode(uint8list2);

}

pw.Widget generateWIdgets(List<Uint8List> allAttachment) {
  List<pw.Widget> images = [];

  for(int i = 0 ; i < allAttachment.length ; i++) {
    if (allAttachment[i].length > 0){
      images.add(pw.Padding(padding: pw.EdgeInsets.all(2),child: pw.Container(height: 100,width:100,child: pw.Image(pw.MemoryImage(
        allAttachment[i],
      )))));
    }else{
      images.add(pw.Text("No attachments"));
    }
  }

  return pw.Wrap(
      children: images
  );

}
pw.Widget _customerInfoTable(List customerInformation,pw.Context context) {
  List medataBody = [];
  medataBody.add(["Date","6 aug"]);
  medataBody.add(["Name","Mukul"]);


  return pw.Table.fromTextArray(
    border: pw.TableBorder.all(color: PdfColors.black),
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.white
    ),
    headerHeight: 25,
    cellHeight: 25,
    cellAlignments: {
      0: pw.Alignment.center,
      1: pw.Alignment.center,
      // 2: pw.Alignment.center,
      // 3: pw.Alignment.center,
      // 4: pw.Alignment.center,
    },
    headerStyle: pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
      //fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
    ),
    rowDecoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: PdfColors.black,
          width: .5,
        ),
      ),
    ),

    // headers: List<String>.generate(
    //   tableHeaders.length,
    //       (col) => tableHeaders[col],
    // ),
    data: List<List<String>>.generate(
      customerInformation.length,
          (row) => List<String>.generate(
        2,
            (col) => customerInformation[row][col],
      ),
    ),
  );
}
pw.Widget _contentTable(List tableHeaders,List medataBody,pw.Context context) {


  return pw.Table.fromTextArray(
    border: pw.TableBorder.all(color: PdfColors.black),
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.black
    ),
    headerHeight: 25,
    cellHeight: 25,
    cellAlignments: {
      0: pw.Alignment.center,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.center,
    },
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
    ),
    rowDecoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: PdfColors.black,
          width: .5,
        ),
      ),
    ),

    headers: List<String>.generate(
      tableHeaders.length,
          (col) => tableHeaders[col],
    ),
    data: List<List<String>>.generate(
      medataBody.length,
          (row) => List<String>.generate(
        tableHeaders.length,
            (col) => medataBody[row][col],
      ),
    ),
  );
}
class Invoice {
  Invoice({
    required this.products,
    required  this.customerName,
    required  this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

 late final List<Product> products;
  late  String customerName;
  late String customerAddress;
  late String invoiceNumber;
  late double tax;
  late String paymentInfo;
  late PdfColor baseColor;
  late PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  late String _logo;

  late String _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/stahtlogogreen.jpg');
    _bgShape = await rootBundle.loadString('assets/stahtlogogreen.jpg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(invoiceNumber),
                          pw.Text('Date:'),
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child:
                    _logo != null ? pw.SvgImage(svg: _logo) : pw.PdfLogo(),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${_formatCurrency(_grandTotal)}',
                style: pw.TextStyle(
                  color: baseColor,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: '$customerName\n',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            const pw.TextSpan(
                              text: '\n',
                              style: pw.TextStyle(
                                fontSize: 5,
                              ),
                            ),
                            pw.TextSpan(
                              text: customerAddress,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                paymentInfo,
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(_total)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'SKU#',
      'Item Description',
      'Price',
      'Quantity',
      'Total'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

class Product {
  const Product(
      this.sku,
      this.productName,
      this.price,
      this.quantity,
      );

  final String sku;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return _formatCurrency(total);
    }
    return '';
  }
}