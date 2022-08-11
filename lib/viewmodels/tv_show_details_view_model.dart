import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/picture.dart';
import 'package:whatnext/models/review.dart';
import 'package:whatnext/models/tv_credit.dart';
import 'package:whatnext/models/tv_show.dart';
import 'package:whatnext/models/tv_show_details.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'package:whatnext/services/tmdb_service.dart';
import 'package:whatnext/ui/views/reviews_view.dart';

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

  List<TvCredit> _creditsList = [];
  List<TvCredit> get creditList => _creditsList;

  List<TvShow> _similarTvShows = [];
  List<TvShow> get similarTvShows => _similarTvShows;

  List<TvShow> _recommendedTvShows = [];
  List<TvShow> get recommendedTvShows => _recommendedTvShows;

  List<Picture> _pictures = [];
  List<Picture> get pictures => _pictures;

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  bool _isChanged = false;

  Future onInit(int id) async {
    setBusy(true);
    print("id : $id");

    var det = await _tmdbService.fetchTvShowDetails(id);

    _tvShowDetails = TvShowDetails.fromJson(det);
    await ifTvShowAdded(id);
    setBusy(false);
    getCast(id);
    getSimilarTvShows(id);
    getRecommendedTvShows(id);
    getPictures(id);
    getReviews(id);
  }

// This function determines whether the tv show is added in the user's list or not.
  ifTvShowAdded(int tvId) async {
    for (var element in _authenticationService.currentUserWatchList) {
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

  getCast(int id) async {
    var castRes = await _tmdbService.fetchTvCast(id);

    for (var i in castRes['cast']) {
      _creditsList.add(TvCredit.fromJson(i));
    }
    setState();
  }

  getSimilarTvShows(int id) async {
    var similarRes = await _tmdbService.fetchSimilarTvShows(id);

    for (var i in similarRes['results']) {
      _similarTvShows.add(TvShow.fromJson(i));
    }
    setState();
  }

  getRecommendedTvShows(int id) async {
    var recommendedRes = await _tmdbService.fetchTvShowRecommendations(id);

    for (var i in recommendedRes['results']) {
      _recommendedTvShows.add(TvShow.fromJson(i));
    }
    setState();
  }

  getPictures(int id) async {
    var picturesRes = await _tmdbService.fetchTvPictures(id);

    for (var i in picturesRes['backdrops']) {
      _pictures.add(Picture.fromJson(i));
    }
    for (var i in picturesRes['posters']) {
      _pictures.add(Picture.fromJson(i));
    }
    setState();
  }

  getReviews(int id) async {
    var reviewsRes = await _tmdbService.fetchReviews(id, 'tv');
    print("review res : $reviewsRes");
    for (var i in reviewsRes['results']) {
      _reviews.add(Review.fromJson(i));
    }

    setState();
  }

  changeChoice(String choice) {
    _choice = choice;
    setState();
  }

  onTvShowTap(int id, String mediaType) {
    _navigationService.navigateTo(TvShowDetailsViewRoute, arguments: id);
  }

  onShareTap() async {
    _isBeingAdded = true;
    setState();
    try {
      var request = await HttpClient().getUrl(Uri.parse(
          'https://image.tmdb.org/t/p/w500${_tvShowDetails.posterPath}'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://whatnext.page.link',
        link: Uri.parse(
            'https://whatnext.page.link/details?type=tv&id=${_tvShowDetails.id}'),
        androidParameters: AndroidParameters(
          packageName: 'app.zepplaud.whatnext',
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        iosParameters: IosParameters(
          bundleId: 'app.zepplaud.whatnext',
          minimumVersion: '0',
        ),
      );

      Uri url;

      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;

      print("I am the deep link");
      print(url.toString());
      await Share.file('${_tvShowDetails.originalName}',
          '${_tvShowDetails.name}.png', bytes, 'image/jpg',
          text: "Checkout this tv show '${_tvShowDetails.name}' at : $url ");
    } catch (e) {
      print('error: $e');
    }
    _isBeingAdded = false;
    setState();

    return;
  }

  navigateToReviewsScreen() {
    _navigationService.navigateTo(
      ReviewsScreenRoute,
      arguments: ReviewsViewArguments(
        type: 'movie',
        reviews: _reviews.reversed.toList(),
        title: _tvShowDetails.name,
      ),
    );
  }

  onTvStatusChange() async {
    //escape multiple presses of the same button.
    if (!_isBeingAdded) {
      //Signal busy status.
      _isBeingAdded = true;
      setState();

      //Remove the tv show from the user's list.

      var s = await _firestoreService.removeFromUserWatchList(
        _tvShowDetails,
        _authenticationService.currentUser.userName,
      );

      if (s['res'] == true) {
        await _authenticationService.populateCurrentUserWatchList(
            _authenticationService.currentUser.userName);
        ifTvShowAdded(_tvShowDetails.id);
      }

      //Now add the tv show to the user's list again, with updated staus.

      s = await _firestoreService.addToUserWatchList(
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

        // set the bool, that says the tv show is added.
        _isTvShowAdded = true;
        //indicate that the state is not busy anymore.
        _isBeingAdded = false;
        _isChanged = true;
        setState();
        _navigationService.pop();
      }
    }
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
          _isChanged = true;
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
            _isChanged = true;
            setState();
            _navigationService.pop();
          }
        }
      }
    }
  }

  onBackTap() {
    _navigationService.pop(arguments: _isChanged);
  }
}
