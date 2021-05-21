import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
// import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/managers/deep_link_manager.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/ui/views/movie_detail_deepLink.dart';
import 'package:whatnext/ui/views/startup_view.dart';
import 'package:whatnext/ui/views/tv_detail_deeplink.dart';
import 'package:whatnext/viewmodels/theme_view_model.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white70,
    ),
  );
  // Register all the models and services before the app starts
  setupLocator();

  runApp(
    // Wrapped wih phoenix to facilitate programtically restarting the app.
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DeepLinkManager>.withConsumer(
      viewModelBuilder: () => DeepLinkManager(),
      onModelReady: (model) => model.deepLinkInit(),
      builder: (context, model, child) {
        if (model.deepLink == false) {
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
        } else {
          return MaterialApp(
            title: 'What Next ?',
            debugShowCheckedModeBanner: true,
            scaffoldMessengerKey:
                locator<SnackbarService>().scaffoldMessengerKey,
            key: locator<SnackbarService>().scaffoldKey,
            home: Material(
              child: Scaffold(
                body: model.mediaType == 'movie'
                    ? MovieDetailsDeepLink(id: model.id)
                    : TvDetailDeepLink(id: model.id),
              ),
            ),
            onGenerateRoute: generateRoute,
          );
        }
      },
    );
  }
}
