import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
// import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/managers/deep_link_manager.dart';
// import 'package:whatnext/models/movie_details.dart';
// import 'package:whatnext/models/tv_show_details.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/ui/views/movie_details_view.dart';
// import 'package:whatnext/ui/views/movie_detail_deepLink.dart';
import 'package:whatnext/ui/views/startup_view.dart';
import 'package:whatnext/ui/views/tv_show_details_view.dart';
// import 'package:whatnext/ui/views/tv_detail_deeplink.dart';
import 'package:whatnext/viewmodels/theme_view_model.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'whatnext_app',
            channelName: 'Whatnext notifications',
            channelDescription: 'Notification channel for whatnext app',
            ledColor: Colors.white)
      ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    var _fcm = FirebaseMessaging.onMessage;

    _fcm.listen((event) {
      print(" event: $event");
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'whatnext_app',
            title: '',
            color: Color(0xFFFFDE59),
            body: '${event.notification.body}'),
      );
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DeepLinkManager>.withConsumer(
      viewModelBuilder: () => DeepLinkManager(),
      onModelReady: (model) => model.initDynamicLinks(),
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
          var theType = model.mediaType;
          var theId = model.id;
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
                  scaffoldMessengerKey:
                      locator<SnackbarService>().scaffoldMessengerKey,
                  key: locator<SnackbarService>().scaffoldKey,
                  theme: model.theme,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: locator<NavigationService>().navigationKey,
                  home: Material(
                    child: Scaffold(
                      body: theType == 'movie'
                          ? MovieDetailsView(id: theId)
                          : TvShowDetailsView(id: theId),
                    ),
                  ),
                  onGenerateRoute: generateRoute,
                );
              }
            },
          );
        }
      },
    );
  }
}
