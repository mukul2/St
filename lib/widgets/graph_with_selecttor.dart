/// Package imports
import 'dart:math';
import 'dart:ui';

import 'package:connect/DarkThemeManager.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' as prefix0;

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports

///Renders line series with point color mapping
///
///
///
class LineMultiColor extends StatefulWidget {
  ///Renders line series with point color mapping
  List data;

  double max;
  double target;
  int startedLoad;
  int duration;
  int endedLoad;
  int fullDuration;
  bool didPassed;
  String unit;
  int prefferedDecimalPlace;
  List<dynamic> imageAndTime = [];
  LineMultiColor(
      {required this.data,
        required this.max,
        required this.prefferedDecimalPlace,
        required  this.target,
        required this.startedLoad,
        required this.duration,
        required  this.endedLoad,
        required  this.unit,
        required  this.fullDuration,
        required this.didPassed});

  @override
  _LineMultiColorState createState() => _LineMultiColorState();
}

class _LineMultiColorState extends State<LineMultiColor> {
  _LineMultiColorState();

  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {


    AttachmentsAddedListener.getInstance().outData.listen((event) {
      setState(() {
        widget.imageAndTime = event;
        print("attach size "+ event.length.toString());
        print(event);
      });
    });

    // imageAndTime.add({
    //   "wid": Text("Image one"),
    //   "time": 2000,
    // });
    // imageAndTime.add({
    //   "wid": Text("Image two"),
    //   "time": 8000,
    // });
    // imageAndTime.add({
    //   "wid": Text("Image three"),
    //   "time": 12000,
    // });

    Widget trackWidget  ;
    if(widget.unit == "kN"){
      _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        builder: (BuildContext context, TrackballDetails trackballDetails) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 8, 22, 0.75),
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //  child: durationToString(trackballDetails.point.x.millisecondsSinceEpoch),
              child:checkAndShowPic(trackballDetails.point!.x.millisecondsSinceEpoch,widget. imageAndTime, Text(
                  ((trackballDetails.point!.y).toStringAsFixed(widget.prefferedDecimalPlace)).toString()+" " +widget.unit+
                      "\n" +
                      durationToString(
                          trackballDetails.point!.x.millisecondsSinceEpoch)
                  //+ "\n"
                  ,
                  // '${trackballDetails.point.x.toString()} : \$${double.parse(trackballDetails.point.y).toStringAsFixed(1)}',
                  style: TextStyle(
                      fontSize: 10, color: Color.fromRGBO(255, 255, 255, 1)))),
            ),
          );
        },
      );
    }else{
      _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        builder: (BuildContext context, TrackballDetails trackballDetails) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 8, 22, 0.75),
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //  child: durationToString(trackballDetails.point.x.millisecondsSinceEpoch),
              child:checkAndShowPic(trackballDetails.point!.x.millisecondsSinceEpoch,widget. imageAndTime, Text(
                  ((trackballDetails.point!.y).toInt()).toString()+" " +widget.unit+
                      "\n" +
                      durationToString(
                          trackballDetails.point!.x.millisecondsSinceEpoch)
                  //+ "\n"
                  ,
                  // '${trackballDetails.point.x.toString()} : \$${double.parse(trackballDetails.point.y).toStringAsFixed(1)}',
                  style: TextStyle(
                      fontSize: 10, color: Color.fromRGBO(255, 255, 255, 1)))),
            ),
          );
        },
      );
    }


    // DateTime.now().millisecondsSinceEpoch
    // _trackballBehavior = TrackballBehavior(
    //     enable: true,
    //     activationMode: ActivationMode.singleTap,
    //     lineType: TrackballLineType.vertical,
    //     tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiColorLineChart();
    return Wrap(children: [
      Container(height: MediaQuery.of(context).size.height-30,child: _buildMultiColorLineChart()),
      Container(height: 30,
        child: Wrap(
          children: [
            Expanded(
              child: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(height: 20,width: 20,color: ThemeManager().getDarkGreenColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(child: Text("Load")),
                  ),
                ],),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(height: 20,width: 20,color: Colors.greenAccent,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(child: Text("T St")),
                  ),
                ],),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(height: 20,width: 20,color: Colors.redAccent,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(child: Text("T End")),
                  ),
                ],),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(height: 20,width: 20,color: Colors.black,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(child: Text("Target")),
                  ),
                ],),
              ),
            ),
          ],
        ),
      ),
    ],);
    return _buildMultiColorLineChart();
  }

  ///Get the chart with multi colored line series
  SfCartesianChart _buildMultiColorLineChart() {
    return SfCartesianChart(backgroundColor: AppThemeManager().getGraphBackgroundColor(),
      plotAreaBorderWidth: 2,
      primaryXAxis: DateTimeAxis(
          title: AxisTitle(text: "Minute : Seconds ",textStyle: TextStyle(color: AppThemeManager().getGraphTextColor())),
          plotBands: <PlotBand>[
            PlotBand(
              isVisible: true,
              start: DateTime.fromMillisecondsSinceEpoch(widget.startedLoad),
              end: DateTime.fromMillisecondsSinceEpoch(widget.startedLoad),
              dashArray: <double>[7, 3, 7, 3],
              borderWidth: 3,

              borderColor: Colors.greenAccent,
            ),
            PlotBand(
              isVisible: true,
              start: DateTime.fromMillisecondsSinceEpoch(widget.endedLoad),
              end: DateTime.fromMillisecondsSinceEpoch(widget.endedLoad),
              borderWidth: 3,
              // gradient:LinearGradient(
              //     colors: [Colors.white,Colors.blue[200],Colors.blue],
              //     stops: [0.0,0.4,1.0],
              //     begin: Alignment.bottomCenter,
              //     end: Alignment.topCenter) ,
              dashArray: <double>[7, 3, 7, 3],
              borderColor: Colors.red,
            ),
          ],
          interval: 3,
          intervalType: DateTimeIntervalType.seconds,
          name: 'X-Axis',
          labelStyle: TextStyle(color: AppThemeManager().getGraphTextColor()),
          majorGridLines: MajorGridLines(width: 0)),
      // primaryXAxis: DateTimeAxis(
      //     intervalType: DateTimeIntervalType.years,
      //     dateFormat: DateFormat.y(),
      //     majorGridLines: MajorGridLines(width: 0),
      //     title: AxisTitle(text:  'Time')),
      primaryYAxis: NumericAxis(          labelStyle: TextStyle(color: AppThemeManager().getGraphTextColor()),

          title: AxisTitle(text: "Load ("+widget.unit+") ",textStyle: TextStyle(color: AppThemeManager().getGraphTextColor())),
          plotBands: <PlotBand>[
            // PlotBand(
            //   isVisible: true,
            //   start:widget.max>widget.target? widget.max:widget.target,
            //   end: widget.max>widget.target? widget.max:widget.target,
            //   borderWidth: true? 3:0,
            //   dashArray: <double>[5, 3],
            //   borderColor:true? Colors.blue:Colors.white,
            // ),

            PlotBand(
                isVisible: true,
                start: widget.target,
                end: widget.target,
                borderWidth: 3,
                borderColor:AppThemeManager().getGraphTargetColor(),
                textStyle: TextStyle(color: Colors.blue),
                dashArray: <double>[7, 3, 7, 3])
          ],
          minimum: 0,
          maximum: (widget.max > widget.target
                  ? widget.max.ceilToDouble()
                  : widget.target.ceilToDouble()) *
              1.1,
          axisLine: AxisLine(width: 0),
          anchorRangeToVisiblePoints: false,
          majorTickLines: MajorTickLines(size: 0)),
      // primaryYAxis: NumericAxis(
      //     minimum: 00,
      //     maximum: 60,
      //     interval: 100,
      //     axisLine: AxisLine(width: 0),
      //     labelFormat: '{value}kN',
      //     majorTickLines: MajorTickLines(size: 0)),

      series: _getMultiColoredLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  ///Get multi colored line series
  List<LineSeries<_ChartData, DateTime>> _getMultiColoredLineSeries() {
    final List<_ChartData> chartData = [];

    for (int i = 0; i < widget.data.length; i++) {
      // if(widget.doubledata[i]["time_duration"]!=null && widget.doubledata[i]["value"]!=null)
      print(widget.data[i]);

      //chartData.add(_ChartData(DateTime.fromMillisecondsSinceEpoch( widget.data[i]["time_duration"], widget.doubledata[i]["value"], const Color.fromRGBO(248, 184, 131, 1)),);
      chartData.add(_ChartData(
         // DateTime.fromMillisecondsSinceEpoch(widget.data[i]["time_duration"]), widget.data[i]["value"], widget.data[i]["color"] == 0 ? Colors.red : Colors.blue));
          DateTime.fromMillisecondsSinceEpoch(widget.data[i]["time_duration"]), widget.data[i]["value"], ThemeManager().getDarkGreenColor));
      // widget.data.add(ChartSampleDataD(z:1 ,x: new DateTime.fromMillisecondsSinceEpoch(widget.doubledata[i]["time_duration"]),y: widget.doubledata[i]["value"]));
      //widget.data2.add(_ChartData(x:widget.doubledata[i]["time_duration"] ,y: widget.doubledata[i]["value"]));
      // widget.data.add(ChartSampleDataD(x: DateTime.now(),y: widget.doubledata[i]["value"]));

    }

    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
          // onCreateRenderer: (ChartSeries<_ChartData, DateTime> series) {
          //  // return _CustomLineSeriesRenderer( series: series,max: widget.max);
          //   return _CustomLineSeriesRenderer(series as LineSeries,widget.max,widget.target,widget.startedLoad,widget.duration*1000,chartData.last.x.millisecondsSinceEpoch,widget.endedLoad,widget.fullDuration);
          // },
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          markerSettings: MarkerSettings(isVisible: false),

          /// The property used to apply the color each data.
          pointColorMapper: (_ChartData sales, _) => sales.lineColor,
          width: 2)
    ];
  }

  Widget checkAndShowPic(time, List allAttach,Widget widget) {

    if(allAttach.length>0) {
      Widget retval = Container(width: 0, height: 0,);
      for (int i = 0; i < allAttach.length; i++) {
        // if(time >= allAttach[i]["time"] && time  allAttach[i]["time"]+500){
        // if(time.isBetween( allAttach[i]["time"]-1000,  allAttach[i]["time"]+1000)){
        if (time >= allAttach[i]["time"] - 1000 &&
            time < allAttach[i]["time"] + 1000) {
          // }
          // retval = allAttach[i]["wid"];
          retval = Wrap(children: [
            widget,
            Container(width: 100, height: 100, child: allAttach[i]["wid"]),

          ],);
          break;
        } else {
          retval = Wrap(children: [
            widget,
            Container(width: 0, height: 0,)

          ],);
        }
      }
      return retval;
    }else return widget;
  }
}



class LineMultiColorNoTracking extends StatefulWidget {
  ///Renders line series with point color mapping
  List data;

  double max;
  double target;
  int startedLoad;
  int duration;
  int endedLoad;
  int fullDuration;
  bool didPassed;
  String unit;
  List<dynamic> imageAndTime = [];
  LineMultiColorNoTracking(
      {required this.data,
        required this.max,
        required  this.target,
        required this.startedLoad,
        required this.duration,
        required  this.endedLoad,
        required  this.unit,
        required  this.fullDuration,
        required this.didPassed});

  @override
  _LineMultiColorNoTrackingState createState() => _LineMultiColorNoTrackingState();
}

class _LineMultiColorNoTrackingState extends State<LineMultiColorNoTracking> {
  _LineMultiColorNoTrackingState();

  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {


    // AttachmentsAddedListener.getInstance().outData.listen((event) {
    //   setState(() {
    //     widget.imageAndTime = event;
    //     print("attach size "+ event.length.toString());
    //     print(event);
    //   });
    // });

    // imageAndTime.add({
    //   "wid": Text("Image one"),
    //   "time": 2000,
    // });
    // imageAndTime.add({
    //   "wid": Text("Image two"),
    //   "time": 8000,
    // });
    // imageAndTime.add({
    //   "wid": Text("Image three"),
    //   "time": 12000,
    // });

    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 8, 22, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //  child: durationToString(trackballDetails.point.x.millisecondsSinceEpoch),
            child:checkAndShowPic(trackballDetails.point!.x.millisecondsSinceEpoch,widget. imageAndTime, Text(
                ((trackballDetails.point!.y).toStringAsFixed(PrefferedDecimalPlaces)).toString()+" " +widget.unit+
                    "\n" +
                    durationToString(
                        trackballDetails.point!.x.millisecondsSinceEpoch)
                //+ "\n"
                ,
                // '${trackballDetails.point.x.toString()} : \$${double.parse(trackballDetails.point.y).toStringAsFixed(1)}',
                style: TextStyle(
                    fontSize: 10, color: Color.fromRGBO(255, 255, 255, 1)))),
          ),
        );
      },
    );
    // DateTime.now().millisecondsSinceEpoch
    // _trackballBehavior = TrackballBehavior(
    //     enable: true,
    //     activationMode: ActivationMode.singleTap,
    //     lineType: TrackballLineType.vertical,
    //     tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiColorLineChart();

  }

  ///Get the chart with multi colored line series
  SfCartesianChart _buildMultiColorLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 2,
      primaryXAxis: DateTimeAxis(

        //  title: AxisTitle(text: "Minute : Seconds "),
          plotBands: <PlotBand>[
            PlotBand(
              isVisible: true,
              start: DateTime.fromMillisecondsSinceEpoch(widget.startedLoad),
              end: DateTime.fromMillisecondsSinceEpoch(widget.startedLoad),
              dashArray: <double>[7, 3, 7, 3],
              borderWidth: 3,

              borderColor: Colors.greenAccent,
            ),
            PlotBand(
              isVisible: true,
              start: DateTime.fromMillisecondsSinceEpoch(widget.endedLoad),
              end: DateTime.fromMillisecondsSinceEpoch(widget.endedLoad),
              borderWidth: 3,
              // gradient:LinearGradient(
              //     colors: [Colors.white,Colors.blue[200],Colors.blue],
              //     stops: [0.0,0.4,1.0],
              //     begin: Alignment.bottomCenter,
              //     end: Alignment.topCenter) ,
              dashArray: <double>[7, 3, 7, 3],
              borderColor: Colors.red,
            ),
          ],
          interval: 3,
          intervalType: DateTimeIntervalType.seconds,
          name: 'X-Axis',
          majorGridLines: MajorGridLines(width: 0)),
      // primaryXAxis: DateTimeAxis(
      //     intervalType: DateTimeIntervalType.years,
      //     dateFormat: DateFormat.y(),
      //     majorGridLines: MajorGridLines(width: 0),
      //     title: AxisTitle(text:  'Time')),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: "Load ("+widget.unit+") "),
          plotBands: <PlotBand>[
            // PlotBand(
            //   isVisible: true,
            //   start:widget.max>widget.target? widget.max:widget.target,
            //   end: widget.max>widget.target? widget.max:widget.target,
            //   borderWidth: true? 3:0,
            //   dashArray: <double>[5, 3],
            //   borderColor:true? Colors.blue:Colors.white,
            // ),

            PlotBand(
                isVisible: true,
                start: widget.target,
                end: widget.target,
                borderWidth: 3,
                borderColor: Colors.black,
                textStyle: TextStyle(color: Colors.blue),
                dashArray: <double>[7, 3, 7, 3])
          ],
          minimum: 0,
          maximum: (widget.max > widget.target
              ? widget.max.ceilToDouble()
              : widget.target.ceilToDouble()) *
              1.1,
          axisLine: AxisLine(width: 0),
          anchorRangeToVisiblePoints: false,
          majorTickLines: MajorTickLines(size: 0)),
      // primaryYAxis: NumericAxis(
      //     minimum: 00,
      //     maximum: 60,
      //     interval: 100,
      //     axisLine: AxisLine(width: 0),
      //     labelFormat: '{value}kN',
      //     majorTickLines: MajorTickLines(size: 0)),
      series: _getMultiColoredLineSeries(),
     // trackballBehavior: _trackballBehavior,
    );
  }

  ///Get multi colored line series
  List<LineSeries<_ChartData, DateTime>> _getMultiColoredLineSeries() {
    final List<_ChartData> chartData = [];
    //widget.unit == "kN"
    if(true ){
      for (int i = 0; i < widget.data.length; i++) {
        // if(widget.doubledata[i]["time_duration"]!=null && widget.doubledata[i]["value"]!=null)
       // print(widget.data[i]);

        //chartData.add(_ChartData(DateTime.fromMillisecondsSinceEpoch( widget.data[i]["time_duration"], widget.doubledata[i]["value"], const Color.fromRGBO(248, 184, 131, 1)),);
        chartData.add(_ChartData(
          // DateTime.fromMillisecondsSinceEpoch(widget.data[i]["time_duration"]), widget.data[i]["value"], widget.data[i]["color"] == 0 ? Colors.red : Colors.blue));
            DateTime.fromMillisecondsSinceEpoch(widget.data[i]["time_duration"]), widget.data[i]["value"], ThemeManager().getDarkGreenColor));
        // widget.data.add(ChartSampleDataD(z:1 ,x: new DateTime.fromMillisecondsSinceEpoch(widget.doubledata[i]["time_duration"]),y: widget.doubledata[i]["value"]));
        //widget.data2.add(_ChartData(x:widget.doubledata[i]["time_duration"] ,y: widget.doubledata[i]["value"]));
        // widget.data.add(ChartSampleDataD(x: DateTime.now(),y: widget.doubledata[i]["value"]));

      }
    }else{
      for (int i = 0; i < widget.data.length; i++) {
        // if(widget.doubledata[i]["time_duration"]!=null && widget.doubledata[i]["value"]!=null)
        // print(widget.data[i]);

        //chartData.add(_ChartData(DateTime.fromMillisecondsSinceEpoch( widget.data[i]["time_duration"], widget.doubledata[i]["value"], const Color.fromRGBO(248, 184, 131, 1)),);
        chartData.add(_ChartData(
          // DateTime.fromMillisecondsSinceEpoch(widget.data[i]["time_duration"]), widget.data[i]["value"], widget.data[i]["color"] == 0 ? Colors.red : Colors.blue));
            DateTime.fromMillisecondsSinceEpoch(widget.data[i]["time_duration"]), widget.data[i]["value"].toInt(), ThemeManager().getDarkGreenColor));
        // widget.data.add(ChartSampleDataD(z:1 ,x: new DateTime.fromMillisecondsSinceEpoch(widget.doubledata[i]["time_duration"]),y: widget.doubledata[i]["value"]));
        //widget.data2.add(_ChartData(x:widget.doubledata[i]["time_duration"] ,y: widget.doubledata[i]["value"]));
        // widget.data.add(ChartSampleDataD(x: DateTime.now(),y: widget.doubledata[i]["value"]));

      }
    }



    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        // onCreateRenderer: (ChartSeries<_ChartData, DateTime> series) {
        //  // return _CustomLineSeriesRenderer( series: series,max: widget.max);
        //   return _CustomLineSeriesRenderer(series as LineSeries,widget.max,widget.target,widget.startedLoad,widget.duration*1000,chartData.last.x.millisecondsSinceEpoch,widget.endedLoad,widget.fullDuration);
        // },
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          markerSettings: MarkerSettings(isVisible: false),

          /// The property used to apply the color each data.
          pointColorMapper: (_ChartData sales, _) => sales.lineColor,
          width: 2)
    ];
  }

  Widget checkAndShowPic(time, List allAttach,Widget widget) {

    if(allAttach.length>0) {
      Widget retval = Container(width: 0, height: 0,);
      for (int i = 0; i < allAttach.length; i++) {
        // if(time >= allAttach[i]["time"] && time  allAttach[i]["time"]+500){
        // if(time.isBetween( allAttach[i]["time"]-1000,  allAttach[i]["time"]+1000)){
        if (time >= allAttach[i]["time"] - 1000 &&
            time < allAttach[i]["time"] + 1000) {
          // }
          // retval = allAttach[i]["wid"];
          retval = Wrap(children: [
            widget,
            Container(width: 100, height: 100, child: allAttach[i]["wid"]),

          ],);
          break;
        } else {
          retval = Wrap(children: [
            widget,
            Container(width: 0, height: 0,)

          ],);
        }
      }
      return retval;
    }else return widget;
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.lineColor);

  final DateTime x;
  final double y;
  late Color lineColor;
}




List<double> _xPointValues = <double>[];
List<double> _yPointValues = <double>[];





class _CircularIntervalList<T> {
  _CircularIntervalList(this._values);

  final List<T> _values;
  int _index = 0;

  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
//new end

/*

class _CustomLineSeriesRenderer extends LineSeriesRenderer {
  _CustomLineSeriesRenderer({this.series,this.max});

  double max ;

  final LineSeries<dynamic, dynamic> series;
  static Random randomNumber = Random();

  @override
  LineSegment createSegment() {
    return _LineCustomPainter(max, series);
  }
}

class _LineCustomPainter extends LineSegment {
  _LineCustomPainter(double value, this.series) {
    //ignore: prefer_initializing_formals
    maximum = value;

  }

  final LineSeries<dynamic, dynamic> series;
  double maximum, minimum;
  int index;
  List<Color> colors = <Color>[
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan
  ];

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.color = const Color.fromRGBO(53, 92, 125, 1);
    customerStrokePaint.strokeWidth = 2;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  void _storeValues() {

  }

  @override
  void onPaint(Canvas canvas) {
    final double x1 = points[0].dx,
        y1 = points[0].dy,
        x2 = points[1].dx,
        y2 = points[1].dy;
    _storeValues();
    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    if (currentSegmentIndex == series.dataSource.length - 2) {
      const double labelPadding = 10;
      final Paint topLinePaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final Paint bottomLinePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final Path bottomLinePath = Path();
      final Path topLinePath = Path();
      //create lines here

      bottomLinePath.moveTo(1, 3);
      bottomLinePath.lineTo(1, 3);

      topLinePath.moveTo(2, 3);
      topLinePath.lineTo(2, 3);
      // canvas.drawPath(_dashPath(bottomLinePath, dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),),bottomLinePaint);

      //canvas.drawPath(_dashPath(topLinePath, dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),), topLinePaint);
      Paint _paint;
      _paint = Paint()
        ..color = Colors.green
        ..strokeWidth = 4.0;
      double _progress = 0.0;

      // canvas.drawLine(p1, p2, paint)

      Paint _paint2;
      _paint2 = Paint()
        ..color = Colors.red
        ..strokeWidth = 4.0;

      canvas.drawLine(Offset(0.0, 200-maximum), Offset(0,200-maximum), _paint2);
      canvas.drawLine(Offset(200.0, 0.0), Offset(200,200), _paint);



    }
  }
}
*/
class CustomBarSeriesRenderer extends LineSeriesRenderer {
  @override
  LineSegment createSegment() {
    return CustomPainter();
  }
}

class CustomPainter extends LineSegment {
  @override
  Paint getFillPaint() {
    Paint _paint;
    _paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 8.0;
    double _progress = 0.0;

    //canvas.drawLine(Offset(0.0, 0.0), Offset(200,200), _paint);
    return _paint;
  }

  @override
  void onPaint(Canvas canvas) {
    // TODO: implement onPaint
    Paint _paint;
    _paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 8.0;
    double _progress = 0.0;
    canvas.drawLine(Offset(0.0, 0.0), Offset(200, 200), _paint);
  }
}

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
