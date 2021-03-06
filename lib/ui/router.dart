import 'package:flutter/material.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/ui/views/about_app_view.dart';
import 'package:whatnext/ui/views/chat_view.dart';
import 'package:whatnext/ui/views/friends_view.dart';
import 'package:whatnext/ui/views/home_view.dart';
import 'package:whatnext/ui/views/login_view.dart';
import 'package:whatnext/ui/views/messages_view.dart';
import 'package:whatnext/ui/views/movie_details_view.dart';
import 'package:whatnext/ui/views/movies_vertical_view.dart';
import 'package:whatnext/ui/views/new_post_item_select_view.dart';
import 'package:whatnext/ui/views/new_post_view.dart';
import 'package:whatnext/ui/views/people_profile_view.dart';
import 'package:whatnext/ui/views/profile_view.dart';
import 'package:whatnext/ui/views/reviews_view.dart';
import 'package:whatnext/ui/views/signup_view.dart';
import 'package:whatnext/ui/views/startup_view.dart';
import 'package:whatnext/ui/views/themes_view.dart';
import 'package:whatnext/ui/views/tv_show_details_view.dart';
import 'package:whatnext/ui/views/tv_shows_vertical_view.dart';
import 'package:whatnext/ui/views/video_player_view.dart';
import 'package:whatnext/ui/views/watchlist_view.dart';
import 'package:whatnext/ui/views/reset_view.dart';

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
    case TvShowDetailsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TvShowDetailsView(
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

    case ThemesViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ThemesView(),
      );

    case VideoPlayerViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: VideoPlayerView(
          videoId: arguments,
        ),
      );

    case ResetPasswordViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ResetView(),
      );

    case ReviewsScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ReviewsView(
          reviewViewArguments: settings.arguments,
        ),
      );

    case NewPostViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: NewPostView(),
      );

    case NewPostItemSearchViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: NewPostItemSearchView(),
      );

    case MovieVerticalViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MovieVerticalView(
          arguments: settings.arguments,
        ),
      );

    case TvShowVerticalViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TvShowVerticalView(
          arguments: settings.arguments,
        ),
      );

    case AboutAppViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AboutAppView(),
      );

    case MessagesViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MessagesView(),
      );

    case ChatViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChatView(
          toUserName: settings.arguments,
        ),
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
