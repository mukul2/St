// import 'dart:convert';
//
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// import 'Settings.dart';
//
//
//
// class AppSignal {
//
//    late IO.Socket socket;
//
//    AppSignal();
//    IO.Socket initSignal(){
//      print("sig 1");
//     if(socket==null){
//       print("sig 2");
//       //socket = IO.io(AppSettings().Signal_link);
//       print("trying with "+AppSettings().Signal_link);
//        socket = IO.io(AppSettings().Signal_link,
//           OptionBuilder()
//               //.setTransports(['websocket','polling', 'flashsocket']) // for Flutter or Dart VM
//               .setTransports(['websocket']) // for Flutter or Dart VM
//
//               .build(),);
//       socket.onConnect((_) {
//         print('connect');
//         socket.emit('msg', 'test');
//       });
//       socket.on('event', (data) => print(data));
//       socket.onDisconnect((_) => print('disconnect'));
//       socket.on('fromServer', (_) => print(_));
//       socket.on('mkl', (_) => print(_));
//
// //{transports: ['websocket', 'polling', 'flashsocket']}
//
//
//
//       //socket = IO.io('https://signal1.maulaji.com');
//       //socket = IO.io('http://localhost:3000');
//       // socket = IO.io(AppSettings().Signal_link);
//       // socket.onConnect((_) {
//       //   print("connected with "+AppSettings().Signal_link);
//       // });
//       print("returning ");
//       return socket;
//     }else{
//       print("returning  old");
//       return socket;
//     }
//
//   }
//
//
//
//
// }
