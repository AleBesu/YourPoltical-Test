import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:your_political_test/UI/screens/main_screen.dart';

import 'package:your_political_test/app/theme/app_theme.dart';
import 'package:your_political_test/core/local_database_service/local_database_service.dart';
import 'package:your_political_test/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseService.initDataBase();
  await MobileAds.instance.initialize();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en'), Locale('es')],
      theme: appTheme,
      navigatorKey: navigatorKey,
      title: 'Political Test',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
