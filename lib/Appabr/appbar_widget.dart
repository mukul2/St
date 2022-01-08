import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:flutter/material.dart';

class ApplicationAppbar{

  getAppbar({required String title}){
    return   Container(
        child: AppbarView(
          appbarTitleText: title,
        )
    );
  }

}