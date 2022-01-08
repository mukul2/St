import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizePannel{
  BuildContext context;
  SizePannel({required this.context});
  double get broadcastNameBottomSheetHeight => MediaQuery.of(context).size.height-100;
}