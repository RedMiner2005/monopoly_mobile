import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_mobile/services/detector.dart';

import '../main.dart';

class InstructCard extends StatefulWidget {
  int getTo;
  Function navigate;
  Function then;
  Function eventMsg;

  InstructCard({super.key, required this.getTo, required this.navigate, required this.then, required this.eventMsg});

  @override
  State<InstructCard> createState() => _InstructCardState();
}

class _InstructCardState extends State<InstructCard> {
  String _result = "Tap Card";
  bool _return = false;

  @override
  Widget build(BuildContext context) {
    if (!_return) {
      tapReady();
    } else {
      widget.then(_result);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.navigate(widget.getTo, []);
      });
      return Container();
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.credit_card_rounded, size: 48,),
              Text(
                  _result,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    widget.navigate(widget.getTo, []);
                  },
                  child: const Text("Cancel"),
              )
            ],
          ),
        )
      ),
    );
  }

  void tapReady() async {
    detectPlayer((String cID) {
      if (kDebugMode) {
        print(cID);
      }
      switch (cID) {
        case "E404":
          {
            widget.eventMsg("Please turn on NFC in order to use this app.");
            setState(() {
              _result = "Turn on NFC, and then refresh the app to proceed.";
              _return = true;
            });
          }
          break;
        case "E408":
          {
            setState(() {
              widget.eventMsg("Your card could not be detected. Please try tapping it again.");
              tapReady();
            });
          }
          break;
        default:
          {
            if (cID.startsWith("ERROR_")) {
              setState(() {
                widget.eventMsg("An error has occurred. Please try again.");
                tapReady();
              });
            } else {
              setState(() {
                _result = cID;
                _return = true;
              });
            }
          }
          break;
      }
      setState(() {
        _result = cID;
        _return = true;
      });
    });
  }
}

