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
      name: json["names"]["international"],
      abbreviation: json["abbreviation"],
      releaseDate: json["release-date"],
      gameID: json["id"],
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
  bool gradient;
  String colorFromLight;
  String colorFromDark;
  String colorToLight;
  String colorToDark;

  String country; //for the flag

  Player(
      {this.name,
      this.color,
      this.gradient,
      this.colorFromLight,
      this.colorFromDark,
      this.colorToLight,
      this.colorToDark,
      this.country});

  factory Player.fromJson(Map<String, dynamic> json) {
    String country = "";
    if (json["location"] != null) {
      country = json["location"]["country"]["names"]["international"];
    }

    String player = "";
    if (json["names"] != null) {
      player = json["names"]["international"];
    }

    String color;
    bool gradient = (json["name-style"] == "gradient");
    String colorFromLight;
    String colorFromDark;
    String colorToLight;
    String colorToDark;

    if (gradient) {
      String colorFromLight = json["name-style"]["color-from"]["light"];
      String colorFromDark = json["name-style"]["color-from"]["dark"];
      String colorToLight = json["name-style"]["color-to"]["light"];
      String colorToDark = json["name-style"]["color-to"]["dark"];
    } else {
      //String color = json["name-style"]["color"];
    }

    return Player(
      name: player,
      color: color,
      gradient: gradient,
      colorFromLight: colorFromLight,
      colorFromDark: colorFromDark,
      colorToLight: colorToLight,
      colorToDark: colorToDark,
      country: country,
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
      place: json["place"],
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
