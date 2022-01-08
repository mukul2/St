
/// Package import
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/Chartsample.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';



/// Renders the chart with pinch zooming sample.
class DefaultPanning extends StatefulWidget {
  bool isWeb = false ;
  List<ChartSampleData> data;
  double max ;
  DefaultPanning(this.data,this.max);
  @override
  _DefaultPanningState createState() => _DefaultPanningState();
}

/// State class of the chart with pinch zooming.
class _DefaultPanningState extends State<DefaultPanning> {


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
      _getDefaultPanningChart(),
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
                      child: DropdownButton<String>(
                          underline: Container(color: Color(0xFFBDBDBD), height: 1),
                          value: _selectedModeType,
                          items: _zoomModeTypeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'x',
                                child: Text('$value',
                                   ));
                          }).toList(),
                          onChanged: (String? value) {
                            _onZoomTypeChange(value.toString());
                            stateSetter(() {});
                          }),
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

                            value: _enableAnchor,
                            onChanged: (bool? value) {
                              stateSetter(() {
                                _enableRangeCalculation(value!);
                                _enableAnchor = value;
                                stateSetter(() {});
                              });
                            })),
                  ],
                ),
              ),
            ],
          );
        });
  }

  /// Returns the cartesian chart with pinch zoomings.
  SfCartesianChart _getDefaultPanningChart() {



    return SfCartesianChart(


       // plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(isVisible: false,name: 'X-Axis', majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis( minimum: 0,
          maximum: widget.max,axisLine: AxisLine(width: 0),
            //anchorRangeToVisiblePoints: _enableAnchor,
          //  majorTickLines: MajorTickLines(size: 0)
        ),
        series: getDefaultPanningSeries(),
       // zoomPanBehavior: _zoomingBehavior
    );
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
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(name: 'X-Axis', majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0),
            anchorRangeToVisiblePoints: _enableAnchor,
            majorTickLines: MajorTickLines(size: 0)),
        series: getDefaultPanningSeries(),
        zoomPanBehavior: _zoomingBehavior);
  }

  /// Returns the list of chart series
  /// which need to render on the chart with pinch zooming.
  List<AreaSeries<ChartSampleData, DateTime>> getDefaultPanningSeries() {
    final List<Color> color = <Color>[];
    color.add(ThemeManager().getDarkGreenColor.withOpacity(0.1));
    color.add(ThemeManager().getDarkGreenColor.withOpacity(0.5));
    color.add(ThemeManager().getDarkGreenColor);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.4);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
          dataSource:widget.data,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          gradient: gradientColors)
    ];
  }

  /// Method to get chart data points.
  List<ChartSampleData> getDateTimeData() {
    List<ChartSampleData> randomData2 = [] ;
    for(int i = 0 ; i<widget.data.length ; i++){
      //randomData2.add( ChartSampleData(x:DateTime(1977, 10, 16),y: widget.data[i]),);
    }
    final List<ChartSampleData> randomData = <ChartSampleData>[
      //ChartSampleData(x: DateTime(1950, 3, 31), y: 80.7),

    ];
    return randomData;
  }

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









/// Renders the chart with pinch zooming sample.
class DefaultPanning3 extends StatefulWidget {
  bool isWeb = false ;
  List<ChartSampleData> data;
  DefaultPanning3(this.data);
  @override
  _DefaultPanningState3 createState() => _DefaultPanningState3();
}

/// State class of the chart with pinch zooming.
class _DefaultPanningState3 extends State<DefaultPanning3> {


  final List<String> _zoomModeTypeList = <String>['x', 'y', 'xy'].toList();
  String _selectedModeType = 'x';
  ZoomMode _zoomModeType = ZoomMode.x;
late  ZoomPanBehavior _zoomingBehavior;
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
      _getDefaultPanningChart(),
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
                      child: DropdownButton<String>(
                          underline: Container(color: Color(0xFFBDBDBD), height: 1),
                          value: _selectedModeType,
                          items: _zoomModeTypeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'x',
                                child: Text('$value',
                                ));
                          }).toList(),
                          onChanged: (String? value) {
                            _onZoomTypeChange(value.toString());
                            stateSetter(() {});
                          }),
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

                            value: _enableAnchor,
                            onChanged: (bool? value) {
                              stateSetter(() {
                                _enableRangeCalculation(value!);
                                _enableAnchor = value;
                                stateSetter(() {});
                              });
                            })),
                  ],
                ),
              ),
            ],
          );
        });
  }

  /// Returns the cartesian chart with pinch zoomings.
  SfCartesianChart _getDefaultPanningChart() {
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
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(name: 'X-Axis', majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(axisLine: AxisLine(width: 0), anchorRangeToVisiblePoints: _enableAnchor, majorTickLines: MajorTickLines(size: 0)),
        series: getDefaultPanningSeries(),
        zoomPanBehavior: _zoomingBehavior);
  }

  /// Returns the list of chart series
  /// which need to render on the chart with pinch zooming.
  List<AreaSeries<ChartSampleData, DateTime>> getDefaultPanningSeries() {
    final List<Color> color = <Color>[];
    color.add(Colors.blue.withOpacity(0.1));
    color.add(Colors.blue.withOpacity(0.5));
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
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
          dataSource:widget.data,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          gradient: gradientColors)
    ];
  }

  /// Method to get chart data points.
  List<ChartSampleData> getDateTimeData() {
    List<ChartSampleData> randomData2 = [] ;
    for(int i = 0 ; i<widget.data.length ; i++){
      //randomData2.add( ChartSampleData(x:DateTime(1977, 10, 16),y: widget.data[i]),);
    }
    final List<ChartSampleData> randomData = <ChartSampleData>[
      //ChartSampleData(x: DateTime(1950, 3, 31), y: 80.7),

    ];
    return randomData;
  }

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

