import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatnext/constants/enums.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/providers/base_provider.dart';

class FriendsProvider extends BaseProvider {
  final FirestoreService _fireStoreService = locator<FirestoreService>();

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<UserModel> _allUsers = [];
  List<UserModel> _allUsersToDisplay = [];
  List<FriendStatus> _usersFriendStatus = [];
  List<FriendStatus> _usersFriendStatusToDisplay = [];
  List<FriendStatus> get usersFriendStatus => _usersFriendStatusToDisplay;
  List<UserModel> get allUsers => _allUsersToDisplay;

  List<String> _currentUserFollowing = [];
  List<String> _currentUserFollowers = [];

  onInit() async {
    if (!busy) {
      setBusy(true);
      _currentUserFollowing = [];
      _currentUserFollowers = [];
      for (var i in _authenticationService.currentUser.followingList) {
        _currentUserFollowing.add(i['userName']);
      }
      for (var i in _authenticationService.currentUser.followersList) {
        _currentUserFollowers.add(i['userName']);
      }

      await getAllUsers();
      setBusy(false);
    }
  }

  searchFilter(String query) {
    print(" this is query : $query");
    if (query.length > 0) {
      _allUsersToDisplay = [];
      _usersFriendStatusToDisplay = [];
      for (var i in _allUsers) {
        if (i.fullName.toLowerCase().contains(query.toLowerCase()) ||
            i.userName.toLowerCase().contains(query.toLowerCase())) {
          _allUsersToDisplay.add(i);
          _usersFriendStatusToDisplay
              .add(_usersFriendStatus[_allUsers.indexOf(i)]);
        }
      }
      setState();
    } else {
      _allUsersToDisplay = _allUsers;
      _usersFriendStatusToDisplay = _usersFriendStatus;
      setState();
    }
  }

  getAllUsers() async {
    _allUsers = [];
    _allUsersToDisplay = [];
    _usersFriendStatus = [];
    _usersFriendStatusToDisplay = [];

    List<QueryDocumentSnapshot> snap = await _fireStoreService.getAllUsers();

    for (var i in snap) {
      // print(i.data());
      Object data = i.data();
      if (i['userName'] != _authenticationService.currentUser.userName) {
        UserModel u = UserModel(
            id: (data as Map)['id'],
            fullName: (data as Map)['fullName'],
            email: (data as Map)['email'],
            // userRole: (data as Map)['userRole'],
            userName: (data as Map)['userName'],
            followersList: (data as Map)['followersList'],
            followingList: (data as Map)['followingList'],
            profilePicture: (data as Map)['profilePicture']);
        FriendStatus f = getFriendStatus(u);
        _allUsers.add(u);
        _allUsersToDisplay.add(u);
        _usersFriendStatus.add(f);
        _usersFriendStatusToDisplay.add(f);
        setState();
      } else {
        _authenticationService.setCurrentUser(
          UserModel(
            id: (data as Map)['id'],
            fullName: (data as Map)['fullName'],
            email: (data as Map)['email'],
            // userRole: (data as Map)['userRole'],
            userName: (data as Map)['userName'],
            followersList: (data as Map)['followersList'],
            followingList: (data as Map)['followingList'],
            profilePicture: (data as Map)['profilePicture'],
          ),
        );
      }
    }
    // print(" users list : $usersList");
    // print("friends : $_usersFriendStatus");
  }

  FriendStatus getFriendStatus(UserModel userToCheck) {
    if (_currentUserFollowing.contains(userToCheck.userName)) {
      return FriendStatus.following;
    } else {
      return FriendStatus.available;
    }
  }

  navigateToPeopleProfileView(String userName) {
    _navigationService.navigateTo(PersonProfileViewRoute, arguments: userName);
  }

  friendAction(UserModel user, FriendStatus fs) async {
    // print(" rec fs : $fs");
    // ~ ~ ~ follow a person.
    if (fs == FriendStatus.available) {
      // intention : update the interested user's followers list and current user's following list
      UserModel _currUser = _authenticationService.currentUser;

      UserModel _toUser = user;

      _currUser.followingList.add(
        {
          'userName': _toUser.userName,
          'fullName': _toUser.fullName,
          'isFriend': false,
          'id': _toUser.id
        },
      );

      await _fireStoreService.updateUserFriends(_currUser);

      _toUser.followersList.add(
        {
          'userName': _currUser.userName,
          'fullName': _currUser.fullName,
          'isFriend': false,
          'id': _currUser.id
        },
      );

      await _fireStoreService.updateUserFriends(_toUser);
      // print(
      //     " index : ${_allUsers.indexOf(user)}    --  ${_allUsersToDisplay.indexOf(user)}  ");
      _allUsers[_allUsers.indexOf(user)] = _toUser;
      _allUsersToDisplay[_allUsersToDisplay.indexOf(user)] = _toUser;

      _usersFriendStatus[_allUsers.indexOf(user)] = FriendStatus.following;
      _usersFriendStatusToDisplay[_allUsersToDisplay.indexOf(user)] =
          FriendStatus.following;

      setState();
      var res = await _fireStoreService.getuserToken(_toUser.userName);
      if (res['tokenAvailable']) {
        _fireStoreService.sendNotification(
            token: res['token'],
            body: "You have a new follower: @${_currUser.userName}");
      } else {
        // print(' no token');
      }
      return true;
    }
    // ~ ~ ~ unfollow a person.
    else if (fs == FriendStatus.following) {
      // trying to do : delete the interested user's name from current users following and delete curr user's from to user's followers.

      UserModel _currUser = _authenticationService.currentUser;

      UserModel _toUser = user;

      // print(" before \n");
      // print("all users : $_allUsers");
      // print("all users to disp: $_allUsersToDisplay");
      // print("all friends: $_usersFriendStatus");
      // print("friend disp: $_usersFriendStatusToDisplay");
      // print("**** \n");

      var _itemToRemove;

      // print(" friend list before : ${_toUser.followersList}");

      for (var i in _toUser.followersList) {
        if (i['userName'] == _currUser.userName) {
          _itemToRemove = i;
          break;
        }
      }
      _itemToRemove != null
          ? _toUser.followersList.remove(_itemToRemove)
          : print('cannot find curr user in this user\'s profile');

      // print(" friend list after : ${_toUser.followersList}");

      await _fireStoreService.updateUserFriends(_toUser);

      //__________________________________________________________________________________________

      for (var i in _currUser.followingList) {
        if (i['userName'] == _toUser.userName) {
          _itemToRemove = i;
          break;
        }
      }
      _itemToRemove != null
          ? _currUser.followingList.remove(_itemToRemove)
          : print('cannot find to user in curr user\'s profile');

      await _fireStoreService.updateUserFriends(_currUser);

      // print(
      //     " index : ${_allUsers.indexOf(user)}    --  ${_allUsersToDisplay.indexOf(user)}  ");

      _allUsers[_allUsers.indexOf(user)] = _toUser;
      _allUsersToDisplay[_allUsersToDisplay.indexOf(user)] = _toUser;
      _usersFriendStatus[_allUsers.indexOf(user)] = FriendStatus.available;
      _usersFriendStatusToDisplay[_allUsersToDisplay.indexOf(user)] =
          FriendStatus.available;

      // print(" after \n");
      // print("all users : $_allUsers");
      // print("all users to disp: $_allUsersToDisplay");
      // print("all friends: $_usersFriendStatus");
      // print("friend disp: $_usersFriendStatusToDisplay");
      // print("**** \n");

      setState();
      return true;
    }
  }
}
