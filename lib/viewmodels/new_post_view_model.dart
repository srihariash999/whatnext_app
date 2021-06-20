import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/movie.dart';
import 'package:whatnext/models/tv_show.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/tmdb_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class NewPostViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final TmdbService _tmdbService = locator<TmdbService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  bool _isItemSelected = false;
  bool get isItemSelected => _isItemSelected;

  String _itemType = "";
  String get itemType => _itemType;

  Movie _movie;
  Movie get movie => _movie;

  TvShow _tvShow;
  TvShow get tvShow => _tvShow;

  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> get searchResults => _searchResults;

  String _prevQuery = "";

  bool _isSubmitLoading = false;
  bool get isSubmitLoading => _isSubmitLoading;

  goToSearchView() async {
    var result =
        await _navigationService.navigateTo(NewPostItemSearchViewRoute);
    _itemType = result['media_type'];
    if (result['media_type'] == 'movie') {
      _movie = result['item'];
    } else {
      _tvShow = result['item'];
    }
    _isItemSelected = true;
    setState();
  }

  fetchSearchReults(String query) async {
    print(" query got : $query");
    if (_prevQuery != query) {
      print(" diff query");
      var sRes = await _tmdbService.fetchSearchResultsFromTmdb(query);
      _searchResults = [];
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
    } else {
      print('same query : $_prevQuery   $query');
    }
  }

  onItemSelect({@required result}) {
    print("result : $result");

    _navigationService.pop(arguments: result);
  }

  createPost({@required String postBody}) async {
    print("type : $itemType   seelcted: $isItemSelected  ");
    _isSubmitLoading = true;
    setState();
    if (itemType != "") // Case where user selected a movie/tv show for a post.
    {
      UserModel _user = _authenticationService.currentUser;

      if (_itemType == "movie") {
        var res = await _firestoreService.createNewPost(
          name: movie.title,
          id: movie.id,
          posterPath: movie.posterPath ?? movie.backdropPath,
          userName: _user.userName,
          postBody: postBody,
          type: itemType,
          user: _user,
        );
        print(" res : $res");
        if (res['res'] == true) {
          _navigationService.pop();
        } else {}
      } else {
        var res = await _firestoreService.createNewPost(
          name: tvShow.name,
          id: tvShow.id,
          posterPath: tvShow.posterPath ?? tvShow.backdropPath,
          userName: _user.userName,
          postBody: postBody,
          type: itemType,
          user: _user,
        );
        if (res['res'] == true) {
          _navigationService.pop();
        } else {}
        print(" res : $res");
      }
    } else // Case where user did not select any movie or tv show.
    {
      UserModel _user = _authenticationService.currentUser;

      var res = await _firestoreService.createNewPost(
        name: null,
        id: null,
        posterPath: null,
        userName: _user.userName,
        postBody: postBody,
        type: null,
        user: _user,
      );
      print(" res : $res");
      if (res['res'] == true) {
        _navigationService.pop();
      } else {}
    }
    _isSubmitLoading = false;
    setState();

    print(" post created");
  }

  showPostBodyErrorToast() {
    Fluttertoast.showToast(
        msg: "Post body cannot be empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.70),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
