// import 'dart:async';
// import 'dart:developer';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
//
//
//
// class RoomName extends StatefulWidget {
//   RoomName();
//
//   @override
//   _RoomNameState createState() => _RoomNameState();
// }
//
// class _RoomNameState extends State<RoomName> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//
//
//
// class MainHomePagePion extends StatefulWidget {
//   late String title;
//   late String uid;
//   late String grpId;
//   late String grpName;
//  // late IO.Socket socket;
//   MainHomePagePion({required this.grpId,required this.grpName,required this.uid,
//
//   //  required this.socket
//
//   });
//
//   @override
//   _MainHomePageState createState() => _MainHomePageState();
// }
//
// class Participant {
//   Participant(this.title, this.renderer, this.stream);
//   MediaStream stream;
//   String title;
//   RTCVideoRenderer renderer;
// }
//
// class _MainHomePageState extends State<MainHomePagePion> {
//   List<Participant> plistW = <Participant>[];
//   // ion.Signal? _signal;
//   String ServerURL = '';
//   late ion.Client _client;
//   late  ion.LocalStream _localStream;
//
//   @override
//   void initState() {
//     super.initState();
//     initSignal();
//     pubSub();
//   }
//
//   initSignal() {
//     if (kIsWeb) {
//       ServerURL = 'https://mklsfu.loca.lt';
//       // ServerURL = 'https://soft-goose-43.loca.lt';
//       // ServerURL = 'http://206.189.16.1:9090';
//     } else {
//       ServerURL = 'https://mukulsfu.loca.lt';
//       ServerURL = 'https://soft-goose-43.loca.lt';
//       ServerURL = 'https://mklsfu.loca.lt';
//     }
//   }
//
//
//
//
//
//
//   void pubSub() async {
//     Map<String, dynamic> configuration = {
//       // 'codec': 'vp8',
//       'iceServers': [
//         {'urls': 'stun:stun.nextcloud.com:443'},
//         {'urls': 'stun:relay.webwormhole.io'},
//         {'urls': 'stun:stun.services.mozilla.com'},
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {
//           'url': 'stun:global.stun.twilio.com:3478?transport=udp',
//           'urls': 'stun:global.stun.twilio.com:3478?transport=udp'
//         },
//         {
//           'urls': 'turn:86.11.136.36:3478',
//           'credential': '%Welcome%4\$12345',
//           'username': 'administrator'
//         },
//         {
//           'urls': 'turn:90.251.249.168:3478',
//           'credential': '%Welcome%4\$12345',
//           'username': 'administrator'
//         },
//       ],
//       "sdpSemantics": "unified-plan"
//
//       // "sdpSemantics": kIsWeb ? "plan-b" : "unified-plan"
//     };
//     log("serverurl " + ServerURL);
//     if (_client == null) {
//       ion.Signal _signal = ion.GRPCWebSignal(ServerURL);
//
//       // create new client
//       _client = await ion.Client.create(
//           sid: widget.grpId, uid: widget.uid, signal: _signal,config: configuration);
//
//
//
//
//
//       // peer ontrack
//
//
//
//
//       _client.ontrack = (track, ion.RemoteStream remoteStream) async {
//         //track.kind == 'video'
//         print(_client.config);
//         if (track.kind == 'video') {
//           print('ontrack: remote stream: ${remoteStream.stream}');
//           var renderer = RTCVideoRenderer();
//           await renderer.initialize();
//           renderer.srcObject = remoteStream.stream;
//           setState(() {
//             plistW.add(
//                 Participant('RemoteStream', renderer, remoteStream.stream));
//           });
//         }
//       };
//
//
//
//
//
//
//
//
//
//
//       // create get user camera stream
//       _localStream = await ion.LocalStream.getUserMedia(
//           constraints: ion.Constraints.defaults..simulcast = false);
//       print("before");
//       // publish the stream
//       try{
//         await _client.publish(_localStream).then((value){
//           print("published");
//         });
//       }catch(e){
//         print("ex");
//         print(e);
//       }
//
//
//
//
//
//
//       var renderer = RTCVideoRenderer();
//       await renderer.initialize();
//       renderer.srcObject = _localStream.stream;
//       setState(() {
//         plistW.add(Participant("LocalStream", renderer, _localStream.stream));
//       });
//     } else {
//       // unPublish and remove stream from video element
//       await _localStream.stream.dispose();
//     //  _localStream = null;
//       _client.close();
//       //_client = null;
//     }
//   }
//
//   Widget getItemView(Participant item) {
//     log("items: " + item.toString());
//
//     return Container(decoration: BoxDecoration(
//         border: Border.all(color: Colors.white)
//     ),height: 150,width:150,child: RTCVideoView(item.renderer,
//         objectFit:
//         RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),);
//     return Container(
//         padding: EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '${item.title}:\n${item.stream.id}',
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ),
//             Expanded(
//               child: RTCVideoView(item.renderer,
//                   objectFit:
//                   RTCVideoViewObjectFit.RTCVideoViewObjectFitContain),
//             ),
//           ],
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.black,
//       // appBar: AppBar(
//       //   title: Text(widget.title),
//       // ),
//
//       body: generateVideos(),
//       // body: Container(
//       //   padding: EdgeInsets.all(10.0),
//       //   child: GridView.builder(
//       //     shrinkWrap: true,
//       //     itemCount: plist.length,
//       //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       //       crossAxisCount: 2,
//       //       mainAxisSpacing: 5.0,
//       //       crossAxisSpacing: 5.0,
//       //       childAspectRatio: 1.0,
//       //     ),
//       //     itemBuilder: (BuildContext context, int index) {
//       //       return getItemView(plist[index]);
//       //     },
//       //   ),
//       // ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: pubSub,
//       //   tooltip: 'Increment',
//       //   child: Icon(Icons.video_call),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   Widget generateVideos() {
//     List<Widget>allWidh = [];
//     double h = 0;
//     double w = 0 ;
//     if(plistW.length == 1){
//       h = MediaQuery.of(context).size.height-50;
//       w = MediaQuery.of(context).size.width-50;
//
//     }else if(plistW.length == 2){
//       h =( MediaQuery.of(context).size.height-50);
//       w =( MediaQuery.of(context).size.width-50)/2;
//     }else if(plistW.length <5){
//       h =( MediaQuery.of(context).size.height-50)/2;
//       w =( MediaQuery.of(context).size.width-50)/2;
//     }
//
//     else if(plistW.length <10){
//       h =( MediaQuery.of(context).size.height-50)/3;
//       w =( MediaQuery.of(context).size.width-50)/3;
//     } else if(plistW.length <17){
//       h =( MediaQuery.of(context).size.height-50)/4;
//       w =( MediaQuery.of(context).size.width-50)/4;
//     }else if(plistW.length <26){
//       h =( MediaQuery.of(context).size.height-50)/5;
//       w =( MediaQuery.of(context).size.width-50)/5;
//     }
//
//     // for(int i = 0 ; i < plistW.length ; i++){
//     //   if(plistW[i].stream!.getTracks().first.enabled == false){
//     //
//     //     setState(() {
//     //       plistW.removeAt(i);
//     //     });
//     //
//     //     break;
//     //
//     //
//     //   }
//     // }
//     for(int i = 0 ; i < plistW.length ; i++){
//
//
//       allWidh.add(Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(child:Container(decoration: BoxDecoration(
//             border: Border.all(color: Colors.white)
//         ),height: h,width: w,child: RTCVideoView(plistW[i].renderer,
//             objectFit:
//             RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),) ,),
//       ));
//     }
//     return Center(child: Wrap(children: allWidh,));
//
//
//
//
//
//
//
//   }
// }
