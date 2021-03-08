import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/ui/views/startup_view.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:whatnext/ui/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initialise();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF4a4e69),
    ),
  );
  // Register all the models and services before the app starts
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What Next ?',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigationKey,
      scaffoldMessengerKey: locator<SnackbarService>().scaffoldMessengerKey,
      key: locator<SnackbarService>().scaffoldKey,
      theme: getlightTheme(),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
