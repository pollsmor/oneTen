final String baseurl = "https://www.speedrun.com/api/v1";

class LatestRun {
  Game game;
  Category category;
  Player player;
  String date;
  String hours;
  String minutes;
  String seconds;
  String millis;

  LatestRun(
      {this.game,
      this.category,
      this.player,
      this.date,
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
      game: Game.fromJson(json["game"]["data"]),
      category: Category.fromJson(json["category"]["data"]),
      player: Player.fromJson(json["players"]["data"][0]),
      date: json["date"],
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
    }

    else {
      String color = json["name-style"]["color"];
    }

    return Player(
      name: json["names"]["international"],
      color: json["name-style"]["color-from"]["light"],
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
