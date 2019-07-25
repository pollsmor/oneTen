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
  final response = await http.get(
      '$baseurl/runs?status=verified&orderby=verify-date&direction=desc&embed=game,category,players,platform,region');

  if (response.statusCode == 200) {
    var list = json.decode(response.body)['data'] as List;

    return list.map((i) => LatestRun.fromJson(i)).toList();
  }

  throw Exception('Failed to load the latest runs.');
}

Future<Leaderboard> getLeaderboard(String leaderboardURL, bool isLevel) async {
  final response = await http
      .get('$leaderboardURL?embed=game,category,players,regions,platforms');

  if (response.statusCode == 200) {
    if (!isLevel)
      return Leaderboard.fromJson(json.decode(response.body)['data']);
    else {
      final response2 = await http.get(leaderboardURL);
      final response3 = await http.get(json.decode(response2.body)['data'][0]
                  ['links']
              [json.decode(response2.body)['data'][0]['links'].length - 1]['uri'] +
          '?embed=game,category,players,regions,platforms');
      return Leaderboard.fromJson(json.decode(response3.body)['data']);
    }
  }

  throw Exception('Failed to load leaderboard.');
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
  final String id;
  final String name;
  final String abbreviation;
  final String releaseDate;
  final Ruleset ruleset;
  final List<Player> moderators;
  final Assets assets;
  final String leaderboardURL;
  final bool isLevel;

  Game(
      {this.id,
      this.name,
      this.abbreviation,
      this.releaseDate,
      this.ruleset,
      this.moderators,
      this.assets,
      this.leaderboardURL,
      this.isLevel});

  factory Game.fromJson(Map<String, dynamic> json) {
    String leaderboardURL;
    bool isLevel;
    for (int i = 0; i < json['links'].length; ++i) {
      if (json['links'][i]['rel'] == 'leaderboard') {
        leaderboardURL = json['links'][i]['uri'];
        isLevel = false;
      } else if (json['links'][i]['rel'] == 'levels') {
        leaderboardURL = json['links'][i]['uri'];
        isLevel = true;
      }
    }

    return Game(
      id: json['id'],
      name: json['names']['international'],
      abbreviation: json['abbreviation'],
      releaseDate: json['release-date'],
      ruleset: Ruleset.fromJson(json['ruleset']),
      assets: Assets.fromJson(json['assets']),
      leaderboardURL: leaderboardURL,
      isLevel: isLevel,
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
    String name = '';
    String color = '';
    if (json['names'] != null) {
      name = json['names']['international'];
      color = json['name-style']['style'] == 'gradient'
          ? json['name-style']['color-from']['light']
          : json['name-style']['color']['light'];
    }

    return Player(
      name: name,
      color: color,
      country: json['location'] != null
          ? json['location']['country']['names']['international']
          : '',
      twitch: json['twitch'] != null ? json['twitch']['uri'] : '',
      hitbox: json['hitbox'] != null ? json['hitbox']['uri'] : '',
      youtube: json['youtube'] != null ? json['youtube']['uri'] : '',
      twitter: json['twitter'] != null ? json['twitter']['uri'] : '',
      srl: json['speedrunslive'] != null ? json['speedrunslive']['uri'] : '',
      pbs: json['links'][json['links'].length - 1]['uri'],
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
  final List<String> videoLinks;
  final String comment;
  final String date;
  final String realtime;
  final String igt;

  LeaderboardRun({
    this.placing,
    this.videoLinks,
    this.comment,
    this.date,
    this.realtime,
    this.igt,
  });

  factory LeaderboardRun.fromJson(Map<String, dynamic> json) {
    //Convert time string
    double realtimeSecs = json['run']['times']['realtime_t'].toDouble();
    double igtSecs = json['run']['times']['ingame_t'].toDouble();

    var list = json['run']['videos'] != null
        ? json['run']['videos']['links'] as List
        : null;
    List<String> videoLinksList;
    if (list != null) {
      videoLinksList = List<String>(list.length);
      for (int i = 0; i < list.length; ++i) {
        videoLinksList[i] = list[i]['uri'];
      }
    }

    return LeaderboardRun(
      placing: json['place'],
      videoLinks: videoLinksList,
      comment: json['run']['comment'],
      date: json['run']['date'],
      realtime: calcTime(realtimeSecs),
      igt: calcTime(igtSecs),
    );
  }
}

class Leaderboard {
  final List<LeaderboardRun> runs;
  final List<Player> players; //same index as for runs
  final Game game;
  final Category category;
  final String level;
  final List<String> regions;
  final List<String> platforms;
  final List<String> yearPlatforms;

  Leaderboard(
      {this.runs,
      this.players,
      this.game,
      this.category,
      this.level,
      this.regions,
      this.platforms,
      this.yearPlatforms});

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    var list = json['runs'] as List;
    List<LeaderboardRun> runsList =
        list.map((i) => LeaderboardRun.fromJson(i)).toList();

    var list2 = json['players']['data'] as List;
    List<Player> playersList = list2.map((i) => Player.fromJson(i)).toList();

    var list3 = json['regions']['data'] as List;
    List<String> regionsList = List<String>(list3.length);
    for (int i = 0; i < list3.length; ++i) regionsList[i] = list3[i]['name'];

    var list4 = json['platforms']['data'] as List;
    List<String> platformsList = List<String>(list4.length);
    List<String> yearPlatformsList = List<String>(list4.length);
    for (int i = 0; i < list4.length; ++i) {
      platformsList[i] = list4[i]['name'];
      yearPlatformsList[i] = list4[i]['released'].toString();
    }

    return Leaderboard(
      runs: runsList,
      players: playersList,
      game: Game.fromJson(json['game']['data']),
      category: Category.fromJson(json['category']['data']),
      level: json['level'],
      regions: regionsList,
      platforms: platformsList,
      yearPlatforms: yearPlatformsList,
    );
  }
}
