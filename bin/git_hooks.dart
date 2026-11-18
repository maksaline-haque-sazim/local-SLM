import 'dart:io';
import 'package:git_hooks/git_hooks.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('GitHooksLogger');

void main(List<String> arguments) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.preCommit: preCommit
  };
  GitHooks.call(arguments, params);
}

Future<bool> commitMsg() async {
  var msg = Utils.getCommitEditMsg();
  final commitRegex = RegExp(
      r'^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test){1}(\([\w\-\.]+\))?(!)?: ([\w ])+([\s\S]*)');

  if (!commitRegex.hasMatch(msg)) {
    logger.warning('❌ Invalid commit message format!');
    logger.info('Commit message should follow "type: description" format');
    logger.info('Example: feat: add user login feature');
    return false;
  }
  return true;
}

Future<bool> preCommit() async {
  try {
    ProcessResult result = await Process.run('dart', ['analyze']);
    logger.info(result.stdout);

    if (result.exitCode != 0) {
      logger.warning(
          '❌ Dart analyzer found issues. Please fix them before committing.');
      return false;
    }
  } catch (e) {
    logger.warning('⚠️ Error running Dart analyzer: $e');
    return false;
  }
  return true;
}
