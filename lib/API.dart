import "dart:convert";
import "dart:async";
import "package:http/http.dart" as http;

Future<Leaderboard> getLeaderboard() async {
  final response = await http.get(
      "https://www.speedrun.com/api/v1/leaderboards/mzm/category/100_Normal");

  if (response.statusCode == 200)
    return Leaderboard.fromJson(json.decode(response.body));

  throw Exception("Failed to load leaderboard.");
}

Future<List<LatestRun>> getLatestRuns() async {
  final response = await http.get(
      "https://www.speedrun.com/api/v1/runs?status=verified&orderby=verify-date&direction=desc");

  List<LatestRun> latestRuns = List<LatestRun>();

  if (response.statusCode == 200) {
    var list = json.decode(response.body)["data"] as List;
    latestRuns = list.map((i) => LatestRun.fromJson(i)).toList();

    for (int i = 0; i < list.length; ++i) {
      latestRuns[i] = LatestRun.fromJson(list[i]);
      latestRuns[i].game = await getGame(latestRuns[i].gameID);
    }

    return latestRuns;
  }

  throw Exception("Failed to load the latest runs.");
}

Future<Game> getGame(String gameID) async {
  final response = await http.get("https://www.speedrun.com/api/v1/games/$gameID");

  if (response.statusCode == 200)
    return Game.fromJson(json.decode(response.body));

  throw Exception("Failed to load game.");
}

class Run {
  int place; //latest runs do not have this
  String comment;
  String date;

  Run({this.place, this.comment, this.date});

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      place: json["place"],
      comment: json["run"]["comment"],
      date: json["run"]["date"],
    );
  }
}

class LatestRun {
  String comment;
  String date;
  String gameID;
  Game game;

  LatestRun({this.comment, this.date, this.gameID});

  factory LatestRun.fromJson(Map<String, dynamic> json) {
    return LatestRun(
      comment: json["comment"],
      date: json["date"],
      gameID: json["game"],
    );
  }
}

class Game {
  String name;
  String abbreviation;
  String releaseDate;
  String gameID;
  String coverURL;

  Game(
      {this.name,
      this.abbreviation,
      this.releaseDate,
      this.gameID,
      this.coverURL});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json["data"]["names"]["international"],
      abbreviation: json["data"]["abbreviation"],
      releaseDate: json["data"]["release-date"],
      gameID: json["data"]["id"],
      coverURL: "https://www.speedrun.com/themes/" +
          json["data"]["abbreviation"] +
          "/cover-256.png",
    );
  }
}

class Leaderboard {
  List<Run> runs;

  Leaderboard({this.runs});

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    var list = json["data"]["runs"] as List;
    List<Run> runsList = list.map((i) => Run.fromJson(i)).toList();

    return Leaderboard(
      runs: runsList,
    );
  }
}
