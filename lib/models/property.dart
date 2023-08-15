class Property {
  int id;
  int houseLevel;
  bool mortgaged;

  Property({required this.id, required this.houseLevel, required this.mortgaged});

  static Property fromMap(Map<String, dynamic> data) {
    return Property(
        id: data["id"],
        houseLevel: data["houseLevel"] ?? "",
        mortgaged: data["mortgaged"] ?? ""
    );
  }

  static List<Property> fromList(List<Map<String, dynamic>> data) {
    return data.map(Property.fromMap) as List<Property>;
  }

  dynamic getInfo(String property, Map<String, dynamic> info) {
    return info["cards"][id][property];
  }
}