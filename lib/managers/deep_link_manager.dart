import 'package:flutter/services.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class DeepLinkManager extends BaseModel {
  bool _deepLink = false;
  bool get deepLink => _deepLink;

  String _mediaType = "";
  String get mediaType => _mediaType;

  int _id = 1;
  int get id => _id;

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  //Event Channel creation
  static const stream = const EventChannel('whatnext.app/events');

  //Method channel creation
  static const platform = const MethodChannel('whatnext.app/channel');

  //Adding the listener into contructor
  deepLinkInit() async {
    print(" first thing yo");

    bool hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    print(
        " has user logged in : $hasLoggedInUser   and ${hasLoggedInUser.runtimeType} ");

    if (hasLoggedInUser == false) {
      _navigationService.navigateReplacement(LoginViewRoute);
    }

    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  _onRedirected(String uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    print(" for checks uri is : $uri");
    // _navigationService.navigateTo(MovieDetailsViewRoute, arguments: 500);
    String u = uri;
    u = u.substring(21);
    print(" u is : $u");
    String type = u.substring(0, 1);
    print("type is: $type");
    if (type == "m") {
      _mediaType = 'movie';
    } else {
      _mediaType = 'tv';
    }
    print("id is : ${u.substring(2)}");
    _id = int.parse(u.substring(2));
    _deepLink = true;
    setState();
  }

  Future<String> startUri() async {
    try {
      print(" this is : ${platform.invokeMethod('initialLink')}");
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
