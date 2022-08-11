import 'package:flutter/material.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/providers/base_provider.dart';

class PeopleProfileProvider extends BaseProvider {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  UserModel _person;
  List _personWatchlist;
  List get personWatchList => _personWatchlist;
  UserModel get person => _person;

  List _peopleToShow = [];
  List get peopleToShow => _peopleToShow;

  int _pageSelected = 0;
  int get pageSelected => _pageSelected;
  // String _userName;

  Future<void> onInit(String userName) async {
    // _userName = userName;
    setBusy(true);
    await fetchPerson(userName);
    await fetchPersonWatchlist(userName);
    _peopleToShow = _person.followersList;
    setBusy(false);
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

  changePage(int i) {
    _pageSelected = i;
    if (i == 0) {
      _peopleToShow = _person.followersList;
      print("_peopleToShow : $_peopleToShow");
    } else {
      _peopleToShow = _person.followingList;
      print("_peopleToShow : $_peopleToShow");
    }
    setState();
  }

  fetchPerson(String userName) async {
    _person = await _firestoreService.getUser(userName);
  }

  fetchPersonWatchlist(String userName) async {
    _personWatchlist = await _firestoreService.getUserWatchList(userName);
  }
}
