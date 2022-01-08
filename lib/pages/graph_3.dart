
/// Package import
import 'dart:math';

import 'package:flutter/material.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSampleDataD {
 late DateTime x;
 late  double y;
 late int z;
  ChartSampleDataD({required this.z,required this.x,required this.y});
}
/// Renders the chart with pinch zooming sample.
class DefaultPanning2 extends StatefulWidget {
  bool isWeb = true ;
  double max;
  List doubledata;
  List<ChartSampleDataD> data = [] ;
  List<_ChartData> data2 = [] ;
  double target;
  int startedLoad;
  int endLoad;
  DefaultPanning2(this.max,this.target,this.doubledata,this.startedLoad,this.endLoad);
  @override
  _DefaultPanningState createState() => _DefaultPanningState();
}

/// State class of the chart with pinch zooming.
class _DefaultPanningState extends State<DefaultPanning2> {




  final List<String> _zoomModeTypeList = <String>['x', 'y', 'xy'].toList();
  String _selectedModeType = 'x';
  ZoomMode _zoomModeType = ZoomMode.x;
  late ZoomPanBehavior _zoomingBehavior;
  late bool _enableAnchor;
  // bool _visible = false;
  GlobalKey<State> chartKey = GlobalKey<State>();
  late StateSetter refreshSetState;
  num left = 0, top = 0;
  late num screenSizeWidth;
  late bool isSameSize;
  @override
  void initState() {
    _selectedModeType = 'x';
    _zoomModeType = ZoomMode.x;
    _enableAnchor = true;
    super.initState();

    if(widget.doubledata.length>0){
      for(int i = 0 ; i < widget.doubledata.length ; i++){
       // if(widget.doubledata[i]["time_duration"]!=null && widget.doubledata[i]["value"]!=null)
        print(widget.doubledata[i]);
        widget.data.add(ChartSampleDataD(z:1 ,x: new DateTime.fromMillisecondsSinceEpoch(widget.doubledata[i]["time_duration"]),y: widget.doubledata[i]["value"]));
        //widget.data2.add(_ChartData(x:widget.doubledata[i]["time_duration"] ,y: widget.doubledata[i]["value"]));
       // widget.data.add(ChartSampleDataD(x: DateTime.now(),y: widget.doubledata[i]["value"]));

      }
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _zoomingBehavior = ZoomPanBehavior(

      /// To enable the pinch zooming as true.
        enablePinching: true,
        zoomMode: _zoomModeType,
        enablePanning: true,
        enableMouseWheelZooming: widget.isWeb ? true : false);

    // screenSizeWidth ??= MediaQuery.of(context).size.width;
    // final num currentSizeWidth = MediaQuery.of(context).size.width;
    // if (currentSizeWidth != screenSizeWidth) {
    //   isSameSize = false;
    //   // _visible = false;
    // } else {
    //   isSameSize = true;
    // }
    // screenSizeWidth = currentSizeWidth;

    return Stack(children: <Widget>[
      _getDefaultPanningChart(widget.target),
     // _buildAxisAnimation(),
      // isCardView
      //     ? Container()
      //     : StatefulBuilder(
      //         builder: (BuildContext context, StateSetter setState) {
      //         print('refresh');
      //         refreshSetState = setState;
      //         Widget currentWidget;
      //         if (_visible) {
      //           isSameSize = true;
      //           currentWidget = Container(
      //               padding: EdgeInsets.only(
      //                   left: left.abs().toDouble(), top: top.toDouble()),
      //               child: FlatButton(
      //                   onPressed: () {
      //                     _zoomingBehavior.reset();
      //                     setState(() {
      //                       _visible = false;
      //                     });
      //                   },
      //                   child: const Icon(Icons.refresh, color: Colors.blue)));
      //         } else {
      //           currentWidget = Container();
      //         }
      //         return currentWidget;
      //       })
    ]);
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Zoom mode ',
                        style: TextStyle(

                          fontSize: 16,
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(70, 0, 40, 0),
                      height: 50,
                      // child: DropdownButton<String>(
                      //     underline: Container(color: Color(0xFFBDBDBD), height: 1),
                      //     value: _selectedModeType,
                      //     items: _zoomModeTypeList.map((String value) {
                      //       return DropdownMenuItem<String>(
                      //           value: (value != null) ? value : 'x',
                      //           child: Text('$value',
                      //           ));
                      //     }).toList(),
                      //     // onChanged: (String value) {
                      //     //   _onZoomTypeChange(value.toString());
                      //     //   stateSetter(() {});
                      //      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedModeType == 'x' ? true : false,
                child: Row(
                  children: <Widget>[
                    Text('Anchor range to \nvisible points',
                        style: TextStyle(

                          fontSize: 16,
                        )),
                    Container(
                        width: 90,
                        child: CheckboxListTile(

                            value: _enableAnchor, onChanged: (bool? value) {  },
                            // onChanged: (bool value) {
                            //   stateSetter(() {
                            //     _enableRangeCalculation(value);
                            //     _enableAnchor = value;
                            //     stateSetter(() {});
                            //   });
                             )),
                  ],
                ),
              ),
            ],
          );
        });
  }

  /// Returns the cartesian chart with pinch zoomings.
  SfCartesianChart _getDefaultPanningChart(double target) {
    return SfCartesianChart(
        key: chartKey,
        onActualRangeChanged: (ActualRangeChangedArgs args) {
          // final RenderBox renderBox =
          //     chartKey.currentContext.findRenderObject();
          // if (renderBox.hasSize) {
          //   final BoxConstraints constraints = renderBox.constraints;
          //   final num width = constraints.maxWidth;
          //   final num height = constraints.maxHeight;
          //   left = (width * 0.9) - 30 / 2;
          //   top = height * 0.001;
          //   if (!_visible) {
          //     if (!isSameSize) {
          //       Future.delayed(const Duration(milliseconds: 1), () {
          //         refreshSetState(() {
          //           _visible = true;
          //         });
          //       });
          //     }
          //   }
          // }
        },
        onZoomEnd: (ZoomPanArgs args) {
          if (args.currentZoomFactor < 1) {
            // setState(() {
            //   _visible = true;

            //   refreshSetState(() {});
            // });
          }
        },
        plotAreaBorderWidth: 1,
       // primaryXAxis:  NumericAxis(),
        primaryXAxis: DateTimeAxis(
        //     plotBands: <PlotBand>[
        //
        //   PlotBand(
        //     isVisible: true,
        //     start: DateTime.fromMillisecondsSinceEpoch(widget.startedLoad),
        //     end:  DateTime.fromMillisecondsSinceEpoch(widget.startedLoad),
        //     borderWidth: 1,
        //     borderColor: Colors.red,
        //   ),
        //   PlotBand(
        //     isVisible: true,
        //     start: DateTime.fromMillisecondsSinceEpoch(widget.endLoad),
        //     end:  DateTime.fromMillisecondsSinceEpoch(widget.endLoad),
        //     borderWidth: 1,
        //     borderColor: Colors.greenAccent,
        //   ),
        // ],
            name: 'X-Axis', majorGridLines: MajorGridLines(width: 0)),
      //  primaryXAxis:DateTimeAxis
        primaryYAxis: NumericAxis( minimum: 0,
            maximum: widget.max.ceilToDouble(),
            axisLine: AxisLine(width: 0),
            anchorRangeToVisiblePoints: _enableAnchor,
            majorTickLines: MajorTickLines(size: 0),
            // plotBands: <PlotBand>[
            //   PlotBand(
            //     isVisible: true,
            //     start: widget.target,
            //     end: widget.target,
            //     borderWidth: 1,
            //     borderColor: Colors.blue,
            //   )
            // ]

        ),
       // series: getDefaultPanningSeries(),
        series: getDefaultPanningSeries(),

        zoomPanBehavior: _zoomingBehavior);
  }
  SfCartesianChart _buildAxisAnimation() {
    return SfCartesianChart(
       // enableAxisAnimation: _animation,
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(),
        primaryYAxis: NumericAxis(),
        series: _getSeries());
  }

  /// Returns the list of Chart series which need to render on axis animation.
  List<LineSeries<_ChartData, num>> _getSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          dataSource: widget.data2,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          sortingOrder: SortingOrder.ascending,
          sortFieldValueMapper: (_ChartData sales, _) => sales.x,
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }
  /// Returns the list of chart series
  /// which need to render on the chart with pinch zooming.
  ///
  ///
  ///
  ///
  ///
  ///
  List<AreaSeries<ChartSampleDataD, DateTime>> getDefaultPanningSeries() {
    final List<Color> color = <Color>[];
    color.add(Colors.white);
    color.add(Colors.blue);
    color.add(Colors.blue);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.4);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);




    return <AreaSeries<ChartSampleDataD, DateTime>>[
      AreaSeries<ChartSampleDataD, DateTime>(

          dataSource:widget.data,
          xValueMapper: (ChartSampleDataD sales, _) => sales.x,
          yValueMapper: (ChartSampleDataD sales, _) => sales.y,
          gradient: gradientColors),


    ];
  }

  /// Method to get chart data points.


  /// Method to update the selected zoom type in the chart on change.
  void _onZoomTypeChange(String item) {
    _selectedModeType = item;
    if (_selectedModeType == 'x') {
      _zoomModeType = ZoomMode.x;
    }
    if (_selectedModeType == 'y') {
      _zoomModeType = ZoomMode.y;
    }
    if (_selectedModeType == 'xy') {
      _zoomModeType = ZoomMode.xy;
    }
    setState(() {
      /// update the zoom mode changes
    });
  }

  void _enableRangeCalculation(bool enableZoom) {
    _enableAnchor = enableZoom;
    setState(() {});
  }
}
class _ChartData {
  _ChartData({required this.x, required this.y});
  final int x;
  final double y;
}


//custom render line draw

class _CustomLineSeriesRenderer extends AreaSeriesRenderer {
  _CustomLineSeriesRenderer(this.series);

  final AreaSeries<ChartSampleDataD, DateTime> series;
  static Random randomNumber = Random();

  @override
  AreaSegment createSegment() {
    return _LineCustomPainter(1, series);
  }
}

class _LineCustomPainter extends AreaSegment {
  _LineCustomPainter(int value, this.series) {
    //ignore: prefer_initializing_formals
    index = value;

  }

  final AreaSeries<ChartSampleDataD, DateTime> series;
  late double maximum, minimum;
 late int index;
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
        ..strokeWidth = 8.0;
      double _progress = 0.0;


      canvas.drawLine(Offset(0.0, 0.0), Offset(200,200), _paint);



    }
  }
}

class CustomBarSeriesRenderer extends AreaSeriesRenderer {
  @override
  AreaSegment createSegment() {
    return CustomPainter();
  }
}
class CustomPainter extends AreaSegment {
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
    canvas.drawLine(Offset(0.0, 0.0), Offset(200,200), _paint);
  }
}