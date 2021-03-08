import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/movie.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/tmdb_service.dart';
// import 'package:whatnext/services/snackbar_service.dart';

import 'package:whatnext/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final TmdbService _tmdbService = locator<TmdbService>();

  int _popPage = 1;
  int _topPage = 1;

  int _tab = 0;
  int get currentTab => _tab;

  String _prevQuery = "";

  String _userName = " ...  ";
  String get userName => _userName;

  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  bool _searchResultLoading = false;
  bool get searchResultLoading => _searchResultLoading;

  List<Movie> _popularMoviesList = [];
  List<Movie> get popularMoviesList => _popularMoviesList;

  List<Movie> _topRatedMoviesList = [];
  List<Movie> get topRatedMoviesList => _topRatedMoviesList;

  onInit() async {
    setBusy(true);

    fetchPopularMovies();
    fetchTopRatedMovies();
    setBusy(false);
  }

  getUserName() {
    try {
      _userName = '@' + _authenticationService.currentUser.userName;
      setState();
    } catch (e) {
      _userName = '@ ---';
      setState();
    }
  }

  // final _snackbarService = locator<SnackbarService>();

  Future logout() async {
    bool logoutResult = await _authenticationService.logout();

    if (logoutResult) {
      // _snackbarService.showSnackBar(message: "Logout Successful !");
      // await Future.delayed(Duration(seconds: 1));
      _navigationService.navigateReplacement(LoginViewRoute);
    } else {
      // _snackbarService.showSnackBar(message: "Could not logout !");
    }
  }

  changeTab(int newTab) {
    _tab = newTab;
    setState();
  }

  navigateToFriends() {
    _navigationService.navigateTo(FriendsViewRoute);
  }

  navigateToProfile() {
    _navigationService.navigateTo(ProfileViewRoute);
  }

  navigateToWatchList() {
    _navigationService.navigateTo(WatchListViewRoute);
  }

  fetchPopularMovies() async {
    var s = await _tmdbService.fetchPopularMoviesFromTmdb(_popPage);
    print("s : $s");
    for (var i in s['results']) {
      _popularMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }

  fetchSearchReults(String query) async {
    if (_prevQuery != query) {
      print(" res");
      var sRes = await _tmdbService.fetchSearchResultsFromTmdb(query);
      print(" sres : $sRes");

      for (var i in sRes['results']) {
        _searchResults.add(Movie.fromJson(i));
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

    print(" toprated movies : $_topRatedMoviesList");
  }

  onMovieTap(int id) {
    _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
  }

  loadMorePopularMovies() async {
    _popPage++;
    var s = await _tmdbService.fetchPopularMoviesFromTmdb(_popPage);
    print("s : $s");
    for (var i in s['results']) {
      _popularMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }

  loadMoreTopRatedMovies() async {
    _topPage++;
    var s = await _tmdbService.fetchTopRatedMoviesFromTmdb(_popPage);
    print("s : $s");
    for (var i in s['results']) {
      _topRatedMoviesList.add(Movie.fromJson(i));
      setState();
    }
  }
}
