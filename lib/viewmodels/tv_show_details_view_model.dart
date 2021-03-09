import 'package:whatnext/locator.dart';
import 'package:whatnext/models/tv_show_details.dart';
// import 'package:whatnext/services/authentication_service.dart';

// import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'package:whatnext/services/tmdb_service.dart';

import 'package:whatnext/viewmodels/base_model.dart';

class TvShowDetailsViewModel extends BaseModel {
  final TmdbService _tmdbService = locator<TmdbService>();
  final NavigationService _navigationService = locator<NavigationService>();
  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();

  // final FirestoreService _firestoreService = locator<FirestoreService>();

  bool _isMovieAdded = false;
  bool get isMovieAdded => _isMovieAdded;

  TvShowDetails _tvShowDetails = TvShowDetails();
  TvShowDetails get movieDetails => _tvShowDetails;

  String _choice = "Select a choice";
  String get choice => _choice;

  bool _showError = false;
  bool get showError => _showError;

  Future onInit(int id) async {
    setBusy(true);
    print("id : $id");

    var det = await _tmdbService.fetchTvShowDetails(id);
    print("det : $det");
    _tvShowDetails = TvShowDetails.fromJson(det);
    // await ifMovieAdded(id);
    setBusy(false);
  }

  // ifMovieAdded(int movieId) async {
  //   print(" watchist: ${_authenticationService.currentUserWatchList}");
  //   for (var element in _authenticationService.currentUserWatchList) {
  //     print(">>>>>>>>>>>${element['movieId']}");
  //     if (element['movieId'] == movieId) {
  //       print(" found movie");
  //       _isMovieAdded = true;
  //       setState();
  //       return;
  //     }
  //   }
  //   await _authenticationService.populateCurrentUserWatchList(
  //       _authenticationService.currentUser.userName);
  //   _isMovieAdded = false;
  //   setState();
  //   return;
  // }

  // changeChoice(String choice) {
  //   _choice = choice;
  //   setState();
  // }

  // onAddTap() async {
  //   if (_isMovieAdded) {
  //     var s = await _firestoreService.removeFromUserWatchList(
  //       _movieDetails,
  //       _authenticationService.currentUser.userName,
  //     );

  //     if (s['res'] == true) {
  //       await _authenticationService.populateCurrentUserWatchList(
  //           _authenticationService.currentUser.userName);
  //       ifMovieAdded(_movieDetails.id);
  //       _isMovieAdded = false;
  //       setState();
  //       _navigationService.pop();
  //     }
  //   } else {
  //     if (_choice == "Select a choice") {
  //       _showError = true;
  //       setState();
  //     } else {
  //       var s = await _firestoreService.addToUserWatchList(
  //           movie: _movieDetails,
  //           userName: _authenticationService.currentUser.userName,
  //           status: _choice);

  //       if (s['res'] == true) {
  //         await _authenticationService.populateCurrentUserWatchList(
  //             _authenticationService.currentUser.userName);
  //         ifMovieAdded(_movieDetails.id);
  //         _isMovieAdded = true;
  //         setState();
  //         _navigationService.pop();
  //       }
  //     }
  //   }
  // }

  onBackTap() {
    _navigationService.pop();
  }
}
