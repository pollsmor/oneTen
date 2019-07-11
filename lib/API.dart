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

class Run {
  int place;
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
