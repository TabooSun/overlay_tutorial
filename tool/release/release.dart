import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:git/git.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final gitDir = await _getGitDir();
  final parser = ArgParser();
  const bumpTypes = ['major', 'minor', 'patch'];
  const typeName = 'type';
  const helpName = 'help';

  parser.addOption(
    typeName,
    allowed: bumpTypes,
    abbr: 't',
    help: '''
    Consider 1.2.1 as current version. 
    - \'major\' will increment the version to 2.0.0. 
    - \'minor\' will increment the version to 1.3.1. 
    - \'patch\' will increment the version to 1.2.2. 
    ''',
  );
  parser.addFlag(
    helpName,
    abbr: 'h',
    help: 'Display this info',
    defaultsTo: false,
    negatable: false,
  );

  try {
    final results = parser.parse(args);

    if (results.arguments.isEmpty || results[helpName]) print(parser.usage);
    final type = results[typeName];

    Process.runSync(
      'pubver',
      'bump $type'.split(' '),
      stdoutEncoding: utf8,
    );

  } on FormatException catch (ex) {
    final sb = StringBuffer();
    sb.writeln(ex.message);
    sb.writeln();
    sb.writeln(parser.usage);
    print(sb.toString());
  }
}

Future<GitDir> _getGitDir() async {
  if (await GitDir.isGitDir(p.current)) {
    return await GitDir.fromExisting(p.current);
  } else
    throw 'Invalid git project';
}
