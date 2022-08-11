import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/services.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
// import 'package:whatnext/models/movie_details.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/providers/base_provider.dart';

class DeepLinkManager extends BaseProvider {
  bool _deepLink = false;
  bool get deepLink => _deepLink;

  String _mediaType = "";
  String get mediaType => _mediaType;

  int _id = 1;
  int get id => _id;

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      setBusy(true);
      // print(" first thing yo");

      bool hasLoggedInUser = await _authenticationService.isUserLoggedIn();

      // print(
      //     " has user logged in : $hasLoggedInUser   and ${hasLoggedInUser.runtimeType} ");

      if (hasLoggedInUser == false) {
        _navigationService.navigateReplacement(LoginViewRoute);
      } else {
        _handleDeepLink(dynamicLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    bool hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    // print(
    //     " has user logged in : $hasLoggedInUser   and ${hasLoggedInUser.runtimeType} ");

    if (hasLoggedInUser == false) {
      _navigationService.navigateReplacement(LoginViewRoute);
    } else {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();

      _handleDeepLink(data);
    }
  }

  void _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      var type = deepLink.queryParameters['type'];
      var id = deepLink.queryParameters['id'];
      _deepLink = true;
      _mediaType = type;
      _id = int.parse(id);
      setBusy(false);
      setState();
      if (type == 'movie') {
        _navigationService.navigateTo(MovieDetailsViewRoute, arguments: _id);
      } else {
        _navigationService.navigateTo(TvShowDetailsViewRoute, arguments: id);
      }
    }
  }
}
