import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/feed.dart';
import 'package:whatnext/models/movie.dart';
import 'package:whatnext/models/tv_show.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/tmdb_service.dart';
// import 'package:whatnext/services/snackbar_service.dart';

import 'package:whatnext/providers/base_provider.dart';

class HomeProvider extends BaseProvider {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final TmdbService _tmdbService = locator<TmdbService>();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int _popPage = 1;
  int _topPage = 1;

  int _popPage2 = 1;
  int _topPage2 = 1;

  int _bottomIndex = 0;
  int get bottomIndex => _bottomIndex;

  String _tabType = "";
  String get tabType => _tabType;

  String _prevQuery = "";

  UserModel _user;
  UserModel get user => _user;

  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> get searchResults => _searchResults;

  bool _searchResultLoading = false;
  bool get searchResultLoading => _searchResultLoading;

  List<Movie> _popularMoviesList = [];
  List<Movie> get popularMoviesList => _popularMoviesList;

  List<Movie> _topRatedMoviesList = [];
  List<Movie> get topRatedMoviesList => _topRatedMoviesList;

  List<TvShow> _popularTvShowsList = [];
  List<TvShow> get popularTvShowsList => _popularTvShowsList;

  List<TvShow> _topRatedTvShowsList = [];
  List<TvShow> get topRatedTvShowsList => _topRatedTvShowsList;

  List<Feed> _feedList = [];
  List<Feed> get feedList => _feedList;

  bool _feedLoading = false;
  bool get feedLoading => _feedLoading;

  Future<void> onInit() async {
    setBusy(true);

    _tabType = 'movie';

    await getUserName();
    fetchPopularMovies();
    setState();
    fetchTopRatedMovies();
    setState();
    fetchPopularTvShows();
    setState();
    fetchTopRatedTvShows();
    setState();
    _saveDeviceToken();
    setBusy(false);
  }

  getUserName() async {
    try {
      _user = _authenticationService.currentUser;

      setState();
    } catch (e) {}
  }

  switchTabs(String tabName) {
    _tabType = tabName;
    setState();
  }

  switchPages(int index) {
    _bottomIndex = index;
    // print("_bottom Index : $_bottomIndex");
    setState();
  }

  Future logout() async {
    await _authenticationService.logout();

    _navigationService.navigateReplacement(LoginViewRoute);
  }

  navigateToFriends() {
    _navigationService.pop();
    _navigationService.navigateTo(FriendsViewRoute);
  }

  navigateToTheme() {
    _navigationService.pop();
    _navigationService.navigateTo(ThemesViewRoute);
  }

  navigateToMessages() {
    _navigationService.pop();
    _navigationService.navigateTo(MessagesViewRoute);
  }

  navigateToMessagesWithoutPopping() {
    _navigationService.navigateTo(MessagesViewRoute);
  }

  navigateToProfile() {
    _navigationService.pop();
    _navigationService.navigateTo(ProfileViewRoute);
  }

  navigateToWatchList() {
    _navigationService.pop();
    _navigationService.navigateTo(WatchListViewRoute);
  }

  navigateToWatchListWithoutPopping() {
    _navigationService.navigateTo(WatchListViewRoute);
  }

  navigateToAboutApp() {
    _navigationService.pop();
    _navigationService.navigateTo(AboutAppViewRoute);
  }

  navigateToVerticalMovieView(String type) {
    _navigationService
        .navigateTo(MovieVerticalViewRoute, arguments: {'type': type});
  }

  navigateToVerticalTvShowView(String type) {
    _navigationService
        .navigateTo(TvShowVerticalViewRoute, arguments: {'type': type});
  }

  fetchPopularMovies() async {
    var s = await _tmdbService.fetchPopularMoviesFromTmdb(_popPage);

    for (var i in s['results']) {
      _popularMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }

  fetchPopularTvShows() async {
    var s = await _tmdbService.fetchPopularTvShowsFromTmdb(_popPage2);

    for (var i in s['results']) {
      _popularTvShowsList.add(TvShow.fromJson(i));
      setState();
    }
  }

  fetchSearchReults(String query) async {
    if (_prevQuery != query) {
      var sRes = await _tmdbService.fetchSearchResultsFromTmdb(query);

      for (var i in sRes['results']) {
        _searchResults.add(
          {
            'media_type': i['media_type'],
            'item': i['media_type'] == 'movie'
                ? Movie.fromJson(i)
                : TvShow.fromJson(i),
          },
        );
      }
      _prevQuery = query;
      setState();
    }
  }

  fetchTopRatedMovies() async {
    var s = await _tmdbService.fetchTopRatedMoviesFromTmdb(_topPage);

    for (var i in s['results']) {
      _topRatedMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }

  fetchTopRatedTvShows() async {
    var s = await _tmdbService.fetchTopRatedTvShowsFromTmdb(_topPage2);

    for (var i in s['results']) {
      _topRatedTvShowsList.add(TvShow.fromJson(i));
      setState();
    }
  }

  onItemTap(int id, String mediaType) {
    if (mediaType == "movie") {
      _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
    } else {
      _navigationService.navigateTo(TvShowDetailsViewRoute, arguments: id);
    }
  }

  loadMorePopularMovies() async {
    _popPage++;
    var s = await _tmdbService.fetchPopularMoviesFromTmdb(_popPage);

    for (var i in s['results']) {
      _popularMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }

  loadMorePopularTvShows() async {
    _popPage2++;
    var s = await _tmdbService.fetchPopularTvShowsFromTmdb(_popPage2);

    for (var i in s['results']) {
      _popularTvShowsList.add(TvShow.fromJson(i));
      setState();
    }
  }

  loadMoreTopRatedMovies() async {
    _topPage++;
    var s = await _tmdbService.fetchTopRatedMoviesFromTmdb(_topPage);
    // print("s : $s");
    for (var i in s['results']) {
      _topRatedMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }

  loadMoreTopRatedTvShows() async {
    _topPage2++;
    var s = await _tmdbService.fetchPopularTvShowsFromTmdb(_topPage2);

    for (var i in s['results']) {
      _topRatedTvShowsList.add(TvShow.fromJson(i));
      setState();
    }
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    // Get the current user
    String userName = _authenticationService.currentUser.userName;

    // Get the token for this device
    String fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .doc(userName)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}
