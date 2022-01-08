import 'package:connect/widgets/cu.dart';
import 'package:flutter/material.dart';

import 'logics.dart';

class FileExplolarUI{
  top_bar_one(){
   return Container(
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(Icons.snippet_folder_sharp),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      "Files & Folders",
                      style: TextStyle(

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
  expolar_type_selector(){
    final Map<int, Widget> logoWidgets = <int, Widget>{
      0: Padding(
        padding: EdgeInsets.all(10),
        child: Text("Recent"),
        // child: StreamBuilder<QuerySnapshot>(
        //     stream: widget.customerFirestore
        //         .collection("pulltest")
        //         .orderBy("time", descending: true)
        //         .snapshots(),
        //     //recent
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData)
        //         return Text(
        //             "Recent (" + snapshot.data.docs.length.toString() + ")");
        //       else
        //         return Text("Recent");
        //     }),
      ),
      1: Padding(
        padding: EdgeInsets.all(10),
        child: Text('All'),
      ),
      2: Padding(
        padding: EdgeInsets.all(10),
        child: Text('By Map'),
      ),
    };
    itemClickListener(int val) {
      FileExplolarLogics().fileExplolarChangeListener().dataReload(val);

      // _controller.animateTo(val, duration: Duration(milliseconds: 300), curve: Curve())

    }
    return    Padding(
        padding: EdgeInsets.all(5),
        child: CupertinoSegmentedControlDemo(
          logoWidgets: logoWidgets,
          callback: itemClickListener, selected: 0,val: 0,
        ));

  }

}