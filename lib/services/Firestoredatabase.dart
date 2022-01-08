import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/services/restApi.dart';
import 'package:connect/utils/appConst.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:connect/services/config.dart';
import 'database.dart';
import 'package:geolocator/geolocator.dart' as gl;
int cacheCount = 0 ;
class AppFirestore {
  String projectId;
  FirebaseFirestore firestore;
  FirebaseAuth auth;


  AppFirestore({required this.projectId,required this.firestore,required this.auth});

  Future<bool> deletetest({required String id})async{
    try{
      await  firestore
          .collection("pulltest")
          .doc(id)
          .delete();
      return true;
    }catch(e){
      return false;
    }

  }
 Future<String> makeImageGridAsync({required String id,required List photoLInks,required FirebaseFirestore customerFirestore}) async {
    AppToast().show(message: "Photo Caching");
    cacheCount++;
    Uri link = Uri.parse("https://us-central1-staht-connect-322113.cloudfunctions.net/mergePhotosAndSave");
    try {
      var b = jsonEncode(<String, dynamic> {   "photoList":photoLInks,"test_id":id,"project_id":customerFirestore.app.options.projectId});
      print("Cache count "+cacheCount.toString());
   http.Response r =   await   http.post(link,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:b,);

     dynamic res = jsonDecode(r.body);
      AppToast().show(message: "IMage Grid Cached");
      return res["status"];


      // dynamic respo = jsonDecode(response.body);
      // Uint8List img = base64Decode(respo["response"]);
      // // MemoryImage mI=  MemoryImage(img);
      //
      // String fileName = projectId+"/"+id+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".png";
      //
      //
      // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);
      //
      // firebase_storage.Reference ref = storage.ref(fileName);
      //   ref.putData(img).then((val) {
      //
      //   //  await  ref.putFile(File(allPHotos[i]["imagePath"]));
      //
      //   ref.getDownloadURL().then((value) {
      //     customerFirestore
      //         .collection("pulltest")
      //         .doc(id)
      //
      //         .update({"allImageGrid": value,"gridCount":photoLInks.length}).then((x) {
      //           print("IMage Grid Cached");
      //           AppToast().show(message: "IMage Grid Cached");
      //           print(value);
      //
      //     });
      //
      //   });
      // });

      //return img;

    } catch (e) {
      return "Failed";
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return Dialog(child: Container(child:Text(e.toString()),),);
      //   },
      // );
      print(e.toString());


    }
  }
   makeImageGrid({required String id,required List photoLInks,required FirebaseFirestore customerFirestore}) async {
    AppToast().show(message: "Photo Caching");
    cacheCount++;
    Uri link = Uri.parse("https://us-central1-staht-connect-322113.cloudfunctions.net/mergePhotosAndSave");
    try {
      var b = jsonEncode(<String, dynamic> {   "photoList":photoLInks,"test_id":id,"project_id":customerFirestore.app.options.projectId});
      print("Cache count "+cacheCount.toString());
      http.post(link,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:b,);
      AppToast().show(message: "IMage Grid Cached");


      // dynamic respo = jsonDecode(response.body);
      // Uint8List img = base64Decode(respo["response"]);
      // // MemoryImage mI=  MemoryImage(img);
      //
      // String fileName = projectId+"/"+id+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".png";
      //
      //
      // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);
      //
      // firebase_storage.Reference ref = storage.ref(fileName);
      //   ref.putData(img).then((val) {
      //
      //   //  await  ref.putFile(File(allPHotos[i]["imagePath"]));
      //
      //   ref.getDownloadURL().then((value) {
      //     customerFirestore
      //         .collection("pulltest")
      //         .doc(id)
      //
      //         .update({"allImageGrid": value,"gridCount":photoLInks.length}).then((x) {
      //           print("IMage Grid Cached");
      //           AppToast().show(message: "IMage Grid Cached");
      //           print(value);
      //
      //     });
      //
      //   });
      // });

      //return img;

    } catch (e) {
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return Dialog(child: Container(child:Text(e.toString()),),);
      //   },
      // );
      print(e.toString());


    }
  }
  Future<bool> createFolders({required String name,required String parent}) async {

    try{
      var res =await firestore.collection("folders").where("created_by",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where("name",isEqualTo: name).get();

      if(res.size>0 && res.docs.length>0){
        return false;
      }else{
        var res2 = await  firestore.collection("folders").add({
          "name": name,
          "parent":parent,
          "created_at": new DateTime.now().millisecondsSinceEpoch,
          "created_by": FirebaseAuth.instance.currentUser!.uid,
        });
        return true;
      }
    }catch(e){
      print(e);
      String id = firestore.app.options.projectId;
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);

      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
      Api(firestore:firestore).addfirestoreRules(projectID: (id).trim(),);
    }




    return  Future.value(false);
    try{


      firestore.collection("folders").where("created_by",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where("name",isEqualTo: name).get().then((value) {
        if(value.size>0 && value.docs.length>0){
          return  Future.value(false);
        }else{
          return  Future.value(false);
         try{
           firestore.collection("folders").add({
             "name": name,
             "parent":parent,
             "created_at": new DateTime.now().millisecondsSinceEpoch,
             "created_by": FirebaseAuth.instance.currentUser!.uid,
           });
           return true;
         }catch(e){
           return Future.value(false);
         }
        }
      });



      //return Future.value(true);

    }catch(e){
      print("Error on creating folder");
      print(e);
      return Future.value(false);
    }

  }
  Future<bool> checkFolders({required String name,required String parent}) async {

    var res =await firestore.collection("folders").where("created_by",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where("name",isEqualTo: name).get();

    if(res.size>0 && res.docs.length>0){
      return false;
    }else{

      return true;
    }


    return  Future.value(false);
    try{


      firestore.collection("folders").where("created_by",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where("name",isEqualTo: name).get().then((value) {
        if(value.size>0 && value.docs.length>0){
          return  Future.value(false);
        }else{
          return  Future.value(false);
          try{
            firestore.collection("folders").add({
              "name": name,
              "parent":parent,
              "created_at": new DateTime.now().millisecondsSinceEpoch,
              "created_by": FirebaseAuth.instance.currentUser!.uid,
            });
            return true;
          }catch(e){
            return Future.value(false);
          }
        }
      });



      //return Future.value(true);

    }catch(e){
      print("Error on creating folder");
      print(e);
      return Future.value(false);
    }

  }
  Future<bool> renameFolders({required String name,required String parent}){
    try{

      firestore.collection("folders").doc(parent).update({"name":name});


      return Future.value(true);

    }catch(e){
      print("Error on creating folder");
      print(e);
      return Future.value(false);
    }

  }
  Stream<QuerySnapshot> getFolders({required String parentFolder}){
    try{

      if(shareAbleWithOtherMembers == false)
     return firestore
          .collection("folders")
      //  .orderBy("created_at",descending: true)
          .where("parent", isEqualTo: parentFolder,)
          .where("created_by", isEqualTo: FirebaseAuth.instance.currentUser!.uid,).
     snapshots();
      else{
        return firestore
            .collection("folders")
        //  .orderBy("created_at",descending: true)
            .where("parent", isEqualTo: parentFolder,)
            .snapshots();
      }

    }catch(e){
      print("Error on creating folder");
      print(e);
      throw(e);
    }

  }
  Stream<QuerySnapshot> getUsrsRecentAllTests(){

    if(shareAbleWithOtherMembers == false)
    return   firestore
        .collection("pulltest")
        .where("uid", isEqualTo:auth.currentUser==null?"abc": auth.currentUser!.uid)
    //.orderBy("time",descending: true)
        .snapshots();
    else{
      return   firestore
          .collection("pulltest")
          //.where("uid", isEqualTo:auth.currentUser==null?"abc": auth.currentUser!.uid)
      //.orderBy("time",descending: true)
          .snapshots();
    }

  }

  Future<void> uploadVideos(
      String testId, List allPHotos,) async {
    for (int i = 0; i < allPHotos.length; i++) {
      //imagePath

      cachWork(){

        print("storage ex");
        print("uploading in alternative main");
        String fileName = firestore.app.options.projectId+"/"+testId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".mp4";

        // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
        //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
        firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);

        firebase_storage.Reference ref = storage.ref(fileName);
        //firebase_storage.Reference ref = storage.ref(fileName);

        ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
          //await  ref.putFile(File(allPHotos[i]["imagePath"]));

          ref.getDownloadURL().then((value) {
            // String link = await ref.getDownloadURL();
            print("download link");
            // print(link);

            firestore
                .collection("pulltest")
                .doc(testId)
                .collection("attachments")
            // .add({"type": "photo", "time": allPHotos[i]["time"],"photoFile":value});
                .add({"type": "video", "time": allPHotos[i]["time"],"videoFile":value});
            AttachmentUploadedStream.getInstance().dataReload(0);
          });


        });
      }

      cachWork();
    if(false)  try {
        print("push storage");
        //stahthignirjgal





        String fileName = firestore.app.options.projectId+"/"+testId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".mp4";

        // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
        firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
        // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
        firebase_storage.Reference ref = storage.ref(fileName);




        runZoned<Future<Null>>(() async {
          ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
            // await  ref.putFile(File(allPHotos[i]["imagePath"]));
            ref.getDownloadURL().then((value) {
              // String link = await ref.getDownloadURL();
              print("download link");
              // print(link);

              firestore
                  .collection("pulltest")
                  .doc(testId)
                  .collection("attachments")
              // .add({"type": "photo", "time": allPHotos[i]["time"],"photoFile":value});
                  .add({"type": "video", "time": allPHotos[i]["time"],"videoFile":value});
            });


          });

        }, onError: (error, stackTrace) {
          cachWork();
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


      } catch (e) {
        // e.g, e.code == 'canceled'

        cachWork();

      }


      // firestore
      //     .collection("pulltest")
      //     .doc(testId)
      //     .collection("attachments")
      //     .add({"type": "photo", "time": allPHotos[i]["time"]}).then(
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
    }
  }

  Future<void> uploadPhotos(
      String testId, List allPHotos,) async {
    for (int i = 0; i < allPHotos.length; i++) {
      //imagePath
      cacheWork(){

        print("storage ex");
        print("uploading in alternative main");
        String fileName = firestore.app.options.projectId+"/"+testId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

        // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
        //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);


        firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);

        firebase_storage.Reference ref = storage.ref(fileName);
        //firebase_storage.Reference ref = storage.ref(fileName);

        ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
          //await  ref.putFile(File(allPHotos[i]["imagePath"]));

          ref.getDownloadURL().then((value) {
            // String link = await ref.getDownloadURL();
            print("download link");
            // print(link);

            firestore
                .collection("pulltest")
                .doc(testId)
                .collection("attachments")
                .add({"type": "photo", "time": allPHotos[i]["time"],"photoFile":value});
            AttachmentUploadedStream.getInstance().dataReload(0);
          });


        });

      }
      cacheWork();
    if(false)  try {
        print("push storage  x");
        //stahthignirjgal





        String fileName = firestore.app.options.projectId+"/"+testId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

        // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
        print("file name generated");



        firebase_storage.FirebaseStorage storage;
        try{
          storage = await initCustomerFireStorage(firestore.app.options.projectId);
          print("storage generated");
          if(storage!=null){
            firebase_storage.Reference ref = storage.ref(fileName);
            // firebase_storage.UploadTask task = ref.putFile(File(allPHotos[i]["imagePath"]));
            // task.onError((error, stackTrace) {
            //   print("Error found by task");
            // });
            // task.onError((error, stackTrace) print("Error found by task") => task)
            runZoned<Future<Null>>(() async {
              ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
                // await  ref.putFile(File(allPHotos[i]["imagePath"]));
                ref.getDownloadURL().then((value) {
                  // String link = await ref.getDownloadURL();
                  print("download link");
                  // print(link);

                  firestore
                      .collection("pulltest")
                      .doc(testId)
                      .collection("attachments")
                      .add({"type": "photo", "time": allPHotos[i]["time"],"photoFile":value});
                });
              });
            }, onError: (error, stackTrace) {
              print(error?.toString());
              print(stackTrace?.toString());
              print("Error found by task 1");
              cacheWork();


            });


          // try{
          //
          //
          //
          //
          // }catch(e){
          //   print("Error found by task 1");
          // }
          }
        }catch(e){
          print("storage generated exce");
          print(e);
          cacheWork();
        }
        // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);





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


      }  catch (e) {
        // e.g, e.code == 'canceled'
        cacheWork();

      }



      // firestore
      //     .collection("pulltest")
      //     .doc(testId)
      //     .collection("attachments")
      //     .add({"type": "photo", "time": allPHotos[i]["time"]}).then(
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
    }
  }
  Future<firebase_storage.FirebaseStorage> initCustomerFireStorage(String projectID) async {
    FirebaseApp app;

    try {

      firebase_storage.FirebaseStorage storage=  firebase_storage.FirebaseStorage.instanceFor(app: Firebase.app(projectID),bucket:"gs://"+projectID+".appspot.com");

      return storage;
    } catch (e) {
      print(e);
      print("error on creating fb");

      app = await Firebase.initializeApp(
          name: projectID,
          options: FirebaseOptions(
            // appId: '1:17044794633:android:9f88d16d208f63229f37d8',
            appId: Platform.isAndroid
                ?Config().defaultAppIdAndroid
                : Config().defaultAppIdIOS,
            apiKey: Config().apiKey,
            //  storageBucket:"gs://"+projectID+".appspot.com/",
            storageBucket:"gs://"+projectID+".appspot.com",
            messagingSenderId: '',
            projectId: projectID,
          ));
      firebase_storage.FirebaseStorage storage=  firebase_storage.FirebaseStorage.instanceFor(app: app,bucket:"gs://"+projectID+".appspot.com" );


      //FirebaseFirestore firestore = await FirebaseFirestore.instanceFor(app: app);
      return storage;
    }
  }

  uploadPDF({required String reportID,required File file}){
    String fileName = firestore.app.options.projectId+"/reports/"+reportID+".pdf";
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);
    firebase_storage.Reference ref = storage.ref(fileName);
    ref.putFile(file).then((val) {
      ref.getDownloadURL().then((valueLInk) {
        AppToast().show(message: "report pdf saved at "+valueLInk);
        firestore.collection("reports").doc(reportID).update({"pdfFile": valueLInk, });

      });
    });
  }
   savePullTestRecord({required int decimalPlace,required String key,required String loadMode,required String index2,required String index6,required String note,required String name,required String textAddress,
    required double maxVal,required int maxAt,required int  startedTime,required int startedTimeXVal,required int endedTime,required int testDuration,
    required bool didPassed,required int failedAT,required int lastTime,required double targetLoad,required int  durationForTest,required dynamic data3,
    required int startTime,required dynamic currentLocation,required List allPHotos,required List allvid})   {
    print("saving test");
    firestore.collection("pulltest").doc(key).set({"index2":index2,"index6":index6,"decimalPlace":decimalPlace,
      "note": note,
      "loadMode": loadMode,
      "name": name,
      "address": textAddress,
      "time": new DateTime.now().toUtc().millisecondsSinceEpoch,
      "zone": new DateTime.now().timeZoneOffset.inMinutes,
      "max": maxVal,
      "maxAt": maxAt,
      "startedLoad":startedTime,
      "startedLoadX": startedTimeXVal,
      "endedLoad": endedTime,
      "duration": testDuration,
      "didPassed": startedTime > 0 ? didPassed : false,
      "failedAt": failedAT,
      "lastTime": lastTime,
      "targetLoad": targetLoad,
      "targetDuration": durationForTest,
      //"fullDuration": widget.fullDuration,

      "uid":auth.currentUser!=null? auth.currentUser!.uid:"abc",
      "data": jsonEncode(data3),
      //"photo": jsonEncode(widget.photos),
      "location": currentLocation == null
          ? {"lat": 0, "long": 0, "alt": 0}
          : {
        "lat": currentLocation.latitude,
        "long": currentLocation.longitude,
        "alt": currentLocation.altitude
      }
    }).then((value) {




    //removed a block of saving data
    if (allPHotos.length > 0) {

      List data = allPHotos;
      List photoOnlyLIst = [];
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);

      cacheWork(String link,int time){

        print("storage ex");
        print("uploading in alternative main");
        String fileName = firestore.app.options.projectId+"/"+key+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

        // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
        //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);



        firebase_storage.Reference ref = storage.ref(fileName);
        //link



        ref.putFile(File(link)).then((val) {

          //  await  ref.putFile(File(allPHotos[i]["imagePath"]));

          ref.getDownloadURL().then((value) {
            photoOnlyLIst.add(value);
            firestore
                .collection("pulltest")
                .doc(key)
                .collection("attachments")
                .add({"type": "photo", "time": time,"photoFile":value}).then((value) {
              data.removeLast();
              if(data.length>0){
                cacheWork( allPHotos.last["imagePath"],allPHotos.last["time"]);
              }else{
                AppToast().show(message: "Now going to cache img after a new test");
                print("Now going to cache img after a new test");
                makeImageGrid(photoLInks: photoOnlyLIst,id:key,customerFirestore:firestore  );

              }
            });

          });
        });

      }
      if(allPHotos.length>0){
        int currentIndex = 0 ;

        if(data.length>0){
          cacheWork( allPHotos.last["imagePath"],allPHotos.last["time"]);
        }else{
          //makeImageGrid(photoLInks: photoOnlyLIst,id:key,customerFirestore:firestore  );
        }
      }


      for (int i = 0; i < allPHotos.length; i++) {





       // cacheWork();
       if(false) try {
          print("push storage");
          //stahthignirjgal
          String fileName = firestore.app.options.projectId+"/"+key+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

          // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";







          initCustomerFireStorage(firestore.app.options.projectId).then((value) async {


            runZoned<Future<Null>>(() async {
              firebase_storage.Reference ref = value.ref(fileName);

              ref.putFile(File(allPHotos[i]["imagePath"])).then((val) {
                // await ref.putFile(File(allPHotos[i]["imagePath"]));



                ref.getDownloadURL().then((value) {
                  firestore
                      .collection("pulltest")
                      .doc(key)
                      .collection("attachments")
                      .add({"type": "photo", "time": allPHotos[i]["time"],"photoFile":value});

                });

              });
            }, onError: (error, stackTrace) {
              print(error?.toString());
              print(stackTrace?.toString());
             // cacheWork();
            });










          });
          //firebase_storage.FirebaseStorage storage =  initCustomerFireStorage(firestore.app.options.projectId);
          // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);

          // String link =  ref.getDownloadURL();
          // print("download link");
          // print(link);






        }  catch (e) {
          // e.g, e.code == 'canceled'


         // cacheWork();


        }










        // firestore
        //     .collection("pulltest")
        //     .doc(key)
        //     .collection("attachments")
        //     .add({
        //   "type": "photo",
        //   "time": allPHotos[i]["time"] - startTime
        // }).then((valueofAttachmentId) {
        //   //showMessage(context, allPHotos[i].length.toString());
        //   List imagePartsStack = [];
        //   for (int j = 0; j < allPHotos[i]["image"].length; j++) {
        //     imagePartsStack.add(allPHotos[i]["image"][j]);
        //   }
        //   int index = 0;
        //   pushData() {
        //     firestore.collection("attachmentparts").add({
        //       "data": imagePartsStack.last,
        //       "id": valueofAttachmentId.id,
        //       "index": index
        //     }).then((valueofattachmentpost) {
        //       index++;
        //       imagePartsStack.removeLast();
        //       if (imagePartsStack.isNotEmpty)
        //         pushData();
        //       else {
        //         if (i == (allPHotos.length - 1)) {
        //
        //         }
        //       }
        //     });
        //   }
        //
        //   if (imagePartsStack.length > 0) {
        //     pushData();
        //   }
        // });
      }
    }else{
      print("no photo");
    }
    if (allvid.length > 0) {
      List data= allvid;
      print("video size came "+allvid.length.toString());
      cachWork(String link,int time){
        print("storage ex");
        print("uploading in alternative main");






        String fileName = firestore.app.options.projectId+"/"+key+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".mp4";
        firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: storageBucket,app: Firebase.apps.first);

        firebase_storage.Reference ref = storage.ref(fileName);
        ref.putFile(File(link)).then((val) {
          // await ref.putFile(File(allPHotos[i]["videoPath"]));


          ref.getDownloadURL().then((value) {
            firestore
                .collection("pulltest")
                .doc(key)
                .collection("attachments")
                .add({"type": "video", "time": time,"videoFile":value}).then((value) {
              data.removeLast();
               if(data.length>0){
                 cachWork(allvid.last["videoPath"], allvid.last["time"]);
               }
            });
          });
        });
      }


      if(data.length>0){

        cachWork(allvid.last["videoPath"], allvid.last["time"]);

      }
      for (int i = 0; i < allvid.length; i++) {


        //cachWork();

  if(false)      try {
          print("push storage");
          //stahthignirjgal





          String fileName = firestore.app.options.projectId+"/"+key+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".mp4";



          runZoned<Future<Null>>(() async {
            initCustomerFireStorage(firestore.app.options.projectId).then((value) async {
              firebase_storage.Reference ref = value.ref(fileName);

              ref.putFile(File(allvid[i]["videoPath"])).then((val) {
                // await ref.putFile(File(allvid[i]["videoPath"]));
                ref.getDownloadURL().then((value) {
                  firestore
                      .collection("pulltest")
                      .doc(key)
                      .collection("attachments")
                      .add({"type": "video", "time": allvid[i]["time"],"videoFile":value});
                });
              });


            });
          }, onError: (error, stackTrace) {
            print(error?.toString());
            print(stackTrace?.toString());
            //cachWork();
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


        } catch (e) {

         // cachWork();




        }




























        //
        // firestore
        //     .collection("pulltest")
        //     .doc(key)
        //     .collection("attachments")
        //     .add({
        //   "type": "video",
        //   "time": allvid[i]["time"] - startTime
        // }).then((valueofAttachmentId) {
        //   //showMessage(context, allPHotos[i].length.toString());
        //   List imagePartsStack = [];
        //   for (int j = 0; j < allvid[i]["video"].length; j++) {
        //     imagePartsStack.add(allvid[i]["video"][j]);
        //   }
        //   int index = 0;
        //   pushData() {
        //     print("pushing video parts");
        //     firestore.collection("attachmentparts").add({
        //       "data": imagePartsStack.last,
        //       "id": valueofAttachmentId.id,
        //       "index": index
        //     }).then((valueofattachmentpost) {
        //       index++;
        //       imagePartsStack.removeLast();
        //       if (imagePartsStack.isNotEmpty)
        //         pushData();
        //       else {
        //         if (i == (allvid.length - 1)) {
        //
        //         }
        //       }
        //     });
        //   }
        //
        //   if (imagePartsStack.length > 0) {
        //     pushData();
        //   }
        // });
      }
    }else{
      print("no video");
    }
    });

   // for (int i = 0; i < allvid.length; i++) {
   //   firestore
   //       .collection("pulltest")
   //       .doc(key)
   //       .collection("attachments")
   //       .add({"type": "video", "time": allvid[i]["time"]}).then(
   //           (valueofAttachmentId) {
   //         //showMessage(context, allPHotos[i].length.toString());
   //         List imagePartsStack = [];
   //         for (int j = 0; j < allvid[i]["video"].length; j++) {
   //           imagePartsStack.add(allvid[i]["video"][j]);
   //         }
   //         int index = 0;
   //         pushData() {
   //           firestore.collection("attachmentparts").add({
   //             "data": imagePartsStack.last,
   //             "id": valueofAttachmentId.id,
   //             "index": index
   //           }).then((valueofattachmentpost) {
   //             index++;
   //             imagePartsStack.removeLast();
   //             if (imagePartsStack.isNotEmpty)
   //               pushData();
   //             else {
   //               if (i == (allvid.length - 1)) {
   //                 return;
   //
   //                 // setState(() {
   //                 //   widget.data3.clear();
   //                 //   widget.data2.clear();
   //                 //   widget.photos.clear();
   //                 // });
   //
   //               }
   //             }
   //           });
   //         }
   //
   //         if (imagePartsStack.length > 0) {
   //           pushData();
   //         }
   //       });
   // }
    //add video



  }



 Future<QuerySnapshot<Map<String, dynamic>>>getCurrentUserInfo(){
    return firestore.collection("users").where("uid", isEqualTo: auth.currentUser!.uid).get();
  }

  Stream<QuerySnapshot> fetchCustomerUsersAllAttachmentStream(
      { required String testID})  {
    Stream<QuerySnapshot> getData()  {
      return firestore
          .collection("pulltest")
          .doc(testID)
          .collection("attachments")
          .snapshots();
    }

    try {

      return getData();
      //return data;
    } catch (e) {


      return getData();

      // return data;
    }
  }

  Future<QuerySnapshot> fetchCustomerUsersAllAttachmentFuture(
      { required String testID})  {
    Future<QuerySnapshot> getData()  {
      return firestore
          .collection("pulltest")
          .doc(testID)
          .collection("attachments")
          .get();
    }

    try {

      return getData();
      //return data;
    } catch (e) {


      return getData();

      // return data;
    }
  }

   DeleteCustomerUsersAllAttachmentStream(
      { required String testID,required String photoID,})  {
     getData()  {
       firestore
          .collection("pulltest")
          .doc(testID)
          .collection("attachments").doc(photoID).delete();
    }

    try {

       getData();
      //return data;
    } catch (e) {


       getData();

      // return data;
    }
  }



  Future<List> fetchAttachmentAllParts(
      { required String attachmentId}) async {
    Future<List> getData() async {
      //firestore.collection("tenants").add({"uid":a.user.uid,"tenant":parentTenant});
      QuerySnapshot querySnapshot = await firestore
          .collection("attachmentparts")
          .where("id", isEqualTo: attachmentId)
          .get();
      print("parts count "+querySnapshot.docs.length.toString());
      List allData = [];

      for(int i = 0 ; i < querySnapshot.docs.length;i++){
        allData.add("empty");
      }
      for(int i = 0 ; i < querySnapshot.docs.length;i++){
        allData[querySnapshot.docs[i].get("index")] =  querySnapshot.docs[i].get("data");
        // allData.insert(querySnapshot.docs[i].get("index"), querySnapshot.docs[i].get("data"));
      }
      return allData;
    }

    try {

      List data = await getData();
      return data;
    } catch (e) {


      List data = await getData();

      return data;
    }
  }
}
