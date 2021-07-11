import 'package:flutter/material.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class MessagesViewModel extends BaseModel {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final NavigationService _navigationService = locator<NavigationService>();

  List<String> _canMessageUsers = [];

  List<String> get canMessageUsers => _canMessageUsers;

  List<String> _availableChatRooms = [];
  List<String> get availableChatRooms => _availableChatRooms;

  String _currentUser = '';
  String get currentUser => _currentUser;

  List<bool> _newMessages = [];
  List<bool> get newMessages => _newMessages;

  bool _isSheetOpen = false;

  Future<void> init() async {
    setBusy(true);
    _availableChatRooms = [];
    _canMessageUsers = [];
    getAvailableChatRooms();
    getFriendsWhoFollowBack();

    _currentUser = _authenticationService.currentUser.userName;
    setBusy(false);
  }

  _setSheetStatus() {
    _isSheetOpen = !_isSheetOpen;
    setState();
  }

  getProfilePic() async {}

  getFriendsWhoFollowBack() async {
    _canMessageUsers = await _firestoreService.getCommonFriends(
        user: _authenticationService.currentUser);

    print("common : $_canMessageUsers");
  }

  getAvailableChatRooms() async {
    _availableChatRooms = await _firestoreService.getChatRooms(
        userName: _authenticationService.currentUser.userName);
    print('rooms : $_availableChatRooms');

    setState();
  }

  Future<bool> getMessageStatusOfRoom(
      String roomName, String toUser, String fromUser) async {
    Map<String, String> _chatRoomProps =
        await _firestoreService.getChatRoomProps(
      roomName: roomName,
      fromUser: fromUser,
      toUser: toUser,
    );

    print('chat props: $_chatRoomProps');

    if (_chatRoomProps['fromLastSeen'] != null &&
        _chatRoomProps['fromLastSeen'] != 'never' &&
        _chatRoomProps['toLastMsg'] != null &&
        _chatRoomProps['toLastMsg'] != 'never') {
      print(
          " the diff ${DateTime.parse(_chatRoomProps['toLastMsg']).difference(DateTime.parse(_chatRoomProps['fromLastSeen'])).inSeconds}");
      return DateTime.parse(_chatRoomProps['toLastMsg'])
              .difference(DateTime.parse(_chatRoomProps['fromLastSeen']))
              .inSeconds >
          2;
    } else {
      return false;
    }
  }

  sendMessageClicked(String toUserName) async {
    setBusy(true);
    _navigationService.pop();
    Map _roomExists = await _firestoreService.checkIfRoomExists(
        fromUserName: _currentUser, toUserName: toUserName);
    print(_roomExists);
    if (_roomExists['roomExists']) {
      print(" room is there. ${_roomExists['roomName']}");
      navigateToChatScreen(toUserName);
    } else {
      print("Room not there, create it");
      await _firestoreService.createChatRoom(
          fromUserName: _currentUser,
          toUserName: toUserName,
          chatRooms: availableChatRooms);
      await init();
      navigateToChatScreen(toUserName);
    }

    setBusy(false);
  }

  newChatPressed() async {
    if (!_isSheetOpen) {
      _setSheetStatus();
      final _controller = _scaffoldKey.currentState.showBottomSheet(
        (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4.0,
                  width: 28.0,
                  color: Colors.black54,
                )
              ],
            ),
            verticalSpaceMedium,
            Container(
              height: 400.0,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: _canMessageUsers
                      .map(
                        (String user) => Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 22.0,
                              right: 36.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '$user',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline3
                                        .copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blue[300]),
                                  ),
                                  child: Text(
                                    "Send Message",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    sendMessageClicked('$user');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withOpacity(0.50),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
      );
      var s = await _controller.closed;
      _setSheetStatus();
      print(s);
    }
  }

  navigateToChatScreen(String toUserName) async {
    await _navigationService.navigateTo(ChatViewRoute, arguments: toUserName);
    init();
  }
}
