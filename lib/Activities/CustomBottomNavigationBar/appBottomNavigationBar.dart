import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/DarkThemeManager.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBottomNavigationar{
   BuildContext context;
  AppBottomNavigationar({required this.context});
 Widget getNavigationBar({required int level}){
   double heSa = 0.08;
  return Container(
     //   decoration:BoxDecoration(
     //   border: Border(
     //     top: BorderSide(width: double.infinity, color: ThemeManager().getBlackColor.withOpacity(.15),),
     //
     //   ),
     //   color: Colors.white,
     // ),
     color:AppThemeManager().getBottomNavColor(),width: width, height: height*heSa,
     //CustomerHomePageLogic().tabChangedStream.outData
     child: StreamBuilder<int>(
         stream: CustomerHomePageLogic().tabChangedStream.outData,
         builder: (c, snapshot) {
           if(snapshot.hasData){
             currentTab = snapshot.data!;

             return  Column(
               children: [
                 Container(
                   //margin: EdgeInsets.only(top: height*0.008),
                   height: height*0.001,
                   width: double.infinity,
                   color: ThemeManager().getBlackColor.withOpacity(.15),
                 ),
                 Container(height:  (height * heSa)- height*0.001,
                   child: Center(
                     child: Row(children:[
                       Expanded(
                         child: InkWell(
                           onTap: (){
                             Navigator.of(context).popUntil((route) => route.isFirst);
                             if(level>0){
                               for(int i = 0 ; i < level ; i++){
                                 Navigator.pop(context);
                               }
                             }
                             CustomerHomePageLogic().tabChangedStream.dataReload(0);
                           },
                           child: Center(child: Container(
                               padding: EdgeInsets.only(right: width * 0.06),
                               child: SvgPicture.asset(
                                 "assets/svg/homeIcon.svg",
                                 color:snapshot.data==0? ThemeManager().getRedColor:AppThemeManager().getBottomNavIconDeactive(),
                                 width: width * 0.028,
                                 height: width * 0.06,
                               )),),
                         ),
                       ),
                       Expanded(
                         child: InkWell(
                           onTap: (){
                             Navigator.of(context).popUntil((route) => route.isFirst);
                             if(level>0){
                               for(int i = 0 ; i < level ; i++){
                                 Navigator.pop(context);
                               }
                             }
                             CustomerHomePageLogic().tabChangedStream.dataReload(1);
                           },
                           child: Center(child: Container(
                               padding: EdgeInsets.only(right: width * 0.06),
                               child: SvgPicture.asset(
                                 "assets/svg/strokeIcon.svg",
                                 color:snapshot.data==1? ThemeManager().getRedColor: AppThemeManager().getBottomNavIconDeactive(),
                                 width: width * 0.028,
                                 height: width * 0.06,
                               )),),
                         ),
                       ),
                       Expanded(
                         child: InkWell(
                           onTap: (){
                             Navigator.of(context).popUntil((route) => route.isFirst);
                             if(level>0){
                               for(int i = 0 ; i < level ; i++){
                                 Navigator.pop(context);
                               }
                             }
                             CustomerHomePageLogic().tabChangedStream.dataReload(2);
                           },
                           child: Center(child: Container(
                               padding: EdgeInsets.only(right: width * 0.06),
                               child: SvgPicture.asset(
                                 "assets/svg/chartIcon.svg",
                                 color:snapshot.data==2? ThemeManager().getRedColor: AppThemeManager().getBottomNavIconDeactive(),
                                 width: width * 0.028,
                                 height: width * 0.06,
                               )),),
                         ),
                       ),
                       Expanded(
                         child: InkWell(
                           onTap: (){
                             Navigator.of(context).popUntil((route) => route.isFirst);
                             if(level>0){
                               for(int i = 0 ; i < level ; i++){
                                 Navigator.pop(context);
                               }
                             }
                             CustomerHomePageLogic().tabChangedStream.dataReload(3);
                           },
                           child: Center(child: Container(
                               padding: EdgeInsets.only(right: width * 0.06),
                               child: SvgPicture.asset(
                                 "assets/svg/vectorIcon.svg",
                                 color:snapshot.data==3? ThemeManager().getRedColor: AppThemeManager().getBottomNavIconDeactive(),
                                 width: width * 0.028,
                                 height: width * 0.06,
                               )),),
                         ),
                       ),
                     ],),
                   ),
                 ),

               ],
             );

           }else{
             return Column(
               children: [
                 Container(
                   //margin: EdgeInsets.only(top: height*0.008),
                   height: height*0.001,
                   width: double.infinity,
                   color: ThemeManager().getBlackColor.withOpacity(.15),
                 ),
                 Container(height:  (height * heSa)- height*0.001,
                   child: Center(
                     child: Row(children:[
                       Expanded(child: InkWell(onTap: (){
                         Navigator.of(context).popUntil((route) => route.isFirst);
                         if(level>0){
                           for(int i = 0 ; i < level ; i++){
                             Navigator.pop(context);
                           }
                         }
                         CustomerHomePageLogic().tabChangedStream.dataReload(0);
                       },
                         child: Center(child: Container(
                             padding: EdgeInsets.only(right: width * 0.06),
                             child: SvgPicture.asset(
                               "assets/svg/homeIcon.svg",
                               color: ThemeManager().getRedColor,
                               width: width * 0.028,
                               height: width * 0.06,
                             )),),

                       )),
                       Expanded(child: InkWell(onTap: (){
                         Navigator.of(context).popUntil((route) => route.isFirst);
                         if(level>0){
                           for(int i = 0 ; i < level ; i++){
                             Navigator.pop(context);
                           }
                         }
                         CustomerHomePageLogic().tabChangedStream.dataReload(1);
                       },
                         child: Center(child: Container(
                             padding: EdgeInsets.only(right: width * 0.06),
                             child: SvgPicture.asset(
                               "assets/svg/strokeIcon.svg",
                               color: AppThemeManager().getBottomNavIconDeactive(),
                               width: width * 0.028,
                               height: width * 0.06,
                             )),),
                       )),
                       Expanded(child: InkWell(onTap: (){
                         Navigator.of(context).popUntil((route) => route.isFirst);
                         if(level>0){
                           for(int i = 0 ; i < level ; i++){
                             Navigator.pop(context);
                           }
                         }
                         CustomerHomePageLogic().tabChangedStream.dataReload(2);
                       },
                         child: Center(child: Container(
                             padding: EdgeInsets.only(right: width * 0.06),
                             child: SvgPicture.asset(
                               "assets/svg/chartIcon.svg",
                               color: AppThemeManager().getBottomNavIconDeactive(),
                               width: width * 0.028,
                               height: width * 0.06,
                             )),),
                       )),
                       Expanded(child: InkWell(onTap: (){
                         Navigator.of(context).popUntil((route) => route.isFirst);
                         if(level>0){
                           for(int i = 0 ; i < level ; i++){
                             Navigator.pop(context);
                           }
                         }
                         CustomerHomePageLogic().tabChangedStream.dataReload(3);
                       },
                         child: Center(child: Container(
                             padding: EdgeInsets.only(right: width * 0.06),
                             child: SvgPicture.asset(
                               "assets/svg/vectorIcon.svg",
                               color: AppThemeManager().getBottomNavIconDeactive(),
                               width: width * 0.028,
                               height: width * 0.06,
                             )),),
                       )),
                     ],),
                   ),
                 ),
               ],
             );

           }



         }),


   );
  }
}