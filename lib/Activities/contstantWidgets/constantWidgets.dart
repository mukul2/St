import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';

import '../../DarkThemeManager.dart';

class ConstantWidget{
  Widget notData(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Icon(Icons.error,color: AppThemeManager().getPrimaryVsDarkTextColor(),size: 60,)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("No records available",style: TextStyle(color: AppThemeManager().getPrimaryVsDarkTextColor(),fontSize: 20,fontWeight: FontWeight.bold),),
          ),
        )
      ],
    );
  }
  Widget notDeviceConnected(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Icon(Icons.bluetooth_disabled_rounded,color: ThemeManager().getRedColor,size: 60,)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("No device connected !!",style: TextStyle(color:  AppThemeManager().getTextColor1(),fontSize: 20,fontWeight: FontWeight.bold),),
          ),
        )
      ],
    );
  }
  Widget notFolders(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Icon(Icons.folder,color: AppThemeManager().getPrimaryVsDarkTextColor(),size: 60,)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("No Folders available",style: TextStyle(color: AppThemeManager().getPrimaryVsDarkTextColor(),fontSize: 20,fontWeight: FontWeight.bold),),
          ),
        )
      ],
    );
  }
}