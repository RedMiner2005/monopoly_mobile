import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_mobile/constants.dart';
import 'package:monopoly_mobile/services/firestore.dart';
import 'package:monopoly_mobile/models/player.dart';

import '../main.dart';

class Register extends StatefulWidget {
  DatabaseService dbService;
  Function navigate;
  Function changeTheme;
  Function eventMessage;
  Register({super.key, required this.dbService, required this.navigate, required this.changeTheme, required this.eventMessage});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  Future<String?> _getToken(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select a Token:'),
            children: tokenNames.map((e) => SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, e.toLowerCase());
              },
              child: Text(e),
            )).toList(),
          );
        });
  }

  @override
  initState() {
    super.initState();
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
              children: [
                _colDivider,
                _colDivider,
                SizedBox(
                  height: 400,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: widget.dbService.players,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          int length = snapshot.data!.docs.length;
                          return ListView.builder(
                              itemCount: length,
                              itemBuilder: (context, index) {
                                Player player = Player.fromMap(snapshot.data!.docs[index]);
                                return InkWell(
                                  key: Key(index.toString()),
                                  onTap: () {
                                    _getToken(context).then((String? token) {
                                      player.token = token!;
                                      widget.dbService.updatePlayer(player);
                                    });
                                  },
                                  child: Card(
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
                                  ),
                                );
                              });
                        } else {
                          return const Text("No data");
                        }
                      }),
                ),
                InkWell(
                key: const Key("Add"),
                onTap: () {
                  widget.dbService.getNumberOfPlayers().then((value) {
                    if(value < 4) {
                      widget.navigate(1, [2, (id) {
                        Player pl = Player(cardId: id, token: "hat", money: 1500, properties: []);
                        widget.dbService.doesExist(pl).then((exists) {
                          if (exists) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text("Already Registered"),
                                  content: Text("Please use another card."),
                                );
                              },
                            );
                          } else {
                            widget.dbService.createPlayer(pl);
                          }
                        });
                      }]);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text("Too Many Players"),
                            content: Text("Only 4 players are allowed"),
                          );
                        },
                      );
                    }
                  });
                },
                child: Card(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                  child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Theme.of(context).colorScheme.primaryContainer
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: SizedBox(
                                    height: 70.0,
                                    width: 70.0,
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                )
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Add New",
                                style: TextStyle(
                                    fontSize: 28
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),
                InkWell(
                  key: const Key("Done"),
                  onTap: () {
                    widget.dbService.getNumberOfPlayers().then((value) {
                      if(value > 1 ) {
                        widget.navigate(0, []);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Not Enough Players"),
                              content: Text("Please add at least 2 players."),
                            );
                          },
                        );
                      }
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).colorScheme.primaryContainer
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: SizedBox(
                                      height: 70.0,
                                      width: 70.0,
                                      child: Icon(
                                        Icons.done_rounded,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer
                                      ),
                                    ),
                                  )
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                      fontSize: 28
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
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


