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
  String comment;

  Run({this.comment});

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      comment: json["comment"],
    );
  }
}

class Data {
  List<Run> runs;

  Data({this.runs});

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json["runs"] as List;
    List<Run> runsList = list.map((i) => Run.fromJson(i)).toList();

    return Data(
      runs: runsList,
    );
  }
}

class Leaderboard {
  Data data;

  Leaderboard({this.data});

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      data: Data.fromJson(json["data"]),
    );
  }
}
