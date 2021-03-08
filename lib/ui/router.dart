import 'package:flutter/material.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/ui/views/friends_view.dart';
import 'package:whatnext/ui/views/home_view.dart';
import 'package:whatnext/ui/views/login_view.dart';
import 'package:whatnext/ui/views/movie_details_view.dart';
import 'package:whatnext/ui/views/people_profile_view.dart';
import 'package:whatnext/ui/views/profile_view.dart';
import 'package:whatnext/ui/views/signup_view.dart';
import 'package:whatnext/ui/views/startup_view.dart';
import 'package:whatnext/ui/views/watchlist_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments;
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case StartupViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: StartUpView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case FriendsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: FriendsView(),
      );
    case MovieDetailsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MovieDetailsView(
          id: arguments,
        ),
      );
    case PersonProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PeopleProfileView(
          userName: arguments,
        ),
      );
    case WatchListViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WatchlistView(),
      );
    case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
