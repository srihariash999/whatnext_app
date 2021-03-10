import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/ui/views/startup_view.dart';
import 'package:whatnext/viewmodels/theme_view_model.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF4a4e69),
    ),
  );
  // Register all the models and services before the app starts
  setupLocator();

  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ThemesViewModel>.withConsumer(
      viewModelBuilder: () => ThemesViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) {
        print(" this build is trigggggoooo");
        if (model.busy) {
          return MaterialApp(
            title: 'What Next ?',
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            title: 'What Next ?',
            builder: (context, child) => Navigator(
              key: locator<DialogService>().dialogNavigationKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => DialogManager(child: child)),
            ),
            debugShowCheckedModeBanner: false,
            navigatorKey: locator<NavigationService>().navigationKey,
            scaffoldMessengerKey:
                locator<SnackbarService>().scaffoldMessengerKey,
            key: locator<SnackbarService>().scaffoldKey,
            theme: model.theme,
            home: StartUpView(),
            onGenerateRoute: generateRoute,
          );
        }
      },
    );
  }
}
