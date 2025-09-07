import 'dart:convert';

LastFinishGame lastFinishGameFromJson(String str) => LastFinishGame.fromJson(json.decode(str));

String lastFinishGameToJson(LastFinishGame data) => json.encode(data.toJson());

class LastFinishGame {
  int roomId;
  int winnerId;
  int rewardGems;
  List<Player> players;

  LastFinishGame({
    required this.roomId,
    required this.winnerId,
    required this.rewardGems,
    required this.players,
  });

  factory LastFinishGame.fromJson(Map<String, dynamic> json) => LastFinishGame(
    roomId: json["roomId"],
    winnerId: json["winnerId"],
    rewardGems: json["rewardGems"],
    players: List<Player>.from(json["players"].map((x) => Player.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roomId": roomId,
    "winnerId": winnerId,
    "rewardGems": rewardGems,
    "players": List<dynamic>.from(players.map((x) => x.toJson())),
  };
}

class Player {
  int id;
  String name;

  Player({
    required this.id,
    required this.name,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
