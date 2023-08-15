class Player {
  String cardId;
  String token;
  int money;
  List<dynamic> properties;

  Player({required this.cardId, required this.token, required this.money, required this.properties});

  static Player fromMap(dynamic data) {
    return Player(
        cardId: data["cardId"],
        token: data["token"] ?? "",
        money: data["money"],
        properties: data["properties"]
    );
  }
}