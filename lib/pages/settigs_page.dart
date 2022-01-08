import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/localization/language/languages.dart';
import 'package:connect/localization/locale_constant.dart';
import 'package:connect/model/language_data.dart';
import 'package:connect/screens/home.dart';

class SettingsActivity extends StatefulWidget {


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsActivity> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(title: Text("Settings"),),body: SingleChildScrollView(
        child: Column(
        children: [
         //  ListTile(onTap: (){
         //   // showDialog(context: context, builder: (_) => ThemeDialog());
         //    controller.currentThemeId == 'dark'?controller.setTheme('light'):controller.setTheme('dark');
         //  },leading: Icon(Icons.brightness_6),trailing: Checkbox(
         //    value:controller.currentThemeId == 'dark'?true:false, onChanged: (bool? value) {  } ,
         //  ),title: Text("Theme"),subtitle: Text("Dark Theme"),),
         //  ListTile(onTap: (){
         //   // showDialog(context: context, builder: (_) => ThemeDialog());
         //    Navigator.push(
         //      context,
         //      MaterialPageRoute(builder: (context) => SettingsPage()),
         //    );
         //  },leading: Icon(Icons.system_update),trailing: Icon(Icons.arrow_right),title: Text("Firmware Update"),subtitle: Text("Check for updates"),),
         // ListTile(onTap: (){
         //   // showDialog(context: context, builder: (_) => ThemeDialog());
         //    Navigator.push(
         //      context,
         //      MaterialPageRoute(builder: (context) => SettingsPage()),
         //    );
         //  },leading: Icon(Icons.language),trailing: Icon(Icons.arrow_right),title: DropdownButton<LanguageData>(
         //   iconSize: 30,
         //   hint: Text("Change Language"),
         //   onChanged: (val) async {
         //    // print(val.languageCode);
         //     //var _locale = await setLocale(val!.languageCode);
         //     //setLocale(_locale);
         //
         //     // setLocale(val.languageCode);
         //     if(val!=null &&val.languageCode!=null){
         //       changeLanguage(context, val.languageCode);
         //     }else{
         //       changeLanguage(context, "en");
         //
         //     }
         //
         //
         //   },
         //   // onChanged: (LanguageData language) {
         //   //   changeLanguage(context, language.languageCode);
         //   // },
         //   items: LanguageData.languageList()
         //       .map<DropdownMenuItem<LanguageData>>(
         //         (e) =>
         //         DropdownMenuItem<LanguageData>(
         //           value: e,
         //           child: Row(
         //             mainAxisAlignment: MainAxisAlignment.spaceAround,
         //             children: <Widget>[
         //               Text(
         //                 e.flag,
         //                 style: TextStyle(fontSize: 30),
         //               ),
         //               Text(e.name)
         //             ],
         //           ),
         //         ),
         //   )
         //       .toList(),
         // ),subtitle: Text("Language"),),
          ListTile(leading: Icon(Icons.logout),onTap: (){
            //calibrate
            Navigator.pop(context);
          },title: Text("Calibrate as Admin"),),
        ListTile(leading: Icon(Icons.logout),onTap: (){
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },title: Text("Logout"),),

      ],
    ),
    ),);
  }
}
