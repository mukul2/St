import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Calculators {

  String durationToString(int miliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    int minute = dateTime.minute;
    int second = dateTime.second;
    int mili = dateTime.millisecond;
    //return dateTime.toIso8601String();

    //return dateTime.toString().split('.')[1];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('mm:ss').format(dateTime);
    return formattedDate;

    return minute.toString() + " : " + second.toString();
    return (minute < 10 ? "" + minute.toString() : "" + minute.toString()) +
        " : " +
        (second < 10 ? "0" + second.toString() : "" + second.toString());
  }

}



