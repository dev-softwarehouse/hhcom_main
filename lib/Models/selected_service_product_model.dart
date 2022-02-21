class SelectedServiceProductModel {
  SelectedServiceProductModel({
    required this.type,
    required this.count,
    required this.name,
    required this.cost,
  });

  int type;
  int count;
  String name;
  double cost;

  factory SelectedServiceProductModel.fromMap(Map<String, dynamic> json) => SelectedServiceProductModel(
        type: json["type"],
        count: json["quantity"],
        name: json["name"],
        cost: json["cost"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "quantity": count,
        "name": name,
        "cost": cost,
      };
}
