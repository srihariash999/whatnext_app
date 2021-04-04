import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/movie.dart';
import 'package:whatnext/models/movie_credit.dart';
import 'package:whatnext/models/movie_details.dart';
import 'package:whatnext/models/picture.dart';
import 'package:whatnext/models/video.dart';
import 'package:whatnext/services/authentication_service.dart';

import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'package:whatnext/services/tmdb_service.dart';

import 'package:whatnext/viewmodels/base_model.dart';


class MovieDetailsViewModel extends BaseModel {
  final TmdbService _tmdbService = locator<TmdbService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();
  
  bool _isMovieAdded = false;
  bool get isMovieAdded => _isMovieAdded;

  MovieDetails _movieDetails = MovieDetails();
  MovieDetails get movieDetails => _movieDetails;

  String _choice = "Select a choice";
  String get choice => _choice;

  bool _showError = false;
  bool get showError => _showError;

  bool _isBeingAdded = false;
  bool get isBeingAdded => _isBeingAdded;

  List<MovieCredit> _creditsList = [];
  List<MovieCredit> get creditList => _creditsList;

  List<Movie> _similarMovies = [];
  List<Movie> get similarMovies => _similarMovies;

  List<Movie> _recommendedMovies = [];
  List<Movie> get recommendedMovies => _recommendedMovies;

  Video _video;
  Video get video => _video;

  List<Picture> _pictures = [];
  List<Picture> get pictures => _pictures;

  Future onInit(int id) async {
    setBusy(true);
    print("id : $id");

    var det = await _tmdbService.fetchMovieDetails(id);
    print("det : $det");
    _movieDetails = MovieDetails.fromJson(det);
    await ifMovieAdded(id);
    setBusy(false);
    getCast(id);
    getSimilarMovies(id);
    getRecommendedMovies(id);
    getVideo(id);
    getPictures(id);
  }

  getCast(int id) async {
    var castRes = await _tmdbService.fetchMovieCast(id);

    for (var i in castRes['cast']) {
      _creditsList.add(MovieCredit.fromJson(i));
    }
    setState();
  }

  getSimilarMovies(int id) async {
    var similarRes = await _tmdbService.fetchSimilarMovies(id);

    for (var i in similarRes['results']) {
      _similarMovies.add(Movie.fromJson(i));
    }
    setState();
  }

  getRecommendedMovies(int id) async {
    var recommendedRes = await _tmdbService.fetchMovieRecommendations(id);

    for (var i in recommendedRes['results']) {
      _recommendedMovies.add(Movie.fromJson(i));
    }
    setState();
  }

  getVideo(int id) async {
    var videoRes = await _tmdbService.fetchVideosofMovie(id);

    for (var i in videoRes['results']) {
      if (i['type'] == "Trailer" && i['site'] == "YouTube") {
        _video = Video.fromJson(i);
        break;
      }
    }
    setState();
  }

  getPictures(int id) async {
    var picturesRes = await _tmdbService.fetchMoviePictures(id);
    print("picres: $picturesRes");
    for (var i in picturesRes['backdrops']) {
      _pictures.add(Picture.fromJson(i));
    }
    for (var i in picturesRes['posters']) {
      _pictures.add(Picture.fromJson(i));
    }
    setState();
  }

  ifMovieAdded(int movieId) async {
    print(" watchist: ${_authenticationService.currentUserWatchList}");
    for (var element in _authenticationService.currentUserWatchList) {
      print(">>>>>>>>>>>${element['movieId']}");
      if (element['id'] == movieId) {
        print(" found movie");
        _isMovieAdded = true;
        setState();
        return;
      }
    }
    await _authenticationService.populateCurrentUserWatchList(
        _authenticationService.currentUser.userName);
    _isMovieAdded = false;
    setState();
    return;
  }

  changeChoice(String choice) {
    _choice = choice;
    setState();
  }

  onShareTap() async {
    _isBeingAdded = true;
    setState();
    try {
      var request = await HttpClient().getUrl(Uri.parse(
          'https://image.tmdb.org/t/p/w500${_movieDetails.posterPath}'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('${_movieDetails.title}', '${_movieDetails.title}.png',
          bytes, 'image/jpg',
          text:
              "Checkout this movie '${_movieDetails.title}' at : https://whatnext.app/m/${_movieDetails.id} ");
    } catch (e) {
      print('error: $e');
    }
    _isBeingAdded = false;
    setState();

    return;
  }

  onMovieTap(int id, String mediaType) {
    _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
  }

  navigateToVideoPlayer() {
    _navigationService.navigateTo(VideoPlayerViewRoute, arguments: _video.key);
  }

  onAddTap() async {
    if (!_isBeingAdded) {
      print(" on tap pressed");
      if (_isMovieAdded) {
        _isBeingAdded = true;
        setState();

        var s = await _firestoreService.removeFromUserWatchList(
          _movieDetails,
          _authenticationService.currentUser.userName,
        );

        if (s['res'] == true) {
          await _authenticationService.populateCurrentUserWatchList(
              _authenticationService.currentUser.userName);
          ifMovieAdded(_movieDetails.id);
          _isMovieAdded = false;
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
              name: _movieDetails.title,
              id: _movieDetails.id,
              posterPath: _movieDetails.posterPath,
              userName: _authenticationService.currentUser.userName,
              status: _choice,
              type: 'movie');

          if (s['res'] == true) {
            await _authenticationService.populateCurrentUserWatchList(
                _authenticationService.currentUser.userName);
            ifMovieAdded(_movieDetails.id);
            _isMovieAdded = true;
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
