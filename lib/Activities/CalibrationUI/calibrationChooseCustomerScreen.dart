import 'package:connect/Appabr/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/Activities/CalibrationUI/calibrationSelectProductScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';


class CalibrationChooseCustomerScreen extends StatefulWidget {


  @override
  _CalibrationChooseCustomerScreenState createState() => _CalibrationChooseCustomerScreenState();
}

class _CalibrationChooseCustomerScreenState extends State<CalibrationChooseCustomerScreen> {

  //--------------- Json ---------------------


  dynamic customerData=[
    {
      'customerName':'Matt',
      'customerValue':'1234455',
    },
    {
      'customerName':'Rob',
      'customerValue':'1234455',
    },
    {
      'customerName':'Dan',
      'customerValue':'1234455',
    },
    {
      'customerName':'Jane',
      'customerValue':'1234455',
    },
    {
      'customerName':'John',
      'customerValue':'1234455',
    },

  ];


  int? isSelected =0;


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(color: Colors.white,child:SafeArea(child: Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
          Container(
            margin: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              top: height * 0.03,
            ),
            child:
            Column(
              children: [

                //----------------Back arrow ------------------------
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios,
                        size: width * 0.039,color:  ThemeManager().getDarkGreenColor,),
                      Text(TextConst.backText,style: interMedium.copyWith(
                          color: ThemeManager().getDarkGreenColor,
                          fontSize: width * 0.042),
                      ),
                    ],
                  ),
                ),

                //-----------------Choose customer text-----------
                Container(
                  margin: EdgeInsets.only(top:height*0.03,),
                  alignment: Alignment.topLeft,
                  child: Text(
                    TextConst.chooseCustomerText,
                    style: interSemiBold.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.042),
                  ),
                ),

                //-----------------------Search TextField-------------------------
                Container(
                  margin: EdgeInsets.only(top:height*0.03,bottom: height*0.017),
                  height: height * 0.05,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18))
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Image.asset("assets/icons/searchIcon.png"),
                      hintText: TextConst.searchText,
                      hintStyle: interMedium.copyWith(
                        color: ThemeManager().getLightGrey1Color,
                        fontSize: width * 0.039,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: height * 0.0, horizontal: width * 0.045),
                      fillColor: ThemeManager().getLightGreenTextFieldColor,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: customerDetail(),
          ),

          //---------------- Save Button -----------------------------
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalibrationSelectProductScreen()));
            },
            child: Container(
                margin: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
                    bottom: height * 0.03),
                height: height*0.065,
                width: width,
                child: ButtonView(buttonLabel: TextConst.saveButtonText)
            ),
          ),

        ],
      ),
    ),) );


  }


  //---------------------- Choose Customer Data ----------------------
  Widget customerDetail(){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: customerData.length,
      itemBuilder: (BuildContext context, int index) {
        return  GestureDetector(
          onTap: (){
            setState(() {
              isSelected=index;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(

                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: height *0.035),
                    height: height * 0.04,
                    width: width * 0.05,
                    child: Center(
                        child:  Icon(Icons.check,
                          color: isSelected==index
                              ? ThemeManager().getWhiteColor
                              : Colors.transparent,
                          size: width * 0.04,)
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected==index
                          ? ThemeManager().getDarkGreenColor
                          : ThemeManager().getDarkGrey2Color,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width*0.03,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customerData[index]['customerName'],
                          style: interMedium.copyWith(
                              color: ThemeManager().getExtraDarkBlueColor,
                              fontSize: width * 0.042),),
                        Text(customerData[index]['customerValue'],
                          style: interRegular.copyWith(
                              color: ThemeManager().getLightGrey5Color,
                              fontSize: width * 0.031),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: height *0.01,bottom: height * 0.01),
                height: height*0.001,
                width: double.infinity,
                color: ThemeManager().getBlackColor.withOpacity(0.10),
              ),
            ],
          ),
        );
      },
    );
  }





}

