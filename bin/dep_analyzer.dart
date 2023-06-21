import 'dart:io';

import 'package:args/args.dart';
import 'package:dep_analyzer/dep_analyzer.dart';
import 'package:dep_analyzer/src/repositories/chart_processor/chart_dep_data_processor.dart';

Future<void> main(List<String> arguments) async {
  final argParser = ArgParser()
    ..addOption(
      'file',
      abbr: 'f',
      help:
          'Specifies the file to be opened. Can be used with a full or relative path',
      mandatory: true,
    )
    ..addMultiOption(
      'output',
      abbr: 'o',
      allowed: ['console', 'txt', 'json', 'chart'],
      allowedHelp: {
        'console': 'Prints a summary of the results to console',
        'txt': 'Not implemented yet',
        'json': 'Saves the results in json format',
        'chart': 'Creates charts based on the results and saves them '
            'in png format',
      },
      defaultsTo: ['console'],
    )
    ..addOption(
      'directory',
      abbr: 'd',
      help: 'Specifies a directory where the output should be saved',
      defaultsTo: Directory.current.path,
    )
    ..addFlag(
      'pretty',
      abbr: 'p',
      help: 'Formats JSON to be more readable',
      negatable: false,
    );
  if (arguments.isEmpty) {
    stdout.writeln(argParser.usage);
    exit(1);
  }
  if (arguments.any((arg) => arg.contains(RegExp('--help|-h|help')))) {
    stdout.writeln(argParser.usage);
    exit(0);
  }
  final ArgResults argResults;
  try {
    argResults = argParser.parse(arguments);
  } on FormatException catch (e) {
    stdout.writeln(e.message);
    stdout.writeln(argParser.usage);
    exit(1);
  }
  final file = File(argResults['file'] as String);
  if (!file.existsSync()) {
    stdout.writeln('File not found');
    exit(1);
  }
  final chosenOutput = argResults['output'] as List<String>;
  try {
    await DepAnalyzerTool().analyze(
      file: file,
      depDataProcessors: {
        if (chosenOutput.contains('console')) ConsoleDepDataProcessor(),
        if (chosenOutput.contains('txt'))
          TxtFileDepDataProcessor(
            outputDirectory: argResults['directory'] as String,
          ),
        if (chosenOutput.contains('json'))
          JsonDepDataProcessor(
            pretty: argResults['pretty'] as bool,
            outputDirectory: argResults['directory'] as String,
          ),
        if (chosenOutput.contains('chart'))
          ChartDepDataProcessor(
            outputDirectory: argResults['directory'] as String,
          ),
      },
    );
  } catch (e) {
    stdout.writeln(e);
  }
  stdout.writeln('Done');
}
