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

  refresh() {
    getFeed();
    _controller.reset();
  }

  reachedEnd() {
    _controller.back();
  }

  onItemTap(int id, String mediaType) {
    if (mediaType == "movie") {
      _navigationService.navigateTo(MovieDetailsViewRoute, arguments: id);
    } else {
      _navigationService.navigateTo(TvShowDetailsViewRoute, arguments: id);
    }
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
    } catch (e) {
      print("error adding feed: $e");
    }
    // print(" feedlist: $_feedList");
    setBusy(false);
  }
}
