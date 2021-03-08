import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final NavigationService _navigationService = locator<NavigationService>();

  UserModel _user;
  List _userWatchlist;
  List get userWatchList => _userWatchlist;
  UserModel get user => _user;

  List _peopleToShow = [];
  List get peopleToShow => _peopleToShow;

  int _pageSelected = 0;
  int get pageSelected => _pageSelected;

  onInit() async {
    setBusy(true);
    await fetchUser();
    fetchUserWatchlist();
    _peopleToShow = _user.followersList;
    setBusy(false);
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
}
