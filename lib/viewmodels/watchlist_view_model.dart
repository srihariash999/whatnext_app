import 'package:flutter/material.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
// import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class WatchlistViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List _currentUserWatchlist = [];
  List get currentUserWatchlist => _currentUserWatchlist;

  onMovieSelect(int id, String mediaType) {
    if (mediaType == "movie") {
      _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
    } else {
      _navigationService.navigateTo(TvShowDetailsViewRoute, arguments: id);
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

  Future<void> onInit() async {
    setBusy(true);

    await _authenticationService.populateCurrentUserWatchList(
        _authenticationService.currentUser.userName);
    _currentUserWatchlist = _authenticationService.currentUserWatchList;
    print(" cuw : $_currentUserWatchlist");
    setBusy(false);
  }
}
