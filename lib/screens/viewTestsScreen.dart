import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/screens/viewTestAllFolderTabScreen.dart';
import 'package:connect/screens/viewTestByMapTabScreen.dart';
import 'package:connect/screens/viewTestLast30DaysTabScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class ViewTestsScreen extends StatefulWidget {
  const ViewTestsScreen({Key? key}) : super(key: key);

  @override
  _ViewTestsScreenState createState() => _ViewTestsScreenState();
}

class _ViewTestsScreenState extends State<ViewTestsScreen> {

  int selectedTabIndex = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,
      body: Column(
        children: [
          //-------------------------Appbar view----------------------------
          AppBarCustom(appbarTitle: TextConst.viewTestsAppbarText,),

          //------------------------TextField and TabBar view--------------
          Container(
            margin: EdgeInsets.only(
                top: height * 0.025, left: width * 0.05, right: width * 0.05),
            child: Column(
              children: [
                //--------------------Search TextField-------------------
                Container(
                  height: height * 0.045,
                  width: width,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset("assets/icons/searchIcon.png"),
                      hintText: TextConst.searchText,
                      hintStyle: interMedium.copyWith(
                          fontSize: width * 0.035,
                          color: ThemeManager().getLightGrey1Color),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(width * 0.014)),
                      focusedBorder: OutlineInputBorder(
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

                //--------------------TabBar view------------------------
                Container(
                  margin: EdgeInsets.only(top: height * 0.025),

                  //-------------------TabBar view--------------------
                  child: tabBarView(),
                ),
              ],
            ),
          ),

          //-----------------------TabBar item body---------------------
          Expanded(
            child: Container(
                margin: EdgeInsets.only(top: height * 0.02),

                //-------------------Last 30 days Tab-1 body view--------------------
                child: selectedTabIndex == 0
                    ? ViewTestLast30DaysTabScreen()

                //-------------------All view tests folder Tab-2 body view-------------------
                    : selectedTabIndex == 1
                    ? ViewTestAllFolderTabScreen()

                //------------------By map Tab-3 body view-------------------------
                    : ViewTestByMapScreen()
            ),
          ),
        ],
      ),
    );
  }

  //---------------------TabBar View----------------------------
  Widget tabBarView() {
    return DefaultTabController(
      length: 3,
      initialIndex: selectedTabIndex,

      child: Column(
        children: [
          Container(
            height: height * 0.055,
            decoration: BoxDecoration(
              border: Border.all(
                  color: ThemeManager().getLightGrey1Color, width: 0.1),
              boxShadow: [
                BoxShadow(
                  color: ThemeManager().getDarkGreenColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 7,
                  //offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),

            child: Material(
              color: ThemeManager().getWhiteColor,
              borderRadius: BorderRadius.circular(10),

              child: TabBar(
                  onTap: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  labelColor: ThemeManager().getWhiteColor,
                  unselectedLabelColor: ThemeManager().getBlackColor,
                  indicator: BoxDecoration(
                      color: ThemeManager().getDarkGreenColor,
                      borderRadius: selectedTabIndex == 0
                          ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))
                          : selectedTabIndex == 2
                          ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))
                          : BorderRadius.zero),
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  labelStyle: interMedium.copyWith(fontSize: width * 0.038),
                  tabs: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            TextConst.last30DaysTabBarText,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            TextConst.allTabBarText,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          TextConst.byMapTabBarText,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

}
