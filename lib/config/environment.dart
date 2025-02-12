import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/injection.dart';

enum Environment { dev, prod }

class EnvironmentConfig {
  final String apiUrl;
  final String apiKey;
  final bool enableLogging;
  final Environment environment;

  static EnvironmentConfig? _instance;

  EnvironmentConfig._({
    required this.apiUrl,
    required this.apiKey,
    required this.enableLogging,
    required this.environment,
  });

  static EnvironmentConfig get instance {
    _instance ??= EnvironmentConfig._fromEnvironment();
    return _instance!;
  }

  static EnvironmentConfig _fromEnvironment() {
    final savedEnv = LocalStorageService().getString(StorageKeys.envKey);
    if (savedEnv.isEmpty) {
      return EnvironmentConfig._(
        environment: Environment.prod,
        apiUrl: 'https://api.tezmed.uz/v1',
        apiKey: 'prod-api-key',
        enableLogging: false,
      );
    }
    if (savedEnv == 'prod') {
      return EnvironmentConfig._(
        environment: Environment.prod,
        apiUrl: 'https://api.tezmed.uz/v1',
        apiKey: 'prod-api-key',
        enableLogging: false,
      );
    }

    return EnvironmentConfig._(
      environment: Environment.dev,
      apiUrl: 'https://api-dev.tezmed.uz/v1',
      apiKey: 'dev-api-key',
      enableLogging: true,
    );
  }

  static void switchEnvironment(Environment newEnvironment) {
    LocalStorageService().setString(StorageKeys.envKey, newEnvironment.name);

    _instance = EnvironmentConfig._(
      environment: newEnvironment,
      apiUrl: newEnvironment == Environment.prod
          ? 'https://api.tezmed.uz/v1'
          : 'https://api-dev.tezmed.uz/v1',
      apiKey:
          newEnvironment == Environment.prod ? 'prod-api-key' : 'dev-api-key',
      enableLogging: newEnvironment == Environment.dev,
    );

    getIt<Dio>().options.baseUrl = _instance!.apiUrl;
  }

  bool get isProd => environment == Environment.prod;
  bool get isDev => environment == Environment.dev;
}
