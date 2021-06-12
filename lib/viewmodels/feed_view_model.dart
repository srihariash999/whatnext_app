import 'package:tcard/tcard.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/feed.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'package:whatnext/viewmodels/base_model.dart';

class FeedViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<Feed> _feedList = [];
  List<Feed> get feedList => _feedList;

  String _viewType = "list";
  String get viewType => _viewType;

  TCardController _controller = TCardController();
  TCardController get controller => _controller;
  Future<void> onInit() async {
    await getFeed();
  }

  moveForward() {
    _controller.forward();
  }

  moveBack() {
    _controller.back();
  }

  reset() {
    _controller.reset();
    setState();
  }

  Future<void> refresh() async {
    _feedList.clear();
    setState();
    try {
      var res = await _firestoreService.getAllFeed();
      for (var i in res) {
        // print("\n\n  feed: ${i.data()}  \n\n");
        _feedList.add(Feed.fromJson(i.data()));
      }
      _feedList = _feedList.reversed.toList();
    } catch (e) {
      print("error adding feed: $e");
    }
    // _controller.reset();
    setState();
  }

  reachedEnd() {
    _controller.back();
  }

  switchView() {
    if (_viewType == "card") {
      _viewType = 'list';
      setState();
    } else {
      _viewType = 'card';
      setState();
    }
  }

  onItemTap(int id, String mediaType) {
    if (mediaType == "movie") {
      _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
    } else {
      _navigationService.navigateTo(TvShowDetailsViewRoute, arguments: id);
    }
  }

  navigateToNewPost() {
    _navigationService.navigateTo(NewPostViewRoute);
  }

  getFeed() async {
    setBusy(true);
    _feedList.clear();
    try {
      var res = await _firestoreService.getAllFeed();
      for (var i in res) {
        // print("\n\n  feed: ${i.data()}  \n\n");
        _feedList.add(Feed.fromJson(i.data()));
      }
      _feedList = _feedList.reversed.toList();
    } catch (e) {
      print("error adding feed: $e");
    }
    // print(" feedlist: $_feedList");
    setBusy(false);
  }
}
