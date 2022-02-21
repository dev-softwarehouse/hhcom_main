class ServiceItemModel {
  ServiceItemModel({
    this.items,
  });

  List<Item>? items;

  factory ServiceItemModel.fromMap(Map<String, dynamic> json) => ServiceItemModel(
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromMap(Map<String, dynamic>.from(x)))),
      );

  Map<String, dynamic> toMap() => {
        "items": items == null ? null : List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

class Item {
  Item({
    this.name,
    this.cost = 0,
  });

  String? name;
  double cost;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        name: json["name"] == null ? null : json["name"],
        cost: json["cost"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "cost": cost,
      };
}
