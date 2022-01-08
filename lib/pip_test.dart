// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// void main() => runApp(ExampleApp());
//
// class ExampleApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
// class Floatingpage extends StatefulWidget {
//    Floatingpage({Key? key}) : super(key: key);
//   int time  = 0;
//
//   @override
//   _FloatingpageState createState() => _FloatingpageState();
//
// }
//
// class _FloatingpageState extends State<Floatingpage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer? timer;
//     timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
//       setState(() {
//         widget.time ++;
//       });
//
//     });
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      // resizeToAvoidBottomInset: !isFloating,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Text('This page will float!'),
//               Text(widget.time.toString()),
//               MaterialButton(
//                 color: Theme.of(context).primaryColor,
//                 child: Text('Start floating!'),
//                 onPressed: () {
//
//                  // PIPView.of(context).presentBelow(BackgroundScreen());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // return PIPView(
//     //   builder: (context, isFloating) {
//     //     return Floatingpage();
//     //   },
//     // );
//   }
// }
//
// class BackgroundScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Text('This is the background page!'),
//               Text('If you tap on the floating screen, it stops floating.'),
//               Text('Navigation works as expected.'),
//               MaterialButton(
//                 color: Theme.of(context).primaryColor,
//                 child: Text('Push to navigation'),
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => NavigatedScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class NavigatedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigated Screen'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Text('This is the page you navigated to.'),
//               Text('See how it stays below the floating page?'),
//               Text('Just amazing!'),
//               Spacer(),
//               Text('It also avoids keyboard!'),
//               TextField(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }