import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
 // return runApp(AnimationSplineDefault());
}


/// Renders the spline area chart sample.
class SplineArea extends StatefulWidget {
  /// Creates the spline area chart sample.
 // const SplineArea(Key key) : super(key: key);
  List<double>data;
  SplineArea(this.data);

  @override
  _SplineAreaState createState() => _SplineAreaState();
}

/// State class of the spline area chart.
class _SplineAreaState extends State<SplineArea> {
  _SplineAreaState();

  @override
  Widget build(BuildContext context) {
    return _getSplineAreaChart();
  }

  /// Returns the cartesian spline are chart.
  SfCartesianChart _getSplineAreaChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: true, opacity: 0.7),
      title: ChartTitle(text: 'Test Result'),
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}kN',
          axisLine: AxisLine(width: 0),
          
          majorTickLines: MajorTickLines(size: 0)),
      series: _getSplieAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: false),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<ChartSeries<_SplineAreaData, double>> _getSplieAreaSeries() {
    List<_SplineAreaData> chartData = [];
    for(int i = 0 ; i<widget.data.length ; i++){
      chartData.add( _SplineAreaData(i.toDouble(), widget.data[i], 0),);
    }


    return <ChartSeries<_SplineAreaData, double>>[
      SplineAreaSeries<_SplineAreaData, double>(
        dataSource: chartData,
        color: const Color.fromRGBO(75, 135, 185, 0.6),
        borderColor: const Color.fromRGBO(75, 135, 185, 1),
        borderWidth: 2,

        xValueMapper: (_SplineAreaData sales, _) => sales.year,
        yValueMapper: (_SplineAreaData sales, _) => sales.y1,
      ),

    ];
  }
}

/// Private class for storing the spline area chart datapoints.
class _SplineAreaData {
  _SplineAreaData(this.year, this.y1, this.y2);
  final double year;
  final double y1;
  final double y2;
}