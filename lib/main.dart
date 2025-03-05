import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tez_med_client/config/bloc_providers.dart';
import 'package:tez_med_client/config/environment.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/init/hive_init.dart';
import 'package:tez_med_client/core/routes/app_routes.dart';
import 'package:tez_med_client/data/notification/repositories/notification_repository_impl.dart';
import 'package:tez_med_client/firebase_options.dart';
import 'package:tez_med_client/injection.dart';
import 'data/local_storage/local_storage_service.dart';
import 'generated/l10n.dart';
import 'dart:developer' as developer;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log(message.data.toString());
  await NotificationRepositoryImpl().showNotification(message);
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initHive();
  await setUp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  EnvironmentConfig.instance;
  await LocalStorageService.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appRouter = AppRouter.instance;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...AppBlocProviders.providers,
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            locale: state.locale,
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.config(),
          );
        },
      ),
    );
  }
}
