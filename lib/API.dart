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
      '$baseurl/runs?status=verified&orderby=submitted&direction=desc&embed=game.levels,game.categories,game.moderators,game.platforms,game.regions,category,level,players,region,platform');

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

Future<Leaderboard> fetchLeaderboard(String leaderboardURL) async {
  final response = await http.get(
      '$leaderboardURL?embed=game,category,level,players,regions,platforms');

  if (response.statusCode == 200) {
    return compute(parseLeaderboard, response.body);
  }

  throw Exception('Failed to load leaderboard.');
}

Leaderboard parseLeaderboard(String responseBody) {
  return Leaderboard.fromJson(json.decode(responseBody)['data']);
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
      defaultRTA: json['default-time'] == 'realtime' ||
          json['default-time'] == 'realtime_noloads',
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
  final String releaseDate;
  final Ruleset ruleset;
  final List<String> platforms;
  final List<String> regions;
  final List<Player> moderators;
  final Assets assets;
  final List<Category> categories;
  final List<Level> levels;
  final String leaderboardURL;

  Game({
    this.id,
    this.name,
    this.releaseDate,
    this.ruleset,
    this.platforms,
    this.regions,
    this.moderators,
    this.assets,
    this.categories,
    this.levels,
    this.leaderboardURL,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    var list = json['platforms']['data'] as List;
    List<String> platformsList = list.map((i) => list[i]['name']).toList();

    var list2 = json['regions']['data'] as List;
    List<String> regionsList = list2.map((i) => list2[i]['name']).toList();

    var list3 = json['moderators']['data'] as List;
    List<Player> modsList = list3.map((i) => Player.fromJson(list3[i]));

    var list4 = json['categories']['data'] as List;
    List<Category> categoriesList =
        list4.map((i) => Category.fromJson(list4[i]));

    var list5 = json['levels']['data'] as List;
    List<Level> levelsList = list5.map((i) => Level.fromJson(list5[i]));

    //------------------------------------------------
    String leaderboardURL;

    if (json['links'][json['links'].length - 1]['rel'] == 'leaderboard')
      leaderboardURL = json['links'][json['links'].length - 1]['uri'];
    else
      leaderboardURL = json['links'][2]['uri'];
    //------------------------------------------------

    return Game(
      id: json['id'],
      name: json['names']['international'],
      releaseDate: json['release-date'],
      platforms: platformsList,
      regions: regionsList,
      moderators: modsList,
      ruleset: Ruleset.fromJson(json['ruleset']),
      assets: Assets.fromJson(json['assets']),
      categories: categoriesList,
      levels: levelsList,
      leaderboardURL: leaderboardURL,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String type;
  final String rules;
  final String leaderboardURL;

  Category({this.id, this.name, this.type, this.rules, this.leaderboardURL});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      rules: json['rules'],
      leaderboardURL: json['links'][json['links'].length - 1]['uri'],
    );
  }
}

class Level {
  final String id;
  final String name;
  final String rules;
  final String leaderboardURL;

  Level({this.id, this.name, this.rules, this.leaderboardURL});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
      rules: json['rules'] != null ? json['rules'] : '',
      leaderboardURL: json['links'][json['links'].length - 1]['uri'],
    );
  }
}

class Player {
  final String name;
  final String color;
  final String countrycode;
  final String twitch;
  final String hitbox;
  final String youtube;
  final String twitter;
  final String srl;
  final String pbs;

  Player(
      {this.name,
      this.color,
      this.countrycode,
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
        name: json['name'] + ' (guest)',
        color: '#000000',
        countrycode: '',
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
      countrycode:
          json['location'] != null ? json['location']['country']['code'] : '',
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
  final String id;
  final Game game;
  final Category category;
  final Level level;
  final List<String> videoLinks;
  final String comment;
  final String verifyDate;
  final Player player; //eventually add support for co-op runs
  final String date;
  final String realtime;
  final String igt;
  final String region;
  final String platform;
  final String yearPlatform;
  final String leaderboardURL;

  Run(
      {this.id,
      this.game,
      this.category,
      this.level,
      this.videoLinks,
      this.comment,
      this.verifyDate,
      this.player,
      this.date,
      this.realtime,
      this.igt,
      this.region,
      this.platform,
      this.yearPlatform,
      this.leaderboardURL});

  factory Run.fromJson(Map<String, dynamic> json) {
    //Handles getting the list of videos
    var videos = json['videos'] != null ? json['videos'] : null;
    List<String> videoLinksList;
    if (videos != null) {
      if (videos['links'] != null) {
        videoLinksList = List<String>(videos['links'].length);
        for (int i = 0; i < videos['links'].length; ++i) {
          videoLinksList[i] = videos['links'][i]['uri'];
        }
      } else {
        videoLinksList = List<String>(1);
        videoLinksList[0] = videos['text'];
      }
    }

    String leaderboardURL = '';
    String gameID = json['game']['data']['id'];
    String categoryID = json['category']['data']['id'];
    String levelID = json['level']['data'] is Map<String, dynamic>
        ? json['level']['data']['id']
        : "";
    if (levelID != '') {
      leaderboardURL =
          'https://speedrun.com/api/v1/leaderboards/$gameID/level/$levelID/$categoryID';
    } else {
      leaderboardURL =
          'https://speedrun.com/api/v1/leaderboards/$gameID/category/$categoryID';
    }

    return Run(
      id: json['id'],
      game: Game.fromJson(json['game']['data']),
      category: Category.fromJson(json['category']['data']),
      level: json['level']['data'] is Map<String, dynamic>
          ? Level.fromJson(json['level']['data'])
          : null,
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
      leaderboardURL: leaderboardURL,
    );
  }
}

class LeaderboardRun {
  final int place;
  final String id;
  final List<String> videoLinks;
  final String comment;
  final String verifyDate;
  final String date;
  final String realtime;
  final String igt;

  LeaderboardRun(
      {this.place,
      this.id,
      this.videoLinks,
      this.comment,
      this.verifyDate,
      this.date,
      this.realtime,
      this.igt});

  factory LeaderboardRun.fromJson(Map<String, dynamic> json) {
    var videos = json['run']['videos'] != null ? json['run']['videos'] : null;
    List<String> videoLinksList;
    if (videos != null) {
      if (videos['links'] != null) {
        videoLinksList = List<String>(videos['links'].length);
        for (int i = 0; i < videos['links'].length; ++i) {
          videoLinksList[i] = videos['links'][i]['uri'];
        }
      } else {
        videoLinksList = List<String>(1);
        videoLinksList[0] = videos['text'];
      }
    }

    return LeaderboardRun(
      place: json['place'],
      id: json['run']['id'],
      videoLinks: videoLinksList,
      comment: json['run']['comment'],
      verifyDate: json['run']['status']['verify-date'],
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
  final Level level;
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
      level: json['level']['data'] is Map<String, dynamic>
          ? Level.fromJson(json['level']['data'])
          : null,
      regions: regionsList,
      platforms: platformsList,
    );
  }
}
