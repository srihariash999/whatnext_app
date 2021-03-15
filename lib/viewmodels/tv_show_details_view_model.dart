import 'package:whatnext/locator.dart';
import 'package:whatnext/models/tv_show_details.dart';
import 'package:whatnext/services/authentication_service.dart';

import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'package:whatnext/services/tmdb_service.dart';

import 'package:whatnext/viewmodels/base_model.dart';

class TvShowDetailsViewModel extends BaseModel {
  final TmdbService _tmdbService = locator<TmdbService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();

  bool _isTvShowAdded = false;
  bool get isMovieAdded => _isTvShowAdded;

  TvShowDetails _tvShowDetails = TvShowDetails();
  TvShowDetails get movieDetails => _tvShowDetails;

  String _choice = "Select a choice";
  String get choice => _choice;

  bool _showError = false;
  bool get showError => _showError;

  bool _isBeingAdded = false;
  bool get isBeingAdded => _isBeingAdded;

  Future onInit(int id) async {
    setBusy(true);
    print("id : $id");

    var det = await _tmdbService.fetchTvShowDetails(id);
    print("det : $det");
    _tvShowDetails = TvShowDetails.fromJson(det);
    await ifTvShowAdded(id);
    setBusy(false);
  }

  ifTvShowAdded(int tvId) async {
    print(" watchist: ${_authenticationService.currentUserWatchList}");
    for (var element in _authenticationService.currentUserWatchList) {
      print(">>>>>>>>>>>${element['id']}");
      if (element['id'] == tvId) {
        print(" found movie");
        _isTvShowAdded = true;
        setState();
        return;
      }
    }
    await _authenticationService.populateCurrentUserWatchList(
        _authenticationService.currentUser.userName);
    _isTvShowAdded = false;
    setState();
    return;
  }

  changeChoice(String choice) {
    _choice = choice;
    setState();
  }

  onAddTap() async {
    if (!_isBeingAdded) {
      if (_isTvShowAdded) {
        _isBeingAdded = true;
        setState();
        var s = await _firestoreService.removeFromUserWatchList(
          _tvShowDetails,
          _authenticationService.currentUser.userName,
        );

        if (s['res'] == true) {
          await _authenticationService.populateCurrentUserWatchList(
              _authenticationService.currentUser.userName);
          ifTvShowAdded(_tvShowDetails.id);
          _isTvShowAdded = false;
          _isBeingAdded = false;
          setState();
          _navigationService.pop();
        }
      } else {
        if (_choice == "Select a choice") {
          _showError = true;
          setState();
        } else {
          _isBeingAdded = true;
          setState();
          var s = await _firestoreService.addToUserWatchList(
              name: _tvShowDetails.originalName,
              id: _tvShowDetails.id,
              posterPath: _tvShowDetails.posterPath,
              type: 'tv',
              userName: _authenticationService.currentUser.userName,
              status: _choice);

          if (s['res'] == true) {
            await _authenticationService.populateCurrentUserWatchList(
                _authenticationService.currentUser.userName);
            ifTvShowAdded(_tvShowDetails.id);
            _isTvShowAdded = true;
            _isBeingAdded = false;
            setState();
            _navigationService.pop();
          }
        }
      }
    }
  }

  onBackTap() {
    _navigationService.pop();
  }
}
