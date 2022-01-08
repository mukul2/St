// import 'dart:async';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:connect/services/Signal.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// // import 'package:flutter_webrtc/web/rtc_session_description.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:sdp_transform/sdp_transform.dart';
//
//
//
// var ownCandidateID = null;
//
//
//
// class SimpleWebCall extends StatefulWidget {
//   List streams = [];
//
//
//  late dynamic ownCandidateID;
//   String appbart = "";
//   String appbart2 = "";
//   String callDuration = "Connecting...";
//
//   int callDurationSecond = 0;
//
//   bool isAudioMuted = false;
//   bool isScreenSharing = false;
//
//   bool isVideoMuted = false;
//   bool hasCountDownStartedOnce = false;
//
//   bool hasCallOffered = false;
//
//   String callerID = "0";
//
//   String ownID = "0";
//   String partnerid = "0";
//   bool isCaller = false;
//   bool isRecording = false;
//
//   FirebaseFirestore firestore;
//
//   bool didOpositConnected = false;
//
//   late String partnerPair;
//
//   late String localStreamId;
//   late String shareScreenId;
//   bool anyRemoteVideoStrem = false;
//   late  String room;
//   late  String ownName;
//
//
//   late dynamic offer;
//   String title = "t";
//
//   late bool containsVideo;
//   bool isCameraShowing = false;
//   String appbart3="";
//   String partnerName="";
//
//   void Function() callback;
//   void Function() callStartedNotify;
//   void Function() callUserIsNoAvailable;
//   IO.Socket socket;
//   SimpleWebCall({required this.socket,required this.partnerPair,
//     required  this.ownID,
//     required  this.partnerid,
//     required  this.isCaller,
//     required  this.firestore,
//     required  this.containsVideo,
//     required this.callback,
//     required this.callStartedNotify,
//     required  this.callUserIsNoAvailable,
//     required this.ownName,
//     required this.partnerName
//
//
//
//   });
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<SimpleWebCall>
//     with WidgetsBindingObserver {
//
//   late Timer timer;
//   bool _offer = false;
//   late RTCPeerConnection pc;
//   late MediaStream _localStream;
//   late MediaStream _localStreamVideo;
//   late MediaStream _localStreamScreenShare;
//
//   late MediaStream _localStreamForShare;
//
//   RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
//   RTCVideoRenderer _remoteRendererAudio = new RTCVideoRenderer();
//   late String remoteShowingStreamID;
//
//   late MediaRecorder _mediaRecorder;
//
//   bool get _isRec => _mediaRecorder != null;
//   final sdpController = TextEditingController();
//   List<RTCVideoRenderer> remoteRenderList = [];
//
//   @override
//   dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _remoteRendererAudio.dispose();
//     sdpController.dispose();
//     timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     initRenderers();
//     // socket = IO.io('http://localhost:3000');
//     // socket.onConnect((_) {
//     //   print('connect');
//     //   socket.emit('msg', 'test');
//     // });
//     List ids = [widget.ownID, widget.partnerid];
//     ids.sort();
//
//     setState(() {
//       widget.partnerPair = ids.first + "-" + ids.last;
//     });
//
//
//
//     try {
//       if (widget.isCaller) {
//         widget.firestore.collection("users").where("uid",isEqualTo: widget.ownID).get().then((value) {
//           widget.socket.emit("calldial", {
//             "partner": widget.partnerid,
//             "callerName": value.docs.first.data()["displayName"],
//             "callerId": widget.ownID,
//             "time":DateTime.now().millisecondsSinceEpoch
//           });
//         });
//
//
//
//
//         // Timer.periodic(Duration(milliseconds: 500), (timer) {
//         //   if (mounted) {
//         //     if(widget.didOpositConnected == false){
//         //       widget.socket.emit("calldial", {
//         //         "partner": widget.partnerid,
//         //         "callerName": "X",
//         //         "callerId": widget.ownID,
//         //         "time":DateTime.now().millisecondsSinceEpoch
//         //       });
//         //     }
//         //
//         //   }else{
//         //     timer.cancel();
//         //   }
//         // });
//
//
//         try {
//           widget.socket.on("accept" + widget.partnerid, (data) {
//             print("accepted on other side");
//
//             _createPeerConnectionSignal().then((pc) {
//               pc = pc;
//
//               if (widget.isCaller == true) {
//                 _createOfferSignal();
//                 //listen for nego as caller
//
//                 renegoCaller();
//
//
//
//
//
//
//
//
//               } else {
//                 //lookForOfferSignal();
//               }
//             });
//
//
//           });
//         } catch (e) {
//           print(e.toString());
//         }
//         try {
//           widget.socket.on("reject" + widget.partnerid, (data) {
//             print("reject on other side");
//
//
//             widget.callback();
//           });
//         } catch (e) {
//           print(e.toString());
//         }
//
//         try{
//           widget.socket.on("ringing" + widget.partnerid, (data) {
//             print("Ringing");
//
//             setState(() {
//               widget.callDuration = "Ringing";
//             });
//
//           });
//         }catch(e){
//
//         }
//
//       } else {
//         print("receiver here ");
//
//
//
//
//
//         _createPeerConnectionSignal().then((pc) {
//           pc = pc;
//
//           if (widget.isCaller == true) {
//
//           } else {
//             lookForOfferSignal();
//             if(widget.isCaller == false){
//               widget.socket.emit("accept",{"id":widget.ownID});
//             }
//             renegoRecever();
//           }
//         });
//
//
//
//       }
//     } catch (e) {
//
//     }
//
//
// /*
//     timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
//       if (widget.isCaller == true) {
//         widget.firestore
//             .collection("online")
//             .doc(widget.ownID)
//             .update({"calltime": new DateTime.now().millisecondsSinceEpoch});
//
//
//
//       } else {
//         widget.firestore
//             .collection("online")
//             .doc(widget.partnerid)
//             .update({"calltime": new DateTime.now().millisecondsSinceEpoch});
//       }
//     });
//
//  */
//   }
//
//   initRenderers() async {
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//     await _remoteRendererAudio.initialize();
//   }
//
//
//   void _createOfferSignal() async {
//
//
//     // Timer.periodic(Duration(milliseconds: 15000), (timer) {
//     //   if (mounted) {
//     //     if (widget.hasCountDownStartedOnce == false) {
//     //       widget.callUserIsNoAvailable();
//     //     }
//     //   } else {
//     //     timer.cancel();
//     //   }
//     // });
//
//
//
//     if (true) {
//       try {
//
//         RTCSessionDescription description = await pc
//             .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//         var session = parse(description.sdp!);
//         print("cerate off");
//         print(json.encode(session));
//         _offer = true;
//
//         await pc.setLocalDescription(description);
//
//
//         widget.socket.emit("offer", {"id": widget.partnerid, "offer": {
//           "type": description.type,
//           "sdp": description.sdp,
//         }});
//         print("offer sent");
//
//
//
//
//
//         widget.socket.on("answer"+widget.ownID, (data) async{
//           print("answer found");
//
//           dynamic ss =data;
//
//           RTCSessionDescription description =
//           new RTCSessionDescription(ss["sdp"], ss["type"]);
//           await pc.setRemoteDescription(description);
//         });
//
//
//         widget.socket.on("calleeCandidates"+widget.ownID, (data) async{
//           dynamic candidate = new RTCIceCandidate(
//             data["candidate"],
//             data["sdpMid"],
//             data["sdpMLineIndex"],
//           );
//           print("calleeCandidates found");
//           await  pc.addCandidate(candidate);
//
//
//           //renegoCaller();
//
//           if (widget.hasCountDownStartedOnce == false) {
//             startCallStartedCount();
//
//
//           }
//
//         });
//         if(widget.didOpositConnected == false){
//
//           // _createOfferSignal();
//
//         }
//
//
//
//       } catch (e) {
//         print("cach her ");
//         print(e.toString());
//
//       }
//
//
//     }
//     // print("writing my own des end of ");
//   }
//
//   void _createOfferNego(String room) async {
//     RTCSessionDescription description = await pc.createOffer(
//         {'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//     var session = parse(description.sdp!);
//
//
//     await pc.setLocalDescription(description);
//
//     await FirebaseFirestore.instance.collection("changes").add({
//
//       'offer': {
//         "type": description.type,
//         "sdp": description.sdp,
//       }
//     }).then((value) {
//       try {
//         FirebaseFirestore.instance
//             .collection("nego")
//             .doc(room)
//             .set({"id": value.id, "time": DateTime
//             .now()
//             .millisecondsSinceEpoch, "type": "o"}).then((value) {
//
//         });
//       } catch (e) {
//         FirebaseFirestore.instance
//             .collection("nego")
//             .doc(room)
//             .update({"id": value.id, "time": DateTime
//             .now()
//             .millisecondsSinceEpoch, "type": "o"}).then((value) {
//
//         });
//       }
//     });
//
//
//     // print("writing my own des end of ");
//   }
//
//   void _createAnswer() async {
//     RTCSessionDescription description = await pc
//         .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//     var session = parse(description.sdp!);
//     print("for " + widget.ownID);
//     print(json.encode(session));
//     print("for " + widget.ownID + " ends");
//     // print(json.encode({
//     //       'sdp': description.sdp.toString(),
//     //       'type': description.type.toString(),
//     //     }));
//     FirebaseFirestore.instance
//         .collection("offer")
//         .doc(widget.ownID)
//         .set({"offer": json.encode(session)});
//     pc.setLocalDescription(description);
//
//     print("answer done");
//     FirebaseFirestore.instance.collection("refresh").doc(widget.partnerid).set({
//       "time": new DateTime.now().millisecondsSinceEpoch,
//     });
//   }
//
//
//
//
//   void _setRemoteDescription() async {
//     String jsonString = sdpController.text;
//     dynamic session = await jsonDecode('$jsonString');
//
//     String sdp = write(session, null);
//
//     // RTCSessionDescription description =
//     //     new RTCSessionDescription(session['sdp'], session['type']);
//     RTCSessionDescription description =
//     new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
//
//     print("my suspect");
//     print(description.toMap());
//     print("my suspect ends");
//
//     await pc.setRemoteDescription(description);
//   }
//
//   void _setRemoteDescriptionFB(String data) async {
//     String jsonString = data;
//     dynamic session = await jsonDecode('$jsonString');
//
//     String sdp = write(session, null);
//
//     // RTCSessionDescription description =
//     //     new RTCSessionDescription(session['sdp'], session['type']);
//     RTCSessionDescription description =
//     new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
//     print("my suspect 1");
//     print(description.toMap());
//     print("my suspect 2 end");
//
//     await pc.setRemoteDescription(description);
//
//     print("now going for answer");
//     //  _createAnswerfb(widget.ownID);
//
//     _createAnswer();
//   }
//
//   void _setRemoteDescriptionNoAnswer(String data, String targetid) async {
//     String jsonString = data;
//     dynamic session = await jsonDecode('$jsonString');
//
//     String sdp = write(session, null);
//
//     // RTCSessionDescription description =
//     //     new RTCSessionDescription(session['sdp'], session['type']);
//     RTCSessionDescription description =
//     new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
//     print("my suspect 3");
//     print(description.toMap());
//     print("my suspect 3 ends");
//
//     await pc.setRemoteDescription(description);
//     FirebaseFirestore.instance
//         .collection("candidate")
//         .doc(targetid)
//         .collection("d")
//         .get()
//         .then((value) {
//       for (int i = 0; i < value.docs.length; i++) {
//         _addCandidateFB(value.docs[i].data()["candidate"]);
//       }
//       print("downloaded candidate");
//     });
//   }
//
//   void _addCandidate() async {
//     String jsonString = sdpController.text;
//     dynamic session = await jsonDecode('$jsonString');
//     print("my suspect 4");
//     print(session['candidate']);
//     print("my suspecr 5 ends");
//     dynamic candidate = new RTCIceCandidate(
//         session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
//     await pc.addCandidate(candidate);
//   }
//
//   void _addCandidateFB(String can) async {
//     String jsonString = can;
//     dynamic session = await jsonDecode('$jsonString');
//     print("my suspect 4");
//     print(session['candidate']);
//     print("my suspecr 5 ends");
//     dynamic candidate = new RTCIceCandidate(
//         session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
//     await pc.addCandidate(candidate);
//   }
// //
// //   _createPeerConnection(String roomID) async {
// //     // Map<String, dynamic> configuration = {
// //     //   "iceServers": [
// //     //     {"url": "stun:stun.l.google.com:19302"},
// //     //   ]
// //     // };
// //
// //     Map<String, dynamic> configuration333 = {
// //       'iceServers': [
// //         {
// //           'url': 'stun:global.stun.twilio.com:3478?transport=udp',
// //           'urls': 'stun:global.stun.twilio.com:3478?transport=udp'
// //         },
// //         {
// //           'url': 'turn:global.turn.twilio.com:3478?transport=udp',
// //           'username':
// //           '3f926f4477b772f4a60860bdb437393c678caed6bda265137c9f25ccabe7d7f3',
// //           'urls': 'turn:global.turn.twilio.com:3478?transport=udp',
// //           'credential': 'C0yrr3LLqUn35Yo3VTyPGQn84q8mLAgQO0xfspErp4g='
// //         },
// //         {
// //           'url': 'turn:global.turn.twilio.com:3478?transport=tcp',
// //           'username':
// //           '3f926f4477b772f4a60860bdb437393c678caed6bda265137c9f25ccabe7d7f3',
// //           'urls': 'turn:global.turn.twilio.com:3478?transport=tcp',
// //           'credential': 'C0yrr3LLqUn35Yo3VTyPGQn84q8mLAgQO0xfspErp4g='
// //         },
// //         {
// //           'url': 'turn:global.turn.twilio.com:443?transport=tcp',
// //           'username':
// //           '3f926f4477b772f4a60860bdb437393c678caed6bda265137c9f25ccabe7d7f3',
// //           'urls': 'turn:global.turn.twilio.com:443?transport=tcp',
// //           'credential': 'C0yrr3LLqUn35Yo3VTyPGQn84q8mLAgQO0xfspErp4g='
// //         }
// //       ]
// //     };
// //
// //     Map<String, dynamic> configuration = {
// //       'iceServers': [
// //         {'urls': 'stun:stun.nextcloud.com:443'},
// //         {'urls': 'stun:relay.webwormhole.io'},
// //         {'urls': 'stun:stun.services.mozilla.com'},
// //         {'urls': 'stun:stun.l.google.com:19302'},
// //         {
// //           'url': 'stun:global.stun.twilio.com:3478?transport=udp',
// //           'urls': 'stun:global.stun.twilio.com:3478?transport=udp'
// //         },
// //         {
// //           'urls': 'turn:86.11.136.36:3478',
// //           'credential': '%Welcome%4\$12345',
// //           'username': 'administrator'
// //         }
// //       ],
// //       "sdpSemantics": kIsWeb ? "plan-b" : "unified-plan"
// //     };
// //     Map<String, dynamic> configuration33 = {
// //       'iceServers': [
// //         {"url": "stun:stun.l.google.com:19302"},
// //         {
// //           'urls': 'turn:numb.viagenie.ca',
// //           'credential': '01620645499mkl',
// //           'username': 'saidur.shawon@gmail.com'
// //         }
// //       ]
// //     };
// //     Map<String, dynamic> configuration220 = {
// //       'iceServers': [
// //         {'urls': 'stun:stun.services.mozilla.com'},
// //         {'urls': 'stun:stun.l.google.com:19302'},
// //         {
// //           'urls': 'turn:numb.viagenie.ca',
// //           'credential': '01620645499mkl',
// //           'username': 'saidur.shawon@gmail.com'
// //         }
// //       ]
// //     };
// //     final Map<String, dynamic> offerSdpConstraints = {
// //       "mandatory": {
// //         "OfferToReceiveAudio": true,
// //         "OfferToReceiveVideo": true,
// //       },
// //       "optional": [],
// //     };
// //
// //     MediaStream _primaryStreem = await _getUserMedia();
// //
// //     //   _localStreamScreenShare = await _getUserMedia();
// //
// // //widget.containsVideo == false
// // //     if( widget.containsVideo == false){
// // //       for(int i = 0 ; i <_localStream.getVideoTracks().length ; i ++){
// // //         //_localStream.getVideoTracks()[i].(widget.isCameraOn);
// // //         _localStream.getVideoTracks()[i].enabled = !(_localStream.getVideoTracks()[i].enabled);
// // //       }
// // //       setState(() {
// // //         widget.isVideoMuted =  ! widget.isVideoMuted;
// // //       });
// // //     }
// //
// //     pc = await createPeerConnection(configuration, offerSdpConstraints);
// //
// //     pc.onRenegotiationNeeded = () {
// //       print("renego");
// //       setState(() {
// //         widget.appbart3 = "nego";
// //       });
// //       if ( widget.didOpositConnected) {
// //         if (widget.isCaller) {
// //           // _createOfferNego(roomID);
// //           //  MakeNewOfferNegoX(roomID);
// //         } else {
// //           // MakeNewANswerNego(roomID);
// //         }
// //         setState(() {
// //           // widget.appbart = "renegotionation";
// //         });
// //       }
// //     };
// //
// //
// //     if (pc != null) {
// //       //print(pc);
// //       print("yess error ");
// //     }
// //     if (kIsWeb) {
// //       // running on the web!
// //
// //
// //       final Map<String, dynamic> mediaConstraintsScreen = {
// //         'audio': true,
// //         'video': {
// //           'minWidth': 640,
// //           'minHeight':480
// //         }
// //       };
// //       // MediaStream streamScreenShare = await navigator.mediaDevices.getDisplayMedia(mediaConstraintsScreen);
// //       //await pc.addStream(streamScreenShare);
// //
// //       await pc.addStream(_primaryStreem);
// //
// //       //  await  pc.addStream(_localStreamScreenShare);
// //       // await  pc.addStream(_localStream.);
// //
// //
// //     } else {
// //       _primaryStreem.getTracks().forEach((track) {
// //         pc.addTrack(track, _primaryStreem);
// //       });
// //     }
// //
// //
// //     pc.onRemoveStream = (e) async {
// //       // setState(() {
// //       //   _remoteRenderer.srcObject = _remoteRendererAudio.srcObject;
// //       // });
// //
// //       setState(() {
// //         widget.anyRemoteVideoStrem = false;
// //       });
// //
// //       // setState(() {
// //       //   widget.anyRemoteVideoStrem = false;
// //       //
// //       //   List filtredStream = [] ;
// //       //   //filtredStream.addAll(widget.streams);
// //       //   for(int i = 0 ; i < widget.streams.length ; i++){
// //       //     if( widget.streams[i]["id"] != e.id){
// //       //       filtredStream.add(widget.streams[i]);
// //       //     }
// //       //     widget.streams.clear();
// //       //     widget.streams.addAll(filtredStream);
// //       //   }
// //       //
// //       // });
// //       //
// //       //
// //       // setState(() {
// //       //   remoteRenderList.clear();
// //       // });
// //       //
// //       // for(int i = 0 ; i < widget.streams.length ; i++){
// //       //   RTCVideoRenderer  _re = new RTCVideoRenderer();
// //       //   await _re.initialize();
// //       //   _re.srcObject = widget.streams[i]["stream"];
// //       //   setState(() {
// //       //     remoteRenderList.add(_re);
// //       //
// //       //   });
// //       // }
// //       // setState(() {
// //       //   _remoteRenderer =remoteRenderList.last;
// //       // });
// //
// //
// //     };
// //
// //     pc.onSignalingState = (e) {
// //       setState(() {
// //         widget.appbart2 = pc.iceConnectionState.toString();
// //       });
// //       if (pc.iceConnectionState ==
// //           RTCIceConnectionState.RTCIceConnectionStateConnected) {
// //         widget.callStartedNotify();
// //         print("call conncted");
// //
// //
// //         setState(() {
// //           widget.didOpositConnected = true;
// //           //  widget.appbart = "connected";
// //         });
// //       }
// //
// //       if (widget.didOpositConnected = true) {
// //         if (pc.iceConnectionState ==
// //             RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
// //           pc.close().then((value) {
// //             pc.dispose().then((value) {
// //               Navigator.pop(context);
// //             });
// //           });
// //         }
// //       }
// //
// //
// //       if (pc.iceConnectionState == 'disconnected') {}
// //     };
// //     try{
// //       if (kIsWeb) {
// //         // running on the web!
// //         pc.onAddStream = (stream) async {
// //           print("stream found");
// //           print("stream id "+stream.id);
// //           // if(stream.getVideoTracks().length>0){
// //           //   setState(() {
// //           //     _remoteRenderer.srcObject = stream;
// //           //     widget.anyRemoteVideoStrem = true;
// //           //     remoteShowingStreamID = stream.id;
// //           //     _remoteRenderer.srcObject = stream;
// //           //   });
// //           //
// //           // }else{
// //           //   _remoteRendererAudio.srcObject = stream;
// //           // }
// //
// //           if (_remoteRendererAudio.srcObject == null) {
// //             setState(() {
// //               _remoteRendererAudio.srcObject = stream;
// //             });
// //           } else
// //             setState(() {
// //               widget.anyRemoteVideoStrem = true;
// //               _remoteRenderer.srcObject = stream;
// //             });
// //
// //
// //           //
// //           //
// //           // setState(() {
// //           //   widget.streams.add({"id":stream.id,"stream":stream});
// //           //   // widget.appbart = pc.getRemoteStreams().length.toString()+" "+ pc.getLocalStreams().length.toString()+" "+ pc.getRemoteStreams().first.getVideoTracks().toString()+" "+ pc.getLocalStreams().first.getVideoTracks().toString();
// //           //   // widget.appbart =widget.streams.length.toString();
// //           // });
// //           //
// //           // setState(() {
// //           //   // _remoteRenderer.srcObject = widget.streams.last["stream"];
// //           //
// //           //   remoteRenderList.clear();
// //           //   // widget.streams.clear();
// //           // });
// //           //
// //           // for(int i = 0 ; i < widget.streams.length ; i++){
// //           //   RTCVideoRenderer  _re = new RTCVideoRenderer();
// //           //   await _re.initialize();
// //           //
// //           //   setState(() {
// //           //
// //           //     _re.srcObject = widget.streams[i]["stream"];
// //           //     remoteRenderList.add(_re);
// //           //
// //           //   });
// //           // }
// //           // setState(() {
// //           //   _remoteRenderer =remoteRenderList.last;
// //           // });
// //
// //
// //         };
// //       } else {
// //         pc.onTrack = (event) {
// //
// //           if (true || event.track.kind == 'video') {
// //             _remoteRenderer.srcObject = event.streams.first;
// //             event.streams.first.getTracks().forEach((track) {
// //               if (_remoteRendererAudio.srcObject == null) {
// //                 setState(() {
// //                   _remoteRendererAudio.srcObject = event.streams.first;
// //                 });
// //               } else
// //                 setState(() {
// //                   widget.anyRemoteVideoStrem = true;
// //                   _remoteRenderer.srcObject = event.streams.first;
// //                 });
// //             });
// //           }
// //         };
// //       }
// //     }catch(e){
// //       print("Exception in pc add");
// //     }
// //
// //     // ownOffer(pc);
// //
// //     //
// //     return pc;
// //   }
//
//   _createPeerConnectionSignal() async {
//     print("going to create peer");
//     // Map<String, dynamic> configuration = {
//     //   "iceServers": [
//     //     {"url": "stun:stun.l.google.com:19302"},
//     //   ]
//     // };
//
//     Map<String, dynamic> configuration333 = {
//       'iceServers': [
//         {
//           'url': 'stun:global.stun.twilio.com:3478?transport=udp',
//           'urls': 'stun:global.stun.twilio.com:3478?transport=udp'
//         },
//         {
//           'url': 'turn:global.turn.twilio.com:3478?transport=udp',
//           'username':
//           '3f926f4477b772f4a60860bdb437393c678caed6bda265137c9f25ccabe7d7f3',
//           'urls': 'turn:global.turn.twilio.com:3478?transport=udp',
//           'credential': 'C0yrr3LLqUn35Yo3VTyPGQn84q8mLAgQO0xfspErp4g='
//         },
//         {
//           'url': 'turn:global.turn.twilio.com:3478?transport=tcp',
//           'username':
//           '3f926f4477b772f4a60860bdb437393c678caed6bda265137c9f25ccabe7d7f3',
//           'urls': 'turn:global.turn.twilio.com:3478?transport=tcp',
//           'credential': 'C0yrr3LLqUn35Yo3VTyPGQn84q8mLAgQO0xfspErp4g='
//         },
//         {
//           'url': 'turn:global.turn.twilio.com:443?transport=tcp',
//           'username':
//           '3f926f4477b772f4a60860bdb437393c678caed6bda265137c9f25ccabe7d7f3',
//           'urls': 'turn:global.turn.twilio.com:443?transport=tcp',
//           'credential': 'C0yrr3LLqUn35Yo3VTyPGQn84q8mLAgQO0xfspErp4g='
//         }
//       ]
//     };
//
//     Map<String, dynamic> configuration = {
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
//         }
//       ],
//       "sdpSemantics": kIsWeb ? "plan-b" : "unified-plan"
//     };
//     Map<String, dynamic> configuration33 = {
//       'iceServers': [
//         {"url": "stun:stun.l.google.com:19302"},
//         {
//           'urls': 'turn:numb.viagenie.ca',
//           'credential': '01620645499mkl',
//           'username': 'saidur.shawon@gmail.com'
//         }
//       ]
//     };
//     Map<String, dynamic> configuration220 = {
//       'iceServers': [
//         {'urls': 'stun:stun.services.mozilla.com'},
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {
//           'urls': 'turn:numb.viagenie.ca',
//           'credential': '01620645499mkl',
//           'username': 'saidur.shawon@gmail.com'
//         }
//       ]
//     };
//     final Map<String, dynamic> offerSdpConstraints = {
//       "mandatory": {
//         "OfferToReceiveAudio": true,
//         "OfferToReceiveVideo": true,
//       },
//       "optional": [],
//     };
//
//     MediaStream _primaryStreem = await _getUserMedia();
//     //   _localStreamScreenShare = await _getUserMedia();
//
// //widget.containsVideo == false
// //     if( widget.containsVideo == false){
// //       for(int i = 0 ; i <_localStream.getVideoTracks().length ; i ++){
// //         //_localStream.getVideoTracks()[i].(widget.isCameraOn);
// //         _localStream.getVideoTracks()[i].enabled = !(_localStream.getVideoTracks()[i].enabled);
// //       }
// //       setState(() {
// //         widget.isVideoMuted =  ! widget.isVideoMuted;
// //       });
// //     }
//
//     pc = await createPeerConnection(configuration, offerSdpConstraints);
//
//     pc.onRenegotiationNeeded = () {
//
//       if (widget.didOpositConnected) {
//         setState(() {
//           widget.appbart3 = "nego";
//         });
//         if (widget.isCaller) {
//           // _createOfferNego(roomID);
//           MakeNewOfferNegoX();
//         } else {
//           MakeNewANswerNego();
//         }
//         setState(() {
//           // widget.appbart = "renegotionation";
//         });
//       }
//     };
//
//
//     if (pc != null) {
//       // print(pc);
//       print("not null");
//     }else{
//       print("null");
//     }
//     if (kIsWeb) {
//       // running on the web!
//
//
//       final Map<String, dynamic> mediaConstraintsScreen = {
//         'audio': true,
//         'video': {
//           'width': {'ideal': 1280},
//           'height': {'ideal': 720}
//         }
//       };
//       // MediaStream streamScreenShare = await navigator.mediaDevices.getDisplayMedia(mediaConstraintsScreen);
//       //await pc.addStream(streamScreenShare);
//
//       await pc.addStream(_primaryStreem);
//
//       //  await  pc.addStream(_localStreamScreenShare);
//       // await  pc.addStream(_localStream.);
//
//
//     } else {
//       _primaryStreem.getTracks().forEach((track) {
//         pc.addTrack(track, _primaryStreem);
//       });
//     }
//
//
//     pc.onRemoveStream = (e) async {
//       // setState(() {
//       //   _remoteRenderer.srcObject = _remoteRendererAudio.srcObject;
//       // });
//
//       setState(() {
//         widget.anyRemoteVideoStrem = false;
//       });
//
//       // setState(() {
//       //   widget.anyRemoteVideoStrem = false;
//       //
//       //   List filtredStream = [] ;
//       //   //filtredStream.addAll(widget.streams);
//       //   for(int i = 0 ; i < widget.streams.length ; i++){
//       //     if( widget.streams[i]["id"] != e.id){
//       //       filtredStream.add(widget.streams[i]);
//       //     }
//       //     widget.streams.clear();
//       //     widget.streams.addAll(filtredStream);
//       //   }
//       //
//       // });
//       //
//       //
//       // setState(() {
//       //   remoteRenderList.clear();
//       // });
//       //
//       // for(int i = 0 ; i < widget.streams.length ; i++){
//       //   RTCVideoRenderer  _re = new RTCVideoRenderer();
//       //   await _re.initialize();
//       //   _re.srcObject = widget.streams[i]["stream"];
//       //   setState(() {
//       //     remoteRenderList.add(_re);
//       //
//       //   });
//       // }
//       // setState(() {
//       //   _remoteRenderer =remoteRenderList.last;
//       // });
//
//
//     };
//
//     pc.onIceCandidate = (e) {
//
//       if (e.candidate != null) {
//         //  print("supecrt 7");
//
//         dynamic data = ({
//           'candidate': e.candidate.toString(),
//           'sdpMid': e.sdpMid.toString(),
//           'sdpMLineIndex': e.sdpMlineIndex,
//         });
//         //  print(data);
//         if (ownCandidateID == null) {
//           ownCandidateID = data;
//         }
//         // FirebaseFirestore.instance
//         //     .collection("rooms")
//         //     .doc(roomID)
//         //     .collection(
//         //     widget.isCaller ? "callerCandidates" : "calleeCandidates")
//         //     .add(data);
//
//         widget.socket.emit(
//             widget.isCaller ? "callerCandidates" : "calleeCandidates",
//             {"id": widget.partnerid, "cand": data});
//
//         //  print("supecrt 7 end");
//       }
//     };
//     pc.onSignalingState = (e) {
//       setState(() {
//         widget.appbart2 = pc.iceConnectionState.toString();
//       });
//       if (pc.iceConnectionState == RTCIceConnectionState.RTCIceConnectionStateConnected) {
//         // widget.callStartedNotify();
//         print("call conncted");
//
//
//         setState(() {
//           widget.didOpositConnected = true;
//           //  widget.appbart = "connected";
//         });
//       }
//
//
//
//
//       if (pc.iceConnectionState == 'disconnected') {
//         print('disconnected');
//       }
//     };
//
//     if(true){
//       if (kIsWeb) {
//         // running on the web!
//         pc.onAddStream = (stream) async {
//           print("new stream "+ stream.id);
//           // if(stream.getVideoTracks().length>0){
//           //   setState(() {
//           //     _remoteRenderer.srcObject = stream;
//           //     widget.anyRemoteVideoStrem = true;
//           //     remoteShowingStreamID = stream.id;
//           //     _remoteRenderer.srcObject = stream;
//           //   });
//           //
//           // }else{
//           //   _remoteRendererAudio.srcObject = stream;
//           // }
//
//           if (false && _remoteRendererAudio.srcObject == null) {
//             setState(() {
//               _remoteRendererAudio.srcObject = stream;
//             });
//           } else
//             setState(() {
//               widget.anyRemoteVideoStrem = true;
//               _remoteRenderer.srcObject = stream;
//             });
//
//
//           //
//           //
//           // setState(() {
//           //   widget.streams.add({"id":stream.id,"stream":stream});
//           //   // widget.appbart = pc.getRemoteStreams().length.toString()+" "+ pc.getLocalStreams().length.toString()+" "+ pc.getRemoteStreams().first.getVideoTracks().toString()+" "+ pc.getLocalStreams().first.getVideoTracks().toString();
//           //   // widget.appbart =widget.streams.length.toString();
//           // });
//           //
//           // setState(() {
//           //   // _remoteRenderer.srcObject = widget.streams.last["stream"];
//           //
//           //   remoteRenderList.clear();
//           //   // widget.streams.clear();
//           // });
//           //
//           // for(int i = 0 ; i < widget.streams.length ; i++){
//           //   RTCVideoRenderer  _re = new RTCVideoRenderer();
//           //   await _re.initialize();
//           //
//           //   setState(() {
//           //
//           //     _re.srcObject = widget.streams[i]["stream"];
//           //     remoteRenderList.add(_re);
//           //
//           //   });
//           // }
//           // setState(() {
//           //   _remoteRenderer =remoteRenderList.last;
//           // });
//
//
//         };
//       } else {
//         pc.onTrack = (event) {
//           print("new stream "+ event.streams.first.id);
//           if (true || event.track.kind == 'video') {
//             _remoteRenderer.srcObject = event.streams.first;
//             event.streams.first.getTracks().forEach((track) {
//               if (_remoteRendererAudio.srcObject == null) {
//                 setState(() {
//                   _remoteRendererAudio.srcObject = event.streams.first;
//                 });
//               } else
//                 setState(() {
//                   widget.anyRemoteVideoStrem = true;
//                   _remoteRenderer.srcObject = event.streams.first;
//                 });
//             });
//           }
//         };
//       }
//     }
//
//     // ownOffer(pc);
//
//     //
//     return pc;
//   }
//
//   void _startRecording() async {
//     // customStream.addTrack(_localStream.);
//
//     // for(int i = 0 ; i < _localStream.getTracks() .length ; i ++){
//     //   customStream.addTrack(_localStream.getTracks()[i]);
//     // }
//
//     // for(int i = 0 ; i < _remoteRenderer.srcObject.getTracks() .length ; i ++){
//     //   customStream.addTrack(_remoteRenderer.srcObject.getTracks()[i]);
//     // }
//
//     _mediaRecorder = MediaRecorder();
//     setState(() {
//       widget.isRecording = true;
//     });
//
//     _mediaRecorder.startWeb(_remoteRenderer.srcObject!);
//   }
//
//   void _stopRecording() async {
//     // final objectUrl = await _mediaRecorder?.stop();
//     // setState(() {
//     //   _mediaRecorder = null;
//     //   widget.isRecording = false;
//     // });
//     // print(objectUrl);
//     // html.window.open(objectUrl, '_blank');
//     // downloadFile(objectUrl);
//   }
//
//   void downloadFile(String url) {
//     // html.AnchorElement anchorElement = new html.AnchorElement(href: url);
//     // anchorElement.download = url;
//     // anchorElement.click();
//   }
//
//   _getUserMedia() async {
//
//     final mediaConstraints = <String, dynamic>{
//       'audio': true,
//       'video': {
//         'mandatory': {
//           'minWidth':
//           '640', // Provide your own width, height and frame rate here
//           'minHeight': '480',
//           'minFrameRate': '30',
//         },
//         'facingMode': 'user',
//         'optional': [],
//       }
//     };
//     // final Map<String, dynamic> mediaConstraints = {
//     //   'audio': true,'video': {
//     //     'minWidth': 640,
//     //     'minHeight':480
//     //   }
//     // };
//
//
//     MediaStream stream = await navigator.mediaDevices.getUserMedia(
//         mediaConstraints);
//     //MediaStream streamScreenShare = await navigator.mediaDevices.getDisplayMedia(mediaConstraintsScreen);
//     // MediaStream stream   = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
//
//     // _localStream = stream;
//
//     //_localRenderer.srcObject = stream;
//     // _localRenderer.mirror = true;
//
//     //  RTCVideoRenderer  _re = new RTCVideoRenderer();
//     // await _re.initialize();
//     //// _re.srcObject = stream;
//     setState(() {
//       // remoteRenderList.add(_re);
//
//     });
//
//
//     // pc.addStream(stream);
//
//     return stream;
//   }
//
//   SizedBox videoRenderers() =>
//       SizedBox(
//           height: 500,
//           child: Row(children: [
//             Flexible(
//               child: new Container(
//                   key: new Key("local"),
//                   margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
//                   decoration: new BoxDecoration(color: Colors.black),
//                   child: new RTCVideoView(_localRenderer)),
//             ),
//             Flexible(
//               child: new Container(
//                   key: new Key("remote"),
//                   margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
//                   decoration: new BoxDecoration(color: Colors.black),
//                   child: new RTCVideoView(_remoteRenderer)),
//             )
//           ]));
//
//   Widget screenView() {
//     return Center(
//       child: Container(
//         color: Colors.black,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         height: MediaQuery
//             .of(context)
//             .size
//             .height,
//         child: Stack(
//           children: [
//             // Align(
//             //     alignment: Alignment.center,
//             //     child: new RTCVideoView(
//             //       _remoteRendererAudio,
//             //       objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//             //     )),
//             Align(
//                 alignment: Alignment.bottomCenter,
//                 child: widget.anyRemoteVideoStrem == true ? new RTCVideoView(
//                   _remoteRenderer,
//                   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                 ) : Center(child: Text(widget.partnerName, style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontSize: 30),),)),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: MediaQuery
//                     .of(context)
//                     .size
//                     .width,
//                 height: 70,
//                 child: Center(
//                   child: Container(
//                     height: 70,
//
//
//                     child: Center(
//                       child: Wrap(
//                         children: [
//
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: InkWell(onTap:(){
//                               try {
//                                 pc.close().then((value) async {
//                                   pc.dispose().then((value) async {
//                                     // Navigator.pop(context);
//
//
//
//                                     widget.callback();
//                                   });
//                                 });
//                               } catch (e) {
//                                 widget.callback();
//                               }
//                             } ,
//                               child: Card(elevation: 5,
//
//                                 color: Colors.redAccent,
//
//
//
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(
//                                     Icons.call_end, color: Colors.white,),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(left: 0,
//                 right: 0,
//                 bottom: 80,
//                 child: Center(child: Text(widget.callDuration,
//                   style: TextStyle(color: Colors.white),))),
//             _localRenderer.srcObject != null ? Positioned(
//               right: 5,
//               top: 5,
//               child: Container(
//                 height: 100,
//                 width: 100,
//                 child: Container(
//                     key: new Key("local"),
//                     margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
//                     decoration: new BoxDecoration(color: Colors.black),
//                     child: new RTCVideoView(
//                       _localRenderer,
//                       objectFit:
//                       RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                     )),
//               ),
//             ) : Container(width: 0, height: 0,),
//
//             Align(
//                 alignment: Alignment.topLeft,
//                 child: Container(
//                   height: 106,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: remoteRenderList.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         color: Colors.white,
//                         child: Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             child: false ? Center(child: Icon(
//                               Icons.volume_up_rounded,
//                               color: Colors.redAccent,),) : new RTCVideoView(
//                               remoteRenderList[index],
//                               objectFit: RTCVideoViewObjectFit
//                                   .RTCVideoViewObjectFitCover,),
//                             // child: new RTCVideoView( remoteRenderList[index],),//remoteRenderList[index].srcObject.getVideoTracks().length== 0
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )),
//
//
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Row sdpCandidateButtons() =>
//       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
//         RaisedButton(
//           onPressed: _setRemoteDescription,
//           child: Text('Set Remote Desc'),
//           color: Colors.amber,
//         ),
//         RaisedButton(
//           onPressed: _addCandidate,
//           child: Text('Add Candidate'),
//           color: Colors.amber,
//         )
//       ]);
//
//   Padding sdpCandidatesTF() =>
//       Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: TextField(
//           controller: sdpController,
//           keyboardType: TextInputType.multiline,
//           maxLines: 4,
//           maxLength: TextField.noMaxLength,
//         ),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(body: Text(widget.ownID+"  "+widget.partnerid+"  "+widget.isCaller.toString()),);
//     // List<RTCVideoRenderer> remoteRenderListFiltered = [];
//     // for(int i =  0 ; i < remoteRenderList.length; i++){
//     //   if(remoteRenderList[i].srcObject.active){
//     //     remoteRenderListFiltered.add(remoteRenderList[i]);
//     //   }
//     //   setState(() {
//     //     remoteRenderList.clear();
//     //     remoteRenderList.addAll(remoteRenderListFiltered);
//     //   });
//     // }
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         //appBar: AppBar(title: Text(widget.appbart3),),
//         // appBar: AppBar(title: Text(widget.ownID+"  "+widget.partnerid+"  "+widget.isCaller.toString()),),
//           backgroundColor: Colors.black,
//           body: screenView()),
//     );
//   }
//
//
//
//
//
//
//
// //   void initWorkLoad(String roomId) {
// //     initRenderers();
// //     _createPeerConnection(roomId).then((pc) {
// //       pc = pc;
// //
// //       if (widget.isCaller == true) {
// //         _createOffer(roomId);
// //       } else {
// //         lookForOffer(roomId);
// //       }
// //
// //       // ownOffer();
// // /*
// //       Future.delayed(Duration(seconds: 2), () {
// //         for (int i = 0; i < 1; i ++) {
// //           Future.delayed(Duration(seconds: 1 + (i)), () {
// //             setState(() {
// //               // widget.appbart = "going one round " + i.toString();
// //             });
// //             print("going one round");
// //             if (widget.isCaller == true) {
// //               setState(() {
// //                 widget.callerID = widget.ownID;
// //               });
// //               try {
// //                _createOffer(roomId);
// //               } catch (e) {
// //                 setState(() {
// //                   // widget.appbart = "One exxecption from catch";
// //                 });
// //                 print("One exxecption from catch");
// //                 print(e.toString());
// //               }
// //             } else {
// //               setState(() {
// //                 widget.callerID = widget.partnerid;
// //               });
// //             }
// //           });
// //         }
// //       });
// //       */
// //     });
// //   }
//   void lookForOfferSignal() async {
//     print("looking for offer");
//
//     try{
//
//
//
//       widget.socket.on("offer"+widget.ownID, (data) async{
//         print(data);
//
//         dynamic ss =data;
//         print("found offer");
//         RTCSessionDescription description =
//         new RTCSessionDescription(ss["sdp"], ss["type"]);
//         if( ! (pc.signalingState == RTCSignalingState.RTCSignalingStateClosed)){
//
//           await pc.setRemoteDescription(description);
//           RTCSessionDescription descriptionLocal = await pc
//               .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//           await pc.setLocalDescription(descriptionLocal);
//           widget.socket.emit("answer", {"id": widget.partnerid, "answer": {
//             "type": descriptionLocal.type,
//             "sdp": descriptionLocal.sdp,
//           }});
//           print("answer sent");
//           //callerCandidates
//           try{
//             widget.socket.on("callerCandidates"+widget.ownID, (data) async{
//               dynamic candidate = new RTCIceCandidate(
//                 data["candidate"],
//                 data["sdpMid"],
//                 data["sdpMLineIndex"],
//               );
//               await   pc.addCandidate(candidate);
//               print("candidate set");
//
//               if (widget.hasCountDownStartedOnce == false) {
//                 startCallStartedCount();
//               }
//
//
//
//             });
//             if(widget.didOpositConnected == false){
//               //lookForOfferSignal();
//             }
//           }catch(e){
//
//           }
//
//
//         }else{
//           print("blocked");
//           print(pc.signalingState.toString());
//         }
//
//
//       });
//
//     }catch(e){
//
//     }
//
//     //FirebaseFirestore.instance.collection("queu").doc(widget.partnerPair).set({"room":room});
//   }
//   void lookForOffer(String roomId) async {
//     FirebaseFirestore.instance
//         .collection("rooms")
//         .doc(roomId)
//         .get()
//         .then((event) async {
//       if (event.exists && event.data()!["offer"] != null) {
//         //mkl
//         setState(() {
//           widget.appbart = " offer fo";
//         });
//
//         print("remote des below");
//         print(event.data()!["offer"]);
//
//         dynamic offer = event.data()!["offer"];
//         setState(() {
//           widget.appbart = "gdr " + offer["type"];
//         });
//
//         RTCSessionDescription description =
//         new RTCSessionDescription(offer["sdp"], offer["type"]);
//
//         print("my suspect");
//         // print(description.toMap());
//         print("my suspect ends");
//
//         await pc.setRemoteDescription(description);
//         setState(() {
//           widget.appbart = "remote des added ";
//         });
//
//         setState(() {
//           widget.appbart = widget.appbart + " answering";
//         });
//         RTCSessionDescription descriptionLocal = await pc
//             .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//         setState(() {
//           widget.appbart = widget.appbart + " anser done";
//         });
//         //var session = parse(description.sdp);
//         print("cerate off");
//         // print(json.encode(session));
//         _offer = false;
//
//         // print(json.encode({
//         //       'sdp': description.sdp.toString(),
//         //       'type': description.type.toString(),
//         //     }));
//         //FirebaseFirestore.instance.collection(widget.ownID).add(session);
//         // print("writing my own des");
//
//         await pc.setLocalDescription(descriptionLocal);
//         setState(() {
//           widget.appbart = " set ld done";
//         });
//         await FirebaseFirestore.instance
//             .collection("rooms")
//             .doc(roomId)
//             .update({
//           'roolId': roomId,
//           'answer': {
//             "type": descriptionLocal.type,
//             "sdp": descriptionLocal.sdp,
//           }
//         });
//
//         setState(() {
//           widget.hasCallOffered = true;
//         });
//
//         FirebaseFirestore.instance
//             .collection("rooms")
//             .doc(roomId)
//             .collection("callerCandidates")
//             .get()
//             .then((event) {
//           if (event.docs.length > 0) {
//             setState(() {
//               widget.appbart =
//                   " candidate side " + event.docs.length.toString() + " ";
//             });
//
//             for (int i = 0; i < event.docs.length; i++) {
//               dynamic candidate = new RTCIceCandidate(
//                 event.docs[i].data()["candidate"],
//                 event.docs[i].data()["sdpMid"],
//                 event.docs[i].data()["sdpMLineIndex"],
//               );
//               print("one candidate added");
//
//               // dynamic session = event.docs[i].data();
//
//               //dynamic candidate = new RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
//               pc.addCandidate(candidate).then((value) {});
//             }
//             widget.callStartedNotify();
//             if (widget.hasCountDownStartedOnce == false) {
//               startCallStartedCount();
//               setState(() {
//                 widget.hasCountDownStartedOnce = true;
//               });
//             }
//           } else {
//             setState(() {
//               widget.appbart = widget.appbart + "  no candidate " + " ";
//             });
//           }
//         });
//       } else {
//         setState(() {
//           widget.appbart = widget.appbart + " no offer";
//         });
//       }
//     });
//
//     //FirebaseFirestore.instance.collection("queu").doc(widget.partnerPair).set({"room":room});
//   }
//
//   void MakeNewANswerNego() async {
//     print("looking for offer nego ");
//
//     widget.socket.on("offerN"+widget.ownID, (data) async{
//       print(data);
//
//       dynamic ss =data;
//       print("found offer");
//       RTCSessionDescription description =
//       new RTCSessionDescription(ss["sdp"], ss["type"]);
//       await pc.setRemoteDescription(description);
//       RTCSessionDescription descriptionLocal = await pc
//           .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//       await pc.setLocalDescription(descriptionLocal);
//       widget.socket.emit("answerN", {"id": widget.partnerid, "answer": {
//         "type": descriptionLocal.type,
//         "sdp": descriptionLocal.sdp,
//       }});
//
//     });
//   }
//
//   void MakeNewOfferNegoX() async {
//     print("trying new nego offer");
//     RTCSessionDescription description = await pc
//         .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//     var session = parse(description.sdp!);
//     print("cerate off");
//     print(json.encode(session));
//     _offer = true;
//
//     await pc.setLocalDescription(description);
//
//
//     widget.socket.emit("offerN", {"id": widget.partnerid, "offer": {
//       "type": description.type,
//       "sdp": description.sdp,
//     }});
//
//
//     try {
//       widget.socket.on("answerN"+widget.ownID, (data) async{
//
//         dynamic ss =data;
//         setState(() {
//           widget.appbart = "gdr " + ss["type"];
//         });
//         RTCSessionDescription description =
//         new RTCSessionDescription(ss["sdp"], ss["type"]);
//         await pc.setRemoteDescription(description);
//       });
//
//
//     } catch (e) {
//
//     }
//
//
//
//
//   }
//
//   void lookForOfferNego(String roomId, dynamic offer) async {
//     setState(() {
//       widget.appbart = "gdr " + offer["type"];
//     });
//
//     RTCSessionDescription description = new RTCSessionDescription(
//         offer["sdp"], offer["type"]);
//
//     print("my suspect");
//     // print(description.toMap());
//     print("my suspect ends");
//
//     await pc.setRemoteDescription(description);
//
//     setState(() {
//       widget.appbart = widget.appbart + " answering";
//     });
//     RTCSessionDescription descriptionLocal = await pc.createAnswer(
//         {'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//     await pc.setLocalDescription(descriptionLocal);
//
//     await FirebaseFirestore.instance
//         .collection("changes").add({
//       'roolId': roomId,
//       'answer': {
//         "type": descriptionLocal.type,
//         "sdp": descriptionLocal.sdp,
//       }
//     }).then((value) {
//       try {
//         FirebaseFirestore.instance
//             .collection("nego")
//             .doc(roomId)
//             .set({"id": value.id, "time": DateTime
//             .now()
//             .millisecondsSinceEpoch, "type": "a"}).then((value) {
//
//         });
//       } catch (e) {
//         FirebaseFirestore.instance
//             .collection("nego")
//             .doc(roomId)
//             .update({"id": value.id, "time": DateTime
//             .now()
//             .millisecondsSinceEpoch, "type": "a"}).then((value) {
//
//         });
//       }
//     });
//
//     // print(json.encode({
//     //       'sdp': description.sdp.toString(),
//     //       'type': description.type.toString(),
//     //     }));
//     //FirebaseFirestore.instance.collection(widget.ownID).add(session);
//     // print("writing my own des");
//
//     // await pc.setLocalDescription(descriptionLocal);
//
//
//     setState(() {
//       widget.hasCallOffered = true;
//     });
//     setState(() {
//       widget.appbart = "reached finish";
//     });
//
//     //FirebaseFirestore.instance.collection("queu").doc(widget.partnerPair).set({"room":room});
//   }
//
//   void handelScreenShaing() async {
//     setState(() {
//       widget.isScreenSharing = !widget.isScreenSharing;
//     });
//     if (widget.isScreenSharing == true) {
//       final Map<String, dynamic> mediaConstraintsScreen = {
//         'audio': true,
//         'video': {
//           'width': {'ideal': 1980},
//           'height': {'ideal': 1280}
//         }
//       };
//       MediaStream newStream = await navigator.mediaDevices.getDisplayMedia(
//           mediaConstraintsScreen);
//       setState(() {
//         _localStreamScreenShare = newStream;
//         // widget.containsVideo = false ;
//
//         if (widget.isCameraShowing) {
//           pc.removeStream(_localStreamVideo).then((value) {
//             setState(() {
//               _localRenderer.srcObject = null;
//             });
//           });
//           widget.isCameraShowing = false;
//         }
//         if (kIsWeb) {
//           pc.addStream(_localStreamScreenShare).then((value) {
//             setState(() {
//               _localRenderer.srcObject = _localStreamScreenShare;
//             });
//           });
//         } else {
//           _localStreamScreenShare.getTracks().forEach((track) {
//             pc.addTrack(track, _localStreamScreenShare);
//           });
//         }
//
//
//         widget.isScreenSharing = true;
//       });
//     } else {
//       setState(() {
//         pc.removeStream(_localStreamScreenShare).then((value) {
//           setState(() {
//             _localRenderer.srcObject = null;
//           });
//         });
//         widget.isScreenSharing = false;
//       });
//     }
//   }
//
//   void handleCameraToggle() async {
//     setState(() {
//       widget.containsVideo = !widget.containsVideo;
//     });
//     if (widget.isCameraShowing == false && widget.containsVideo == true &&
//         _localStreamVideo == null) {
//       final Map<String, dynamic> mediaConstraintsScreen = {
//         'audio': false,
//         'video': {
//           'minWidth': 640,
//           'minHeight':480
//         }
//       };
//       MediaStream newStream = await navigator.mediaDevices.getUserMedia(
//           mediaConstraintsScreen);
//       setState(() {
//         _localStreamVideo = newStream;
//         if (widget.isScreenSharing == true) {
//           pc.removeStream(_localStreamScreenShare).then((value) {
//             widget.isScreenSharing = false;
//             setState(() {
//               _localRenderer.srcObject = null;
//             });
//           });
//         }
//
//         if (kIsWeb) {
//           pc.addStream(_localStreamVideo).then((value) {
//             setState(() {
//               _localRenderer.srcObject = _localStreamVideo;
//             });
//           });
//         } else {
//           _localStreamVideo.getTracks().forEach((track) {
//             pc.addTrack(track, _localStreamVideo);
//           });
//         }
//         widget.isCameraShowing = true;
//       });
//     } else {
//       if (kIsWeb) {
//         setState(() {
//           pc.removeStream(_localStreamVideo).then((value) {
//             setState(() {
//               _localRenderer.srcObject = null;
//             });
//           });
//           setState(() {
//             widget.isCameraShowing = false;
//           //  _localStreamVideo = null;
//           });
//         });
//       } else {
//         setState(() async {
//           _localStreamVideo.getTracks().forEach((track) {
//             track.stop();
//           });
//         });
//         setState(() {
//           widget.isCameraShowing = false;
//           //_localStreamVideo = null;
//         });
//       }
//     }
//   }
//
//   void lookForAnsweerNego(String id, dynamic answer) async {
//     RTCSessionDescription descriptionl = await pc.createOffer(
//         {'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//     var session = parse(descriptionl.sdp!);
//     print("cerate off");
//     print(json.encode(session));
//     _offer = true;
//
//     // print(json.encode({
//     //       'sdp': description.sdp.toString(),
//     //       'type': description.type.toString(),
//     //     }));
//     //FirebaseFirestore.instance.collection(widget.ownID).add(session);
//     // print("writing my own des");
//
//     await pc.setLocalDescription(descriptionl);
//     // await FirebaseFirestore.instance.collection("rooms").doc(room).set({
//     //   'roolId': room,
//     //   'offer': {
//     //     "type": description.type,
//     //     "sdp": description.sdp,
//     //   }
//     // });
//
//
//     dynamic ss = answer;
//     setState(() {
//       widget.appbart = "gdr " + ss["type"];
//     });
//     RTCSessionDescription description = new RTCSessionDescription(
//         ss["sdp"], ss["type"]);
//
//     print("my suspect");
//     print(description.toMap());
//     print("my suspect ends");
//     setState(() {
//       widget.appbart = widget.appbart + ss["type"];
//     });
//     pc.setRemoteDescription(description);
//     setState(() {
//       widget.appbart = "reached fbinish ";
//     });
//   }
//
//   void lookForAnsweerNegoRev(String id, dynamic offer) async {
//     dynamic ss = offer;
//     setState(() {
//       widget.appbart = "gdr " + ss["type"];
//     });
//     RTCSessionDescription description = new RTCSessionDescription(
//         ss["sdp"], ss["type"]);
//
//     print("my suspect");
//     print(description.toMap());
//     print("my suspect ends");
//     setState(() {
//       widget.appbart = widget.appbart + ss["type"];
//     });
//     // await  pc.setLocalDescription(null);
//     await pc.setRemoteDescription(description);
//
//
//     RTCSessionDescription descriptionl = await pc.createOffer(
//         {'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//
//     var session = parse(descriptionl.sdp!);
//     print("cerate off");
//     print(json.encode(session));
//     _offer = true;
//
//     // print(json.encode({
//     //       'sdp': description.sdp.toString(),
//     //       'type': description.type.toString(),
//     //     }));
//     //FirebaseFirestore.instance.collection(widget.ownID).add(session);
//     // print("writing my own des");
//
//     //await pc.setLocalDescription(descriptionl);
//     // await FirebaseFirestore.instance.collection("rooms").doc(room).set({
//     //   'roolId': room,
//     //   'offer': {
//     //     "type": description.type,
//     //     "sdp": description.sdp,
//     //   }
//     // });
//
//
//     setState(() {
//       widget.appbart = "reached fbinish ";
//     });
//   }
//
//   void reNego() {
//     if (widget.isCaller) {
//       _createOfferNego(widget.room);
//     } else {
//       // MakeNewANswerNego(widget.room);
//     }
//   }
//
//   void startCallStartedCount() {
//     if(mounted){
//       setState(() {
//         widget.hasCountDownStartedOnce = true ;
//         widget.didOpositConnected = true;
//       });
//
//       widget.callStartedNotify();
//       Timer.periodic(Duration(milliseconds: 1000), (timer) {
//         if (mounted) {
//           setState(() {
//             widget.callDurationSecond = widget.callDurationSecond + 1;
//             String se = widget.callDurationSecond < 10 ? "0" +
//                 widget.callDurationSecond.toString() : widget.callDurationSecond
//                 .toString();
//             if (widget.callDurationSecond < 60) {
//               widget.callDuration = "00:" + widget.callDurationSecond.toString();
//             } else {
//               int minutes = (widget.callDurationSecond / 60).truncate();
//               String minutesStr = (minutes % 60).toString().padLeft(2, '0');
//
//               //   int  minute =int.parse(( widget.callDurationSecond/60).toString());
//               int second = widget.callDurationSecond % 60;
//               String se = second < 10 ? "0" + second.toString() : second
//                   .toString();
//               widget.callDuration = minutesStr + ":" + se;
//             }
//           });
//         } else {
//           timer.cancel();
//         }
//       });
//     }
//
//   }
//
//   void renegoCaller() {
//     try {
//       widget.socket.on("answerN"+widget.ownID, (data) async{
//
//         dynamic ss =data;
//         setState(() {
//           widget.appbart = "gdr " + ss["type"];
//         });
//         RTCSessionDescription description =
//         new RTCSessionDescription(ss["sdp"], ss["type"]);
//         await pc.setRemoteDescription(description);
//
//         RTCSessionDescription descriptionL = await pc
//             .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//         await pc.setLocalDescription(descriptionL);
//
//         widget.socket.emit("offerN", {"id": widget.partnerid, "offer": {
//           "type": descriptionL.type,
//           "sdp": descriptionL.sdp,
//         }});
//
//
//
//
//       });
//
//
//     } catch (e) {
//
//     }
//   }
//
//   void renegoRecever() {
//     try{
//       widget.socket.on("offerN"+widget.ownID, (data) async{
//         print(data);
//
//         dynamic ss =data;
//         print("found offer");
//         RTCSessionDescription description =
//         new RTCSessionDescription(ss["sdp"], ss["type"]);
//         await pc.setRemoteDescription(description);
//         RTCSessionDescription descriptionLocal = await pc
//             .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
//         await pc.setLocalDescription(descriptionLocal);
//         widget.socket.emit("answerN", {"id": widget.partnerid, "answer": {
//           "type": descriptionLocal.type,
//           "sdp": descriptionLocal.sdp,
//         }});
//
//       });
//     }catch(e){
//
//     }
//   }
//
//
// }
//
// String makeRoomName(int one, int two) {
//   if (one > two)
//     return "" + one.toString() + "-" + two.toString();
//   else
//     return "" + two.toString() + "-" + one.toString();
// }
//
//
// class MainHomePage extends StatefulWidget {
//   @override
//   _MainHomePageState createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Row(
//           children: [
//             Container(
//               width: 300,
//               height: MediaQuery
//                   .of(context)
//                   .size
//                   .height,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
