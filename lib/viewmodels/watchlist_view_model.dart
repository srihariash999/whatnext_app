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

  onMovieSelect(int id) {
    _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
  }

  getColor(String status) {
    if (status == "Watching") {
      return Colors.orange[200];
    } else if (status == "Watched") {
      return Colors.green[200];
    } else {
      return Colors.yellow[200];
    }
  }

  Future<void> onInit() async {
    setBusy(true);

    _currentUserWatchlist = _authenticationService.currentUserWatchList;
    print(" cuw : $_currentUserWatchlist");
    setBusy(false);
  }
}
