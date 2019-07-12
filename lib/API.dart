import "dart:convert";
import "package:http/http.dart" as http;

String baseurl = "https://www.speedrun.com/api/v1";

Future<List<LatestRun>> getLatestRuns() async {
  final response = await http.get(baseurl +
      "/runs?status=verified&orderby=verify-date&direction=desc&embed=game,category,players");

  List<LatestRun> latestRuns;

  if (response.statusCode == 200) {
    var list = json.decode(response.body)["data"] as List;
    latestRuns = List<LatestRun>(list.length);

    for (int i = 0; i < list.length; ++i) {
      latestRuns[i] = LatestRun.fromJson(list[i]);
    }

    return latestRuns;
  }

  throw Exception("Failed to load the latest runs.");
}

class LatestRun {
  String date;
  Game game;
  Category category;
  String hours;
  String minutes;
  String seconds;
  String millis;

  LatestRun(
      {this.date,
      this.game,
      this.category,
      this.hours,
      this.minutes,
      this.seconds,
      this.millis});

  factory LatestRun.fromJson(Map<String, dynamic> json) {
    //Convert time string
    String realtime = json["times"]["realtime"];
    String igt = json["times"]["ingame"];
    String hr, min, sec, ms;

    try {
      hr =
          realtime.substring(realtime.indexOf("PT") + 2, realtime.indexOf("H"));
      min =
          realtime.substring(realtime.indexOf("H") + 1, realtime.indexOf("M"));
      sec =
          realtime.substring(realtime.indexOf("M") + 1, realtime.indexOf("S"));
      ms = (int.parse(sec.substring(sec.indexOf("."))) * 100).toString();
    } catch (RangeError) {}

    return LatestRun(
      date: json["date"],
      game: Game.fromJson(json["game"]["data"]),
      category: Category.fromJson(json["category"]["data"]),
      hours: hr,
      minutes: min,
      seconds: sec,
      millis: ms,
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

class LeaderboardRun {
  int place;
  String comment;
  String date;

  LeaderboardRun({this.place, this.comment, this.date});

  factory LeaderboardRun.fromJson(Map<String, dynamic> json) {
    return LeaderboardRun(
      place: json["place"], //null if not on a leaderboard
      comment: json["run"]["comment"],
      date: json["run"]["date"],
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
