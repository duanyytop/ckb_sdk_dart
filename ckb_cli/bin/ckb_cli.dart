import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../src/cli_command_runner.dart';

ArgResults argResults;

void main(List<String> args) async {
  try {
    await run(args);
  } on UsageException catch (e) {
    print('\n${e.usage}');
  }
}
