import "dart:convert";
import "package:http/http.dart" as http;

final String baseurl = "https://www.speedrun.com/api/v1";

class LatestRun {
  Game game;
  Category category;
  Player player;
  String date;
  String realtime;
  String igt;

  LatestRun(
      {this.game,
      this.category,
      this.player,
      this.date,
      this.realtime,
      this.igt});

  factory LatestRun.fromJson(Map<String, dynamic> json) {
    //Convert time string
    double realtimeSecs = json["times"]["realtime_t"].toDouble();
    double igtSecs = json["times"]["ingame_t"].toDouble();

    return LatestRun(
      game: Game.fromJson(json["game"]["data"]),
      category: Category.fromJson(json["category"]["data"]),
      player: Player.fromJson(json["players"]["data"][0]),
      date: json["date"],
      realtime: calcTime(realtimeSecs),
      igt: calcTime(igtSecs),
    );
  }
}

Future<List<LatestRun>> getLatestRuns() async {
  final response = await http.get(baseurl +
      "/runs?status=verified&orderby=verify-date&direction=desc&embed=game,category,players,platform,region");

  if (response.statusCode == 200) {
    var list = json.decode(response.body)["data"] as List;

    return list.map((i) => LatestRun.fromJson(i)).toList();
  }

  throw Exception("Failed to load the latest runs.");
}

String calcTime(double seconds) {
  int hours, mins, secs;
  int ms = 0;

  hours = seconds ~/ 3600;
  mins = (seconds % 3600) ~/ 60;
  secs = ((seconds % 3600) % 60).toInt();

  if (secs != 0) ms = ((((seconds % 3600) % 60) % secs) * 1000).toInt();

  String output = "";

  if (hours == 0) {
    if (mins == 0) {
      if (ms == 0)
        output = "$secs secs";
      else
        output = "$secs secs $ms ms";
    } else {
      if (ms == 0) {
        output = "$mins mins $secs secs";
      } else {
        output = "$mins mins $secs secs $ms ms";
      }
    }
  } else {
    output = "$hours hrs $mins mins $secs secs";
  }

  return output;
}

class Game {
  String name;
  String abbreviation;
  String releaseDate;
  String coverURL;
  String level;
  bool verification;
  bool requireVideo;
  bool isRTA;
  bool emuAllowed;
  List<Player> moderators;
  String trophy1st;
  String trophy2nd;
  String trophy3rd;

  Game({this.name, this.abbreviation, this.releaseDate, this.coverURL});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json["names"]["international"],
      abbreviation: json["abbreviation"],
      releaseDate: json["release-date"],
      coverURL: json["assets"]["cover-large"]["uri"],
    );
  }
}

class Category {
  String name;
  String rules;

  Category({this.name, this.rules});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json["name"],
      rules: json["rules"],
    );
  }
}

class Player {
  String name;
  String color;
  String country;

  Player({this.name, this.color, this.country});

  factory Player.fromJson(Map<String, dynamic> json) {
    String player = "";
    if (json["names"] != null) {
      player = json["names"]["international"];
    }

    String color = "";
    if (json["name-style"]["style"] == "gradient") {
      color = json["name-style"]["color-from"]["light"];
    } else {
      color = json["name-style"]["color"]["light"];
    }

    String country = "";
    if (json["location"] != null) {
      country = json["location"]["country"]["names"]["international"];
    }

    return Player(
      name: player,
      color: color,
      country: country,
    );
  }
}

class LeaderboardRun {
  Game game;
  Category category;
  List<Player> players;
  int place;
  String comment;
  String date;
  String realtime;
  String igt;
  List<String> videoLinks;
  String verifyDate;
  String region;
  String platform;
  String yearPlatform;

  LeaderboardRun(
      {this.game,
      this.category,
      this.player,
      this.place,
      this.comment,
      this.date,
      this.realtime,
      this.igt});

  factory LeaderboardRun.fromJson(Map<String, dynamic> json) {
    //Convert time string
    double realtimeSecs = json["times"]["realtime_t"].toDouble();
    double igtSecs = json["times"]["ingame_t"].toDouble();

    return LeaderboardRun(
      game: Game.fromJson(json["game"]["data"]),
      category: Category.fromJson(json["category"]["data"]),
      player: Player.fromJson(json["players"]["data"][0]),
      date: json["date"],
      realtime: calcTime(realtimeSecs),
      igt: calcTime(igtSecs),
    );
  }
}

class Leaderboard {
  List<LeaderboardRun> runs;

  Leaderboard({this.runs});

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    var list = json["data"]["runs"] as List;
    List<LeaderboardRun> runsList =
        list.map((i) => LeaderboardRun.fromJson(i)).toList();

    return Leaderboard(
      runs: runsList,
    );
  }
}
