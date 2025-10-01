class AdminAgentModel {
  int id;
  String name;
  String phone;
  String location;
  int sawa;
  String? note;
  DateTime createdAt;

  AdminAgentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.sawa,
    this.note,
    required this.createdAt,
  });

  factory AdminAgentModel.fromJson(Map<String, dynamic> json) {
    return AdminAgentModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      location: json["location"],
      sawa: json["sawa"],
      note: json["note"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "location": location,
      "sawa": sawa,
      "note": note,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
