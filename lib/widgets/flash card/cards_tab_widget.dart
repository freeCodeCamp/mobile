import 'package:flutter/material.dart';
import 'package:freecodecamp/service/database_service.dart';

import 'flash_card_list_widget.dart';

class CardsTabWidget extends StatefulWidget {
  final DatabaseService databaseService;

  const CardsTabWidget({Key? key, required this.databaseService})
      : super(key: key);
  @override
  _CardsTabWidgetState createState() => _CardsTabWidgetState();
}

class _CardsTabWidgetState extends State<CardsTabWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0a0a23),
          primary: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [
                Tab(text: "All"),
                Tab(text: "General"),
                Tab(text: "Code"),
                Tab(text: "Known"),
                Tab(text: "Uknown"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FlashCardListWidget(
                databaseService: widget.databaseService, type: 0),
            FlashCardListWidget(
                databaseService: widget.databaseService, type: 1),
            FlashCardListWidget(
                databaseService: widget.databaseService, type: 2),
            FlashCardListWidget(
                databaseService: widget.databaseService, type: 3),
            FlashCardListWidget(
                databaseService: widget.databaseService, type: 4),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           int? type;
        //           TextEditingController frontController =
        //               new TextEditingController();
        //           TextEditingController backController =
        //               new TextEditingController();
        //           return Dialog(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(25.0)),
        //             ),
        //             child: StatefulBuilder(
        //               builder: (BuildContext context,
        //                   void Function(void Function()) setState) {
        //                 return ListView(
        //                   shrinkWrap: true,
        //                   physics: BouncingScrollPhysics(),
        //                   children: [
        //                     SizedBox(height: 5.0),
        //                     Center(
        //                       child: Text(
        //                         "Add Card",
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.w700,
        //                           fontSize: 50.0,
        //                         ),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: TextField(
        //                         minLines: 1,
        //                         maxLines: 5,
        //                         controller: frontController,
        //                         decoration: InputDecoration(
        //                             labelText: "Enter question"),
        //                       ),
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: TextField(
        //                         minLines: 1,
        //                         maxLines: 5,
        //                         controller: backController,
        //                         decoration:
        //                             InputDecoration(labelText: "Enter answer"),
        //                       ),
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     Center(
        //                       child: DropdownButton(
        //                         hint: Text("Choose type of card"),
        //                         onChanged: (value) {
        //                           print("value: " + value.toString());
        //                           setState(() {
        //                             type = int.parse(value.toString());
        //                           });
        //                           print("type: " + type.toString());
        //                         },
        //                         value: type,
        //                         items: [
        //                           DropdownMenuItem(
        //                             child: Text('General'),
        //                             value: 1,
        //                           ),
        //                           DropdownMenuItem(
        //                             child: Text('Code'),
        //                             value: 2,
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: ElevatedButton(
        //                         onPressed: () {
        //                           if (type != null &&
        //                               frontController.text != "" &&
        //                               backController.text != "") {
        //                             widget.databaseService.insertCard(
        //                               CardModel(
        //                                 id: 0,
        //                                 type: type!,
        //                                 front: frontController.text,
        //                                 back: backController.text,
        //                                 known: false,
        //                               ),
        //                             );
        //                           }
        //                         },
        //                         child: Center(
        //                           child: Text("Add card"),
        //                         ),
        //                       ),
        //                     )
        //                   ],
        //                 );
        //               },
        //             ),
        //           );
        //         });
        //   },
        // ),
      ),
    );
  }
}
