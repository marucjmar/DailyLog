import 'package:daily_log/auth/data/api/auth.dart';
import 'package:daily_log/auth/data/stores/session.dart';
import 'package:daily_log/auth/domain/repositories/auth.dart';
import 'package:daily_log/auth/presentation/controllers/auth.dart';
import 'package:daily_log/dependencies.dart';
import 'package:flutter/widgets.dart';

class AppBootstrap {
  static Future<AppDependencies> create() async {
    WidgetsFlutterBinding.ensureInitialized();

    final sessionStorage = await SessionStorage.create();
    final authApi = AuthApi();

    final authRepository = AuthRepositoryImpl(
      authApi: authApi,
      sessionStorage: sessionStorage,
    );

    final authController = AuthController(repository: authRepository);

    return AppDependencies(authController: authController);
  }
}
