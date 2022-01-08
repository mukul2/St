// StreamBuilder(
// stream: FirebaseFirestore.instance
//     .collection("splash_images")
// .doc("staht_org_id")
// .snapshots(),
// builder: (BuildContext context,
//     AsyncSnapshot<DocumentSnapshot> snapshot) {
// print("data " + snapshot.data.data().toString());
// if (snapshot.connectionState ==
// ConnectionState.active) {
// if (snapshot.hasData && snapshot.data != null && snapshot.data.exists) {
// List data = [];
// if (snapshot.data.data()["data"] != null) {
// data = snapshot.data.data()["intvalue"];
// }
//
// // List<int> ins = [];
// // for(int i = 0 ;i<d.length;i++){
// //   ins.add(d[i]);
// // }
// // String u   = base64Encode(ins);
// //  return Text(d[0].toString());
// // Uint8List bytes = base64.decode(u);
// //return Image.memory(d);
// return makeImage(data)==null?Text("Image is Processing"): makeImage(data);
// //return Image.memory(u);
//
// } else {
// return const Center(
// child: Text("No Data"),
// );
// }
// } else {
// return const Center(
// child: Text("loading..."),
// );
// }
// },
// ),