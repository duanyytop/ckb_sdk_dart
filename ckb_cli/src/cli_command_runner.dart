import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'version.dart';

Future<int> run(List<String> args) => _CliCommand().run(args);

class _CliCommand extends CommandRunner<int> {
  _CliCommand() : super('cli', 'A tool to visit nervos ckb by command-cli.') {
    argParser.addFlag('version',
        negatable: false, help: 'Print the version of cli.');
  }

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] as bool) {
      print(packageVersion);
      return 0;
    }

    // In the case of `help`, `null` is returned. Treat that as success.
    return await super.runCommand(topLevelResults) ?? 0;
  }
}
