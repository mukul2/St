
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/screens/viewTestsScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';



class TestSelectFolderScreen extends StatefulWidget {
  const TestSelectFolderScreen({Key ?key}) : super(key: key);

  @override
  _TestSelectFolderScreenState createState() => _TestSelectFolderScreenState();
}
class MyTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height),
      Offset(0, 0),
      Offset(size.width, size.height/2)
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _TestSelectFolderScreenState extends State<TestSelectFolderScreen> {

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
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      body: SingleChildScrollView(

        child: Container(

          child: Column(
            children: [

              //-------------------------screen appbar-------------------
              AppBarCustom(appbarTitle:"Test",),

              //-------------------------body of screen------------------
              Container(
                margin: EdgeInsets.only(left: width*0.05,right: width*0.05,top: height*0.025),
                child: Column(
                  children: [

                    //-----------------Test finished view-----------
                    testFinish(),

                    //-----------------Test result view------------
                    testResultPass(),

                    //----------------Title---------------
                    Container(
                      margin: EdgeInsets.only(top: height*0.02),
                      alignment: Alignment.topLeft,
                      child:Text(
                          "Title",style: interMedium.copyWith(
                          color: ThemeManager().getPopUpTextGreyColor,
                          fontSize: width * 0.042)
                      ),
                    ),

                    //--------------Title text field-----------
                    Container(
                      margin: EdgeInsets.only(top: height * 0.015),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "25-June 2021 9:46",
                          hintStyle: interMedium.copyWith(
                            color: ThemeManager().getLightGrey1Color,
                            fontSize: width * 0.040,),
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(width * 0.014)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: height * 0.0, horizontal: width * 0.045),
                          fillColor: ThemeManager().getLightGreenTextFieldColor,
                          filled: true,
                        ),
                      ),
                    ),

                    //-----------------Notes----------------
                    Container(
                      margin: EdgeInsets.only(top: height*0.02),
                      alignment: Alignment.topLeft,
                      child:Text(
                          "Notes",style: interMedium.copyWith(
                          color: ThemeManager().getPopUpTextGreyColor,
                          fontSize: width * 0.042)
                      ),
                    ),

                    //-----------------Notes text field---------
                    Container(
                      margin: EdgeInsets.only(top: height * 0.015),
                      child: TextField(
                        maxLines: 7,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintStyle: interMedium.copyWith(
                            color: ThemeManager().getLightGrey1Color,
                            fontSize: width * 0.040,),
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(width * 0.014)),
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

              //--------------------------Test result data value-----------------------
              testResultData(TextConst.peakLoadText,"7.4 kN at 00:12"),
              testResultData(TextConst.timedSectionStartedText,"00:14"),
              testResultData(TextConst.timedSectionFinishedText,"00:24"),
              Container(
                margin: EdgeInsets.only(top: height*0.025),
                color:ThemeManager().getBlackColor.withOpacity(.15),
                height: height*0.001,
                width: double.infinity,
              ),

              //-------------------------Select Folder button-------------------------------
              selectFolderButton(),
            ],
          ),

        ),
      ),
    );
  }

  //-------------------------------------test finish view----------------------
  Widget testFinish(){
    return Container(
        child:Row(
          children: [
            Container(
              decoration: new BoxDecoration(
                color:ThemeManager().getDarkGreenColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius:5,
                    color:ThemeManager().getDarkGreenColor,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              height: height*0.065,
              width: width*0.85 ,

              child: Text(
                  "Test Finished",style: interMedium.copyWith(
                  color: ThemeManager().getWhiteColor,
                  fontSize: width * 0.040)
              ),
            ),
            ClipPath(
              clipper: MyTriangle(),
              child:   Container(
                decoration: BoxDecoration(
                  color: ThemeManager().getDarkGreenColor
                ),
                width: width*0.05,
                height:height*0.03,
              ),
            ),

          ],
        )
    );
  }

  //--------------------------------test result pass view---------------------
  Widget testResultPass(){
    return   Container(
      margin: EdgeInsets.only(top: height*0.02),
      decoration: new BoxDecoration(
        color:ThemeManager().getLightGreenColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      height: height*0.065,
      width: width*0.9,

      child: Text(
          "Test Result Pass",style: interMedium.copyWith(
          color: ThemeManager().getDarkGreenColor,
          fontSize: width * 0.042)
      ),
    );
  }

  //-------------------------Select Folder button-------------------------------
  Widget selectFolderButton(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewTestsScreen()));
      },
      child: Container(
        margin: EdgeInsets.only(top: height*0.02,bottom: height*0.03),
        decoration: new BoxDecoration(
          color:ThemeManager().getDarkGreenColor,
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        height: height*0.065,
        width: width*0.9,
        child: Text(
            TextConst.selectFolderText,style: interMedium.copyWith(
            color: ThemeManager().getWhiteColor,
            fontSize: width * 0.042)
        ),
      ),
    );
  }

  //--------------------------Test result data value-----------------------
  Widget testResultData(dataTitle, dataResult){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: height*0.018),
          color:ThemeManager().getBlackColor.withOpacity(.15),
          height: height*0.001,
          width: double.infinity,
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.018,left: width*0.06),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child:Text(
                    dataTitle,style: interMedium.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.043)
                ),
              ),
              Container(
                child:Text(
                    dataResult,style: interMedium.copyWith(
                    color: ThemeManager().getDarkGreenColor,
                    fontSize: width * 0.043)
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
