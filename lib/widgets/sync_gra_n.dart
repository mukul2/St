// import 'dart:async';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports

/// Renders the chart with pinch zooming sample.
class DefaultPanningNN extends StatefulWidget {
  /// Creates the chart with pinch zooming.

  @override
  _DefaultPanningState createState() => _DefaultPanningState();
}

/// State class of the chart with pinch zooming.
class _DefaultPanningState extends State<DefaultPanningNN> {
  _DefaultPanningState();
  final List<String> _zoomModeTypeList = <String>['x', 'y', 'xy'].toList();
   String _selectedModeType = 'x';
   ZoomMode _zoomModeType = ZoomMode.x;
 late  bool _enableAnchor;
  GlobalKey<State> chartKey = GlobalKey<State>();
  num left = 0, top = 0;
  @override
  void initState() {
    _selectedModeType = 'x';
    _zoomModeType = ZoomMode.x;
    _enableAnchor = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Container(child: _buildDefaultPanningChart(),height: 200,),);
  }

 

  /// Returns the cartesian chart with pinch zoomings.
  SfCartesianChart _buildDefaultPanningChart() {
    return SfCartesianChart(
        key: chartKey,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
            name: 'X-Axis', majorGridLines: MajorGridLines(width: 0)),

        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 60,
            interval: 0.1,
            axisLine: AxisLine(width: 0),
            anchorRangeToVisiblePoints: _enableAnchor,
            majorTickLines: MajorTickLines(size: 0)),
        series: getDefaultPanningSeries(),
        zoomPanBehavior: ZoomPanBehavior(

          /// To enable the pinch zooming as true.
            enablePinching: true,
            zoomMode: _zoomModeType,
            enablePanning: false,
            enableMouseWheelZooming:  false));
  }

  /// Returns the list of chart series
  /// which need to render on the chart with pinch zooming.
  List<AreaSeries<ChartSampleDataN, DateTime>> getDefaultPanningSeries() {
    final List<Color> color = <Color>[];
    color.add(Colors.teal.withOpacity(0.5));
    color.add(Colors.teal);
    color.add(Colors.teal);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.4);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    return <AreaSeries<ChartSampleDataN, DateTime>>[
      AreaSeries<ChartSampleDataN, DateTime>(
          dataSource: getDateTimeData(),
          xValueMapper: (ChartSampleDataN sales, _) => sales.x,
          yValueMapper: (ChartSampleDataN sales, _) => sales.y,
          gradient: gradientColors)
    ];
  }

  /// Method to get chart data points.
  List<ChartSampleDataN> getDateTimeData() {
    final List<ChartSampleDataN> randomData = <ChartSampleDataN>[

    ];
    return randomData;
  }

  /// Method to update the selected zoom type in the chart on change.

  void _enableRangeCalculation(bool enableZoom) {
    _enableAnchor = enableZoom;
    setState(() {});
  }
}

class ChartSampleDataN {
  DateTime x;
  double y;
  int color ;
  ChartSampleDataN({required this.x,required this.y,required this.color});
}