import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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
        output = '$secs' + 's';
      else
        output = '$secs' + 's' + '$ms' + 'ms';
    } else {
      if (ms == 0)
        output = '$mins' + 'm' + '$secs' + 's';
      else
        output = '$mins' + 'm ' + '$secs' + 's ' + '$ms' + 'ms';
    }
  } else
    output = '$hours' + 'h ' + '$mins' + 'm ' + '$secs' + 's ';

  return output;
}

Future<List<Run>> fetchLatestRuns() async {
  final response = await http.get(
      '$baseurl/runs?status=verified&orderby=submitted&direction=desc&embed=game,category,level,players,region,plaform');

  if (response.statusCode == 200) {
    return compute(parseLatestRuns, response.body);
  }

  throw Exception('Failed to load the latest runs.');
}

List<Run> parseLatestRuns(String responseBody) {
  var list = json.decode(responseBody)['data'];
  List<Run> runs = List<Run>.from(list.map((i) => Run.fromJson(i)));

  return runs;
}

//Does not work with levelled games
Future<Leaderboard> fetchLeaderboard(String leaderboardURL) async {
  final response = await http
      .get('$leaderboardURL?embed=game,category,players,regions,platforms');

  if (response.statusCode == 200) {
    return compute(parseLeaderboard, response.body);
  }

  throw Exception('Failed to load leaderboard.');
}

Leaderboard parseLeaderboard(String responseBody) {
  return Leaderboard.fromJson(json.decode(responseBody)['data']);
}

Future<Game> fetchGame(String abbreviation) async {
  final response = await http.get(
      '$baseurl/games/$abbreviation?embed=categories,moderators,platforms,regions');

  if (response.statusCode == 200) {
    return compute(parseGame, response.body);
  }

  throw Exception('Failed to load game.');
}

Game parseGame(String responseBody) {
  return Game.fromJson(json.decode(responseBody)['data']);
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
  final String background;
  final String trophy1st;
  final String trophy2nd;
  final String trophy3rd;

  Assets(
      {this.coverURL,
      this.background,
      this.trophy1st,
      this.trophy2nd,
      this.trophy3rd});

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      coverURL: json['cover-large']['uri'],
      background: json['background'] != null ? json['background']['uri'] : null,
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
  final List<String> platforms;
  final List<String> regions;
  final List<Player> moderators;
  final Assets assets;
  final List<Category> categories;
  final String leaderboardURL;

  Game({
    this.id,
    this.name,
    this.abbreviation,
    this.releaseDate,
    this.ruleset,
    this.platforms,
    this.regions,
    this.moderators,
    this.assets,
    this.categories,
    this.leaderboardURL,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    String leaderboardURL;

    if (json['links'][json['links'].length - 1]['rel'] == 'leaderboard') {
      leaderboardURL = json['links'][json['links'].length - 1]['uri'];
    } else {
      leaderboardURL = json['links'][2]['uri'];
    }

    //----------------------------------------------------

    List<String> regionsList;
    List<String> platformsList;
    List<Player> moderatorsList;
    List<Category> categoriesList;

    if (json['regions'] is Map<String, dynamic>) {
      regionsList = List<String>(json['regions']['data'].length);
      var list = json['regions']['data'] as List;
      for (int i = 0; i < list.length; ++i) regionsList[i] = list[i]['name'];
    }

    if (json['platforms'] is Map<String, dynamic>) {
      platformsList = List<String>(json['platforms']['data'].length);
      var list2 = json['platforms']['data'] as List;
      for (int i = 0; i < list2.length; ++i)
        platformsList[i] = list2[i]['name'];
    }

    if (json['moderators']['data'] != null) {
      moderatorsList = List<Player>(json['moderators']['data'].length);
      var list3 = json['moderators']['data'] as List;
      for (int i = 0; i < list3.length; ++i)
        moderatorsList[i] = Player.fromJson(list3[i]);
    }

    if (json['categories'] != null) {
      categoriesList = List<Category>(json['categories']['data'].length);
      var list4 = json['categories']['data'] as List;
      for (int i = 0; i < list4.length; ++i)
        categoriesList[i] = Category.fromJson(list4[i]);
    }

    return Game(
      id: json['id'],
      name: json['names']['international'],
      abbreviation: json['abbreviation'],
      releaseDate: json['release-date'],
      platforms: platformsList,
      regions: regionsList,
      moderators: moderatorsList,
      ruleset: Ruleset.fromJson(json['ruleset']),
      assets: Assets.fromJson(json['assets']),
      categories: categoriesList,
      leaderboardURL: leaderboardURL,
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
    //For runs without players
    if (json['rel'] == 'guest') {
      return Player(
        name: 'Guest',
        color: '#000000',
        country: '',
        twitch: '',
        hitbox: '',
        youtube: '',
        twitter: '',
        srl: '',
        pbs: '',
      );
    }

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

class Run {
  final Game game;
  final Category category;
  final List<String> videoLinks;
  final String comment;
  final String verifyDate;
  final Player player;
  final String date;
  final String realtime;
  final String igt;
  final String region;
  final String platform;
  final String yearPlatform;

  Run(
      {this.game,
      this.category,
      this.videoLinks,
      this.comment,
      this.verifyDate,
      this.player,
      this.date,
      this.realtime,
      this.igt,
      this.region,
      this.platform,
      this.yearPlatform});

  factory Run.fromJson(Map<String, dynamic> json) {
    //Handles getting the list of videos
    var videos = json['videos'] != null ? json['videos'] : null;
    List<String> videoLinksList;
    if (videos != null) {
      videoLinksList = List<String>(videos['links'].length);
      if (videos['links'] != null) {
      } else {
        videoLinksList = List<String>(1);
        videoLinksList[0] = videos['text'];
      }
    }

    return Run(
      game: Game.fromJson(json['game']['data']),
      category: Category.fromJson(json['category']['data']),
      videoLinks: videoLinksList,
      comment: json['comment'] != null ? json['comment'] : '',
      verifyDate: json['status']['verify-date'],
      player: Player.fromJson(json['players']['data'][0]),
      date: json['date'],
      realtime: calcTime(json['times']['realtime_t'].toDouble()),
      igt: calcTime(json['times']['ingame_t'].toDouble()),
      region: json['region']['data'] is Map<String, dynamic>
          ? json['region']['data']['name']
          : "",
      platform:
          json['platform'] != null ? json['platform']['data']['name'] : '',
      yearPlatform:
          json['platform'] != null ? json['platform']['data']['released'] : '',
    );
  }
}

class LeaderboardRun {
  final int place;
  final String date;
  final String realtime;
  final String igt;

  LeaderboardRun({this.place, this.date, this.realtime, this.igt});

  factory LeaderboardRun.fromJson(Map<String, dynamic> json) {
    return LeaderboardRun(
      place: json['place'],
      date: json['run']['date'],
      realtime: calcTime(json['run']['times']['realtime_t'].toDouble()),
      igt: calcTime(json['run']['times']['ingame_t'].toDouble()),
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

  Leaderboard(
      {this.runs,
      this.players,
      this.game,
      this.category,
      this.level,
      this.regions,
      this.platforms});

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    var list = json['runs'] as List;
    List<LeaderboardRun> runsList =
        list.map((i) => LeaderboardRun.fromJson(i)).toList();

    var list2 = json['players']['data'] as List;
    List<Player> playersList = list2.map((i) => Player.fromJson(i)).toList();

    List<String> regionsList;
    List<String> platformsList;

    regionsList = List<String>(json['regions']['data'].length);
    var list3 = json['regions']['data'] as List;
    for (int i = 0; i < list3.length; ++i) regionsList[i] = list3[i]['name'];

    platformsList = List<String>(json['platforms']['data'].length);
    var list4 = json['platforms']['data'] as List;
    for (int i = 0; i < list4.length; ++i) platformsList[i] = list4[i]['name'];

    return Leaderboard(
      runs: runsList,
      players: playersList,
      game: Game.fromJson(json['game']['data']),
      category: Category.fromJson(json['category']['data']),
      level: json['level'],
      regions: regionsList,
      platforms: platformsList,
    );
  }
}
