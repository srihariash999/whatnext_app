import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/feed.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final NavigationService _navigationService = locator<NavigationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();

  UserModel _user;
  List _userWatchlist;
  List get userWatchList => _userWatchlist;
  UserModel get user => _user;

  List _peopleToShow = [];
  List get peopleToShow => _peopleToShow;

  int _pageSelected = 0;
  int get pageSelected => _pageSelected;

  List<Feed> _userFeedPosts = [];
  List<Feed> get userFeedPosts => _userFeedPosts;

  List _feedIds = [];

  TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  Future<void> onInit() async {
    setBusy(true);
    _feedIds = [];
    _userFeedPosts = [];
    await fetchUser();
    fetchUserWatchlist();
    _peopleToShow = _user.followersList;
    _controller.text = _user.fullName;
    setBusy(false);
    fetchUserFeedPosts();
  }

  changePage(int i) {
    _pageSelected = i;
    if (i == 0) {
      _peopleToShow = _authenticationService.currentUser.followersList;
      print("_peopleToShow : $_peopleToShow");
    } else {
      _peopleToShow = _authenticationService.currentUser.followingList;
      print("_peopleToShow : $_peopleToShow");
    }
    setState();
  }

  navigateToPeopleProfileView(String userName) {
    _navigationService.navigateTo(PersonProfileViewRoute, arguments: userName);
  }

  fetchUser() {
    _user = _authenticationService.currentUser;
  }

  fetchUserWatchlist() {
    _userWatchlist = _authenticationService.currentUserWatchList;
  }

  fetchUserFeedPosts() async {
    List feedIds = await _firestoreService.getUsersPosts(
        userName: _authenticationService.currentUser.userName);
    _feedIds = feedIds;
    setState();
    print("_feed ids are : $_feedIds");
    for (var id in feedIds) {
      Feed _feedPost = await _firestoreService.getFeedPostById(id: id);

      if (_feedPost != null) {
        _userFeedPosts.add(_feedPost);
        setState();
      } else {
        _userFeedPosts.add(Feed());
      }
    }
  }

  deleteFeedpost({@required int index}) async {
    await _firestoreService.deleteFeedPostById(
        id: _feedIds[index],
        userName: _authenticationService.currentUser.userName);
    _navigationService.pop();
    onInit();
  }

  canceldelete() {
    _navigationService.pop();
  }

  changeName() async {
    if (_controller.text.length > 0) {
      bool _upd = await _firestoreService.updateDisplayName(
          userName: _user.userName, newName: _controller.text);

      if (_upd) {
        Fluttertoast.showToast(
            msg: "Display name updated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.70),
            textColor: Colors.white,
            fontSize: 16.0);
        _navigationService.pop();
        await _authenticationService.isUserLoggedIn();
        onInit();
      } else {
        Fluttertoast.showToast(
            msg: "Cannot update display name right now.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.70),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Name cannot be empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.70),
          textColor: Colors.white,
          fontSize: 16.0);
      _controller.text = _user.fullName;
    }
  }
}
