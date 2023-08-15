import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_mobile/services/firestore.dart';
import 'package:monopoly_mobile/models/player.dart';
import 'package:monopoly_mobile/util.dart';

import '../main.dart';

class Home extends StatefulWidget {
  DatabaseService dbService;
  Function navigate;
  Function changeTheme;
  Function eventMsg;
  Home({super.key, required this.dbService, required this.navigate, required this.changeTheme, required this.eventMsg});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.changeTheme(themeColor);
      widget.dbService.getNumberOfPlayers().then((value) {
        if (value == 0) {
          widget.changeTheme(Colors.amber);
          widget.navigate(2, []);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: _maxWidthConstraint,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _colDivider,
                _colDivider,
                SizedBox(
                  height: 500,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: widget.dbService.players,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        int length = snapshot.data!.docs.length;
                        return ListView.builder(
                            itemCount: length,
                            itemBuilder: (context, index) {
                              Player player = Player.fromMap(snapshot.data!.docs[index]);
                              return Card(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),//or 15.0
                                          child: SizedBox(
                                            height: 70.0,
                                            width: 70.0,
                                            child: Image.asset('assets/tokens/${player.token}.jpg'),
                                          ),
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            "\$${player.money}",
                                          style: const TextStyle(
                                            fontSize: 28
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              );
                            });
                      } else {
                        return const Text("No data");
                      }
                  }),
                ),
                _colDivider,


              // Row of buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FloatingActionButton.large(
                      onPressed: () {
                        widget.eventMsg("Detect Card");
                        // widget.navigate(1, [0, (id) {
                        //   eventMessage(context, "Detected: $id")!();
                        // }]);
                      },
                      child: const Icon(Icons.tap_and_play_rounded),
                    ),
                    FloatingActionButton.large(
                      onPressed: () {
                        widget.navigate(1, [0, (id) {
                          widget.dbService.incrementMoney(id, -50).then((value) {
                            if(value) {
                              widget.eventMsg("Bail granted.");
                            } else {
                              widget.eventMsg("An error has occurred.");
                            }
                          });
                        }]);
                      },
                      child: const Icon(Icons.local_police_rounded),
                    ),
                    FloatingActionButton.large(
                      onPressed: () {
                        widget.navigate(3, []);
                      },
                      child: const Icon(Icons.dashboard_rounded),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _rowDivider = SizedBox(width: 10);
const _colDivider = SizedBox(height: 10);
const double _maxWidthConstraint = 400;


