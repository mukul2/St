import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connect/screens/home.dart';
import 'package:map_launcher/map_launcher.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/pages/canvas_graph.dart';
import 'package:connect/pages/graph_3.dart';
import 'package:connect/screens/video_play.dart';
import 'package:connect/services/config.dart';
import 'package:connect/services/restApi.dart';
import 'package:connect/services/show_widgets.dart';
import 'package:connect/streams/buttonStreams.dart';

import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'graph_with_selecttor.dart';
import 'package:connect/widgets/ChartDataModel.dart';

Widget horizontal_image_list(List<Map<String, dynamic>> photos) {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      shrinkWrap: true,
      itemCount: photos.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              child: Image.file(
            File(photos[index]["imagePath"]),
            fit: BoxFit.cover,
          )),
        );
      });
}

Widget horizontal_video_thumbnail_list(List photos) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: photos.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            color: Colors.grey,
            width: 50,
            height: 50,
            child: Center(
              child: Icon(Icons.play_arrow),
            )),
      );
    },
  );

  return ListView.builder(
      scrollDirection: Axis.horizontal,
      //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      shrinkWrap: true,
      itemCount: photos.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              child: Image.file(
            File(photos[index]["imagePath"]),
            fit: BoxFit.cover,
          )),
        );
      });
}

Future<firebase_storage.FirebaseStorage> initCustomerFireStorage(String projectID) async {
  FirebaseApp app;

  try {
    app = await Firebase.initializeApp(
        name: projectID,
        options: FirebaseOptions(
          // appId: '1:17044794633:android:9f88d16d208f63229f37d8',
          appId: Platform.isAndroid
              ?Config().defaultAppIdAndroid
              : Config().defaultAppIdIOS,
          apiKey: Config().apiKey,
          //  storageBucket:"gs://"+projectID+".appspot.com/",
          storageBucket:projectID,

          messagingSenderId: '',
          projectId: projectID,
        ));
    firebase_storage.FirebaseStorage storage=  firebase_storage.FirebaseStorage.instanceFor(app: app,bucket:projectID );

    return storage;
  } catch (e) {



    firebase_storage.FirebaseStorage storage=  firebase_storage.FirebaseStorage.instanceFor(app: Firebase.app(projectID),bucket:projectID);

    //FirebaseFirestore firestore = await FirebaseFirestore.instanceFor(app: app);
    return storage;
  }
}

Future<void> uploadVideos(
    String testId, List allPHotos, FirebaseFirestore firestore) async {
  for (int i = 0; i < allPHotos.length; i++) {
    //upload video in storage
    try {
      print("push storage");
      //stahthignirjgal





      String fileName = firestore.app.options.projectId+"/"+testId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".mp4";

     // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
      firebase_storage.FirebaseStorage storage = await initCustomerFireStorage("stahthignirjgal");
     // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
      firebase_storage.Reference ref = storage.ref(fileName);

      ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
        //await  ref.putFile(File(allPHotos[i]["imagePath"]));

        ref.getDownloadURL().then((value) {
          firestore
              .collection("pulltest")
              .doc(testId)
              .collection("attachments")
              .add({"type": "video", "time": allPHotos[i]["time"],"videoFile":value});
        });




      });




      // firestore
      //     .collection("pulltest")
      //     .doc(testId)
      //     .collection("attachments")
      //     .add({"type": "video", "time": allPHotos[i]["time"]}).then(
      //         (valueofAttachmentId) {
      //       //showMessage(context, allPHotos[i].length.toString());
      //       List imagePartsStack = [];
      //       for (int j = 0; j < allPHotos[i]["image"].length; j++) {
      //         imagePartsStack.add(allPHotos[i]["image"][j]);
      //       }
      //       int index = 0;
      //       pushData() {
      //         firestore.collection("attachmentparts").add({
      //           "data": imagePartsStack.last,
      //           "id": valueofAttachmentId.id,
      //           "index": index
      //         }).then((valueofattachmentpost) {
      //           index++;
      //           imagePartsStack.removeLast();
      //           if (imagePartsStack.isNotEmpty)
      //             pushData();
      //           else {
      //             if (i == (allPHotos.length - 1)) {
      //               return;
      //
      //               // setState(() {
      //               //   widget.data3.clear();
      //               //   widget.data2.clear();
      //               //   widget.photos.clear();
      //               // });
      //
      //             }
      //           }
      //         });
      //       }
      //
      //       if (imagePartsStack.length > 0) {
      //         pushData();
      //       }
      //     });


    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
      print("storage ex");
      print("uploading in alternative main");
      String fileName = firestore.app.options.projectId+"/"+testId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".mp4";

      // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
      //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
      //firebase_storage.Reference ref = storage.ref(fileName);
      ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
       // await  ref.putFile(File(allPHotos[i]["imagePath"]));
        ref.getDownloadURL().then((value) {
          //String link = await ref.getDownloadURL();
          print("download link");
          //print(link);

          firestore
              .collection("pulltest")
              .doc(testId)
              .collection("attachments")
              .add({"type": "video", "time": allPHotos[i]["time"],"videoFile":value});
        });


      });

    }


  }
}







class PlayVideoAutoPlay extends StatefulWidget {
  Uint8List video;
  String name;

  PlayVideoAutoPlay({required this.name, required this.video});

  @override
  _PlayVideoStateAuto createState() => _PlayVideoStateAuto();
}

class _PlayVideoStateAuto extends State<PlayVideoAutoPlay> {
late  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    intV();

    // _controller = VideoPlayerController.network(
    //     'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
    //   ..initialize().then((_) {
    //     print("inited");
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value!=null &&  _controller.value.isInitialized) {
      _controller.setLooping(true);
      _controller.setVolume(0);
    }
    return _controller.value!=null &&  _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void intV() async {
    File file = File(await getFilePath(widget.name)); // 1
    file.writeAsBytes(widget.video).then((value) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((value) {
          print("inited ");
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        });
    });
  }
}



class PlayVideoAutoPlayFromUrl extends StatefulWidget {

  String name;
  bool mute;
  bool autoPlay;

  PlayVideoAutoPlayFromUrl({required this.name,required this.mute,required this.autoPlay});

  @override
  _PlayVideoAutoPlayFromUrlAuto createState() => _PlayVideoAutoPlayFromUrlAuto();
}

class _PlayVideoAutoPlayFromUrlAuto extends State<PlayVideoAutoPlayFromUrl> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    intV();

    // _controller = VideoPlayerController.network(
    //     'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
    //   ..initialize().then((_) {
    //     print("inited");
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value!=null &&  _controller.value.isInitialized) {
      _controller.setLooping(true);
      if(widget.mute==true){
        _controller.setVolume(0);
      }

    }
    return widget.mute == false? SafeArea(child: Column(children: [

      ApplicationAppbar().getAppbar(title: "Video"),
      _controller.value!=null &&  _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(children: [
          VideoPlayer(_controller),
          Align(alignment: Alignment.bottomCenter,child: VideoProgressIndicator(_controller, allowScrubbing: true),),
          Positioned(left: 15,top: 15,child: InkWell(onTap: (){
            Navigator.pop(context);
          },child: Card(color: ThemeManager().getDarkGreenColor,elevation: 5,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),child: Container(height: 50,width: 50,child: Center(child: Icon(Icons.close,color: Colors.white,)),))) ,),

        ],),
      )
          : Container()
    ],)):_controller.value!=null &&  _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(children: [
        Align(child: VideoPlayer(_controller) ,),

        //  Align(alignment: Alignment.bottomCenter,child: VideoProgressIndicator(_controller, allowScrubbing: true),),

      ],),
    ):Container();

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void intV() async {

    _controller = VideoPlayerController.network(widget.name)
      ..initialize().then((value) async {
        print("inited ");
        setState(() {
          if(widget.mute==false){
            _controller.setVolume(0);
          }
          _controller.setLooping(true);
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      });



  }
}




Future<String> getFilePath(String fileName) async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/$fileName.mp4'; // 3

  return filePath;
}



class TimerShowWidget extends StatefulWidget {
  int duration = 0;

  @override
  _TimerShowWidgetState createState() => _TimerShowWidgetState();
}

class _TimerShowWidgetState extends State<TimerShowWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: TimerUpdateStream.getInstance().outData,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data != -1) {
            return Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.redAccent,
              child: Center(
                  child: Text(
                "Recording " + snapshot.data.toString() + " seconds",
                style: TextStyle(color: Colors.white),
              )),
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        });
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
