import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/Activities/CalibrationUI/calibrationInputRefValueAddAndCalculateRawValueScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

import 'calibrationInputRefValueAddAndCalculateRawValueScreen.dart';

class CalibrationSelectProductScreen extends StatefulWidget {
  @override
  _CalibrationSelectProductScreenState createState() =>
      _CalibrationSelectProductScreenState();
}

class _CalibrationSelectProductScreenState
    extends State<CalibrationSelectProductScreen> {

  //------------- Product List -----------------------
  List<String> productList = [
    '60 kN Tester',
    'Temperature Sensor',
    'Air Flow Sensor',
  ];

  var product = "60 kN Tester ";
  bool isCollapsed=false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //-------------App Bar of screen---------------------------
      appBar: PreferredSize(
        preferredSize: Size(0,kToolbarHeight),
        child:  ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
      ),

      //--------------------Body of screen------------------
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

               Container(
                 margin: EdgeInsets.only(
                   left: width * 0.05,
                   right: width * 0.05,
                   top: height * 0.03,
                 ),

                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,

                   children: [

                     //----------------Back arrow button-----------
                     InkWell(
                       onTap: (){
                         Navigator.pop(context);
                       },
                       child: Row(
                         children: [
                           Icon(
                             Icons.arrow_back_ios,
                             size: width * 0.039,
                             color: ThemeManager().getDarkGreenColor,
                           ),
                           Text(
                             TextConst.backText,
                             style: interMedium.copyWith(
                                 color: ThemeManager().getDarkGreenColor,
                                 fontSize: width * 0.042),
                           ),
                         ],
                       ),
                     ),

                     //--------------Select product title----------------
                     Container(
                       margin: EdgeInsets.only(top: height * 0.03,),

                       child: Text(
                         TextConst.selectProductText,
                         style: interMedium.copyWith(
                             color: ThemeManager().getPopUpTextGreyColor,
                             fontSize: width * 0.040),
                       ),
                     ),

                     //----------------- Select Product Dropdown-----------------
                     selectProductDetail(),

                     //-------------- Save Button ----------------------
                     GestureDetector(
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                              builder: (context) =>
                                  CalibrationInputRefValueAddAndCalculateRawValueScreen(
                                    showInputRefValScreen: false,
                                  )));
                    },
                       child: Container(
                         margin: EdgeInsets.only(
                           top: height * 0.1,
                         ),
                         height: height * 0.065,
                         width: width,
                         child: ButtonView(buttonLabel: TextConst.saveButtonText)
                       ),
                     ),
                   ],
                 ),
               ),
          ],
        ),
      ),
    );
  }

//------------------------- Select Product Dropdown----------------
  Widget selectProductDetail()
  {
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
          title: Text(
            product,
            style: interMedium.copyWith(
                color: ThemeManager().getLightGrey1Color,
                fontSize: width * 0.042),
          ),

          //----------------Available Product List in dropdown------------
          children: <Widget>[
            for (var productItem in productList)
              InkWell(
                onTap: () {
                  setState(() {
                    this.product = productItem;
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
                        child: Text( productItem,
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
  }

}
