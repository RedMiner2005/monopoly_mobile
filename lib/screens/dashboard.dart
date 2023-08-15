import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_mobile/constants.dart';
import 'package:monopoly_mobile/services/firestore.dart';
import 'package:monopoly_mobile/models/player.dart';

import '../main.dart';

class Dashboard extends StatefulWidget {
  DatabaseService dbService;
  Function navigate;
  Function changeTheme;
  Function eventMsg;
  Dashboard({super.key, required this.dbService, required this.navigate, required this.changeTheme, required this.eventMsg});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _dialogController = TextEditingController();

  Future<void> _getNumber(BuildContext context, String message, Function then) async {
    var alert = AlertDialog(
      title: Text(message),
      content: TextField(
        maxLines: 1,
        autofocus: true,
        enabled: true,
        onSubmitted: (String text) {
          int number = int.parse(text);
          then(number);
        },
        controller: _dialogController,
      )
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
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
                Option(
                  icon: Icons.arrow_right_alt_rounded,
                  foreground: Colors.white,
                  background: Colors.amber,
                  label: "Pass Go",
                  onPressed: () {
                  widget.navigate(1, [0, (id) {
                    widget.dbService.incrementMoney(id, 200).then((value) {
                      if(value) {
                        widget.eventMsg("Salary paid.");
                      } else {
                        widget.eventMsg("An error has occurred.");
                      }
                    });
                  }]);
                },
                ),
                _colDivider,
                Option(
                  icon: Icons.monetization_on_rounded,
                  foreground: Colors.white,
                  background: Colors.pink,
                  label: "Income Tax",
                  onPressed: () {
                    widget.navigate(1, [0, (id) {
                      widget.dbService.incrementMoney(id, -200).then((value) {
                        if(value) {
                          widget.eventMsg("Income tax deducted.");
                        } else {
                          widget.eventMsg("An error has occurred.");
                        }
                      });
                    }]);
                  },
                ),
                _colDivider,
                Option(
                  icon: Icons.money_rounded,
                  foreground: Colors.white,
                  background: Colors.pinkAccent,
                  label: "Super Tax",
                  onPressed: () {
                    widget.navigate(1, [0, (id) {
                      widget.dbService.incrementMoney(id, -100).then((value) {
                        if(value) {
                          widget.eventMsg("Super tax deducted.");
                        } else {
                          widget.eventMsg("An error has occurred.");
                        }
                      });
                    }]);
                  },
                ),
                _colDivider,
                Option(
                  icon: Icons.money_rounded,
                  foreground: Colors.white,
                  background: Colors.green,
                  label: "Rent",
                  onPressed: () {
                    _getNumber(context, "Enter amount:", (number) {
                      widget.changeTheme(Colors.red);
                      widget.navigate(1, [0, (fromId) {
                        widget.changeTheme(Colors.green);
                        widget.navigate(1, [0, (toId) {
                          widget.dbService.transferMoney(fromId, toId, number).then((value) {
                            if(value) {
                              widget.eventMsg("Rent \$$number transferred.");
                            } else {
                              widget.eventMsg("An error has occurred.");
                            }
                          });
                        }]);
                      }]);
                    });

                  },
                ),
                _colDivider,
                Option(
                  icon: Icons.money_rounded,
                  foreground: Colors.white,
                  background: Colors.brown,
                  label: "Pay Bank",
                  onPressed: () {
                    _getNumber(context, "Enter amount:", (number) {
                      widget.navigate(1, [0, (id) {
                        widget.dbService.incrementMoney(id, -number).then((value) {
                          if(value) {
                            widget.eventMsg("Paid bank \$$number.");
                          } else {
                            widget.eventMsg("An error has occurred.");
                          }
                        });
                      }]);
                    });
                  },
                ),
                _colDivider,
                Option(
                  icon: Icons.money_rounded,
                  foreground: Colors.white,
                  background: Colors.brown,
                  label: "Collect from Bank",
                  onPressed: () {
                    _getNumber(context, "Enter amount:", (number) {
                      widget.navigate(1, [0, (id) {
                        widget.dbService.incrementMoney(id, number).then((value) {
                          if(value) {
                            widget.eventMsg("Collected from bank: \$$number.");
                          } else {
                            widget.eventMsg("An error has occurred.");
                          }
                        });
                      }]);
                    });
                  },
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

class Option extends StatelessWidget {
  IconData icon;
  Color foreground;
  Color background;
  String label;
  dynamic onPressed;
  Option({Key? key,
    required this.icon, required this.foreground, required this.background,
    required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(
        icon,
        color: foreground,
        size: 32,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 28,
          color: foreground,
        ),
      ),
      backgroundColor: background,
      onPressed: onPressed,
    );
  }
}

