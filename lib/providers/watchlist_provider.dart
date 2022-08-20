import 'package:flutter/material.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
// import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/providers/base_provider.dart';

class WatchlistProvider extends BaseProvider {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List _currentUserWatchlist = [];
  List _currentUserWatchlistTemp = [];
  List get currentUserWatchlist => _currentUserWatchlistTemp;

  int _watchedCount = 0;
  int get watchedCount => _watchedCount;

  int _watchingCount = 0;
  int get watchingCount => _watchingCount;

  int _wantToWatchCount = 0;
  int get wantToWatchCount => _wantToWatchCount;

  onMovieSelect(int id, String mediaType) async {
    if (mediaType == "movie") {
      var n = await _navigationService.navigateTo(MovieDetailsViewRoute,
          arguments: id);
      // print(' n is : $n');
      if (n != null && n == true) {
        onInit();
      }
    } else {
      var n = await _navigationService.navigateTo(TvShowDetailsViewRoute,
          arguments: id);
      // print(' n is : $n');
      if (n != null && n == true) {
        onInit();
      }
    }
  }

  getColor(String status) {
    if (status == "Watching") {
      return Colors.yellow[600];
    } else if (status == "Watched") {
      return Colors.green[600];
    } else {
      return Colors.red[600];
    }
  }

  onMovieFilter(String status) async {
    _currentUserWatchlistTemp = [];
    for (var i in _currentUserWatchlist) {
      if (i['status'] == status) {
        _currentUserWatchlistTemp.add(i);
      }
    }
    setState();
  }

  Future<void> onInit() async {
    setBusy(true);
    _watchedCount = _watchingCount = _wantToWatchCount = 0;
    await _authenticationService.populateCurrentUserWatchList(
        _authenticationService.currentUser.userName);
    _currentUserWatchlist =
        _authenticationService.currentUserWatchList.reversed.toList();
    _currentUserWatchlistTemp = _currentUserWatchlist;
    for (var i in _currentUserWatchlist) {
      if (i['status'].toString() == "Watching") {
        _watchingCount += 1;
      } else if (i['status'].toString() == "Watched") {
        _watchedCount += 1;
      } else {
        _wantToWatchCount += 1;
      }
    }
    // print(" cuw : $_currentUserWatchlist");
    setBusy(false);
  }
}
