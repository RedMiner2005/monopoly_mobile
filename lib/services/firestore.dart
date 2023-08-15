import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:monopoly_mobile/models/player.dart';


class DatabaseService {
  DatabaseService();

  // Collection Reference
  final CollectionReference playersCollection = FirebaseFirestore.instance.collection("players");
  final CollectionReference _transactionsCollection = FirebaseFirestore.instance.collection("transactions");

  // Custom model from snapshot
  Iterable<Player> _playerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return _playerFromSnapshot(e);
    });
  }

  Player _playerFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return Player(
        cardId: snapshot.id,
        token: data!["token"] ?? "",
        money: data["money"] ?? "",
        properties: data["properties"]
    );
  }

  void clearPlayers() {
    playersCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  Future<bool> doesExist(Player player) async {
    DocumentSnapshot snapshot = await playersCollection.doc(player.cardId).get();
    return snapshot.exists;
  }

  Future createPlayer(Player player) async {
    return await playersCollection.doc(player.cardId).set({
      "cardId": player.cardId,
      "token": player.token,
      "money": player.money,
      "properties": player.properties
    });
  }

  Future<Player> getPlayer(String id) async {
    return await playersCollection.doc(id).get().then(_playerFromSnapshot);
  }

  Future updatePlayer(Player player) async {
    if (!(await doesExist(player))) {
      return await createPlayer(player);
    }
    return await playersCollection.doc(player.cardId).set({
      "cardId": player.cardId,
      "token": player.token,
      "money": player.money,
      "properties": player.properties
    });
  }

  Future getNumberOfPlayers() async {
    QuerySnapshot docs = await playersCollection.get();
    return docs.docs.length;
  }

  Future<bool> incrementMoney(String playerId, int amount) async {
    try {
      Player player = await getPlayer(playerId);
      player.money += amount;
      updatePlayer(player);
      return true;
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future transferMoney(String playerFromId, String playerToId, int amount) async {
    try {
      Player playerFrom = await getPlayer(playerFromId);
      Player playerTo = await getPlayer(playerToId);
      playerFrom.money -= amount;
      playerTo.money += amount;
      updatePlayer(playerFrom);
      updatePlayer(playerTo);
      return true;
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Get Stream
  Stream<QuerySnapshot<Map<String, dynamic>>> get players {
    return playersCollection.snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Stream<Iterable<Player>> get playersList {
    return playersCollection.snapshots().map(_playerListFromSnapshot);
  }

  // // Get Current User Data
  // Stream<Player> get player {
  //   return playersCollection.doc(uid).snapshots().map(_playerFromSnapshot);
  // }

  Future<Map<String, dynamic>> getPlayerData(Player player) async {
    return (await playersCollection.doc(player.cardId).get()).data() as Map<String, dynamic>;
  }

  // Future<Error> transactReceive(String cardID, double amount, int pin) async {
  //   try {
  //     QueryDocumentSnapshot values = (await playersCollection.where("cardID", isEqualTo: cardID).get()).docs[0];
  //     String senderID = values.id;
  //     print(senderID);
  //     if(values.data()["pin"] != pin) {
  //       throw IncorrectPinException();
  //     }
  //     double senderBalance = values.data()["balance"].toDouble();
  //     if (senderBalance < amount) {
  //       throw LowAccountBalanceException();
  //     }
  //     double receiverBalance = (await playersCollection.doc(uid).get()).data()["balance"].toDouble();
  //     _transactionsCollection.doc().set({"amount": amount, "datetime": DateTime.now(), "from": senderID, "to": uid});
  //     playersCollection.doc(senderID).update({"balance": senderBalance - amount});
  //     playersCollection.doc(uid).update({"balance": receiverBalance + amount});
  //     return null;
  //   } catch(e) {
  //     return await e;
  //   }
  // }
}
