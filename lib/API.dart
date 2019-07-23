import 'dart:convert';
import 'package:http/http.dart' as http;

final String baseurl = 'https://www.speedrun.com/api/v1';

String calcTime(double seconds) {
  int hours, mins, secs;
  int ms = 0;

  hours = seconds ~/ 3600;
  mins = (seconds % 3600) ~/ 60;
  secs = ((seconds % 3600) % 60).toInt();

  if (secs != 0) ms = ((((seconds % 3600) % 60) % secs) * 1000).toInt();

  String output = '';

  if (hours == 0) {
    if (mins == 0) {
      if (ms == 0)
        output = '$secs secs';
      else
        output = '$secs secs $ms ms';
    } else {
      if (ms == 0)
        output = '$mins mins $secs secs';
      else
        output = '$mins mins $secs secs $ms ms';
    }
  } else
    output = '$hours hrs $mins mins $secs secs';

  return output;
}

Future<List<LatestRun>> getLatestRuns() async {
  final response = await http.get(baseurl +
      '/runs?status=verified&orderby=verify-date&direction=desc&embed=game,category,players,platform,region');

  if (response.statusCode == 200) {
    var list = json.decode(response.body)['data'] as List;

    return list.map((i) => LatestRun.fromJson(i)).toList();
  }

  throw Exception('Failed to load the latest runs.');
}

class Ruleset {
  final bool verification;
  final bool requireVideo;
  final bool defaultRTA;
  final bool emusAllowed;

  Ruleset(
      {this.verification,
      this.requireVideo,
      this.defaultRTA,
      this.emusAllowed});

  factory Ruleset.fromJson(Map<String, dynamic> json) {
    return Ruleset(
      verification: json['require-verification'],
      requireVideo: json['require-video'],
      defaultRTA: json['default-time'] == 'realtime',
      emusAllowed: json['emulators-allowed'],
    );
  }
}

class Assets {
  final String coverURL;
  final String trophy1st;
  final String trophy2nd;
  final String trophy3rd;

  Assets({this.coverURL, this.trophy1st, this.trophy2nd, this.trophy3rd});

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      coverURL: json['cover-large']['uri'],
      trophy1st: json['trophy-1st']['uri'],
      trophy2nd: json['trophy-2nd']['uri'],
      trophy3rd: json['trophy-3rd']['uri'],
    );
  }
}

class Game {
  final String name;
  final String abbreviation;
  final String releaseDate;
  final Ruleset ruleset;
  final List<Player> moderators;
  final Assets assets;

  Game(
      {this.name,
      this.abbreviation,
      this.releaseDate,
      this.ruleset,
      this.moderators,
      this.assets});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['names']['international'],
      abbreviation: json['abbreviation'],
      releaseDate: json['release-date'],
      ruleset: Ruleset.fromJson(json['ruleset']),
      assets: Assets.fromJson(json['assets']),
    );
  }
}

class Category {
  final String name;
  final String rules;

  Category({this.name, this.rules});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      rules: json['rules'],
    );
  }
}

class Player {
  final String name;
  final String color;
  final String country;
  final String twitch;
  final String hitbox;
  final String youtube;
  final String twitter;
  final String srl;
  final String pbs;

  Player(
      {this.name,
      this.color,
      this.country,
      this.twitch,
      this.hitbox,
      this.youtube,
      this.twitter,
      this.srl,
      this.pbs});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['names'] != null ? json['names']['international'] : '',
      color: json['name-style']['style'] == 'gradient'
          ? json['name-style']['color-from']['light']
          : json['name-style']['color']['light'],
      country: json['location'] != null
          ? json['location']['country']['names']['international']
          : '',
      twitch: json['twitch'] != null ? json['twitch']['uri'] : '',
      hitbox: json['hitbox'] != null ? json['hitbox']['uri'] : '',
      youtube: json['youtube'] != null ? json['youtube']['uri'] : '',
      twitter: json['twitter'] != null ? json['twitter']['uri'] : '',
      srl: json['speedrunslive'] != null ? json['speedrunslive']['uri'] : '',
      pbs: json['links'][3]['uri'],
    );
  }
}

class LatestRun {
  final Game game;
  final Category category;
  final Player player;
  final String date;
  final String realtime;
  final String igt;

  LatestRun(
      {this.game,
      this.category,
      this.player,
      this.date,
      this.realtime,
      this.igt});

  factory LatestRun.fromJson(Map<String, dynamic> json) {
    //Get the times in seconds
    double realtimeSecs = json['times']['realtime_t'].toDouble();
    double igtSecs = json['times']['ingame_t'].toDouble();

    return LatestRun(
      game: Game.fromJson(json['game']['data']),
      category: Category.fromJson(json['category']['data']),
      player: Player.fromJson(json['players']['data'][0]),
      date: json['date'],
      realtime: calcTime(realtimeSecs),
      igt: calcTime(igtSecs),
    );
  }
}

class LeaderboardRun {
  final int placing;
  final Game game;
  final String level;
  final Category category;
  final List<String> videoLinks;
  final String comment;
  final Player player;
  final String date;
  final String realtime;
  final String igt;
  final String region;
  final String platform;
  final String yearPlatform;

  LeaderboardRun(
      {this.placing,
      this.game,
      this.level,
      this.category,
      this.videoLinks,
      this.comment,
      this.player,
      this.date,
      this.realtime,
      this.igt,
      this.region,
      this.platform,
      this.yearPlatform});

  factory LeaderboardRun.fromJson(Map<String, dynamic> json) {
    //Convert time string
    double realtimeSecs = json['times']['realtime_t'].toDouble();
    double igtSecs = json['times']['ingame_t'].toDouble();

    var videoLinks = json['videos']['links'] as List;
    List<String> videoLinksList;
    for (int i = 0; i < videoLinks.length; ++i) {
      videoLinksList[i] = videoLinks[i]['uri'];
    }

    return LeaderboardRun(
      //placing:
      game: Game.fromJson(json['game']['data']),
      level: json['level'],
      category: Category.fromJson(json['category']['data']),
      videoLinks: videoLinksList,
      comment: json['comment'],
      player: Player.fromJson(json['players']['data'][0]),
      date: json['date'],
      realtime: calcTime(realtimeSecs),
      igt: calcTime(igtSecs),
      region:
          json['region']['data'] != null ? json['region']['data']['name'] : '',
      platform: json['platform']['data']['name'],
      yearPlatform: json['platform']['data']['released'],
    );
  }
}

class Leaderboard {
  List<LeaderboardRun> runs;

  Leaderboard({this.runs});

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    var list = json['data']['runs'] as List;
    List<LeaderboardRun> runsList =
        list.map((i) => LeaderboardRun.fromJson(i)).toList();

    return Leaderboard(
      runs: runsList,
    );
  }
}
