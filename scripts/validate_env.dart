
// ignore_for_file: avoid_print
import 'dart:io';
import 'env_keys.dart';

void main(List<String> args) {
  final envFile = args.isNotEmpty ? args[0] : '.env.development';

  print('Validating environment variables in $envFile...');

  if (!File(envFile).existsSync()) {
    print('❌ ERROR: Environment file $envFile not found');
    print('\nTo create a new environment file:');
    print('1. Create $envFile with the following variables:');
    for (final varName in requiredEnvVariableKeys) {
      print('   $varName=your_value_here');
    }
    print('\n2. If adding a new variable, update "env_keys.dart" as well.');
    exit(1);
  }

  final envFileContent = File(envFile).readAsStringSync();
  final envVars = parseEnvFile(envFileContent);

  final missingVars = <String>[];

  for (final varName in requiredEnvVariableKeys) {
    if (!envVars.containsKey(varName) || envVars[varName]!.isEmpty) {
      missingVars.add(varName);
    }
  }

  if (missingVars.isNotEmpty) {
    print('❌ ERROR: Missing required environment variables:');
    for (final varName in missingVars) {
      print('  - $varName');
    }
    print('\nPlease add these variables to $envFile and try again.');
    print('\nReminder: When adding new environment variables:');
    print('1. Add the variable to all .env.* files');
    print('2. Add the variable key (name) to "env_keys.dart"');
    print('3. Update EnvConfigService to access the new variable');
    exit(1);
  }

  print('✅ All required environment variables are present in $envFile');
}

Map<String, String> parseEnvFile(String content) {
  final result = <String, String>{};
  final lines = content.split('\n');

  for (final line in lines) {
    if (line.trim().isEmpty || line.trim().startsWith('#')) {
      continue;
    }

    final match = RegExp(r'^([^=]+)=(.*)$').firstMatch(line);
    if (match != null) {
      final key = match.group(1)?.trim() ?? '';
      final value = match.group(2)?.trim() ?? '';

      final unquotedValue = value.startsWith('"') && value.endsWith('"')
          ? value.substring(1, value.length - 1)
          : value;

      result[key] = unquotedValue;
    }
  }

  return result;
}
