import 'package:flutter/cupertino.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/message.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
// import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class ChatViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  // final NavigationService _navigationService = locator<NavigationService>();

  TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;

  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  String _toUserName = "";
  String get toUserName => _toUserName;
  String _roomName = "";
  String get roomName => _roomName;

  bool _isMessageSending = false;
  bool get isMessageSending => _isMessageSending;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Future<void> init(String toUserName) async {
    setBusy(true);
    _toUserName = toUserName;
    await getChatRoomName(toUserName);
    await getMessages();

    setBusy(false);

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLast());
  }

  getChatRoomName(String toUserName) async {
    var s = await _firestoreService.checkIfRoomExists(
        toUserName: toUserName,
        fromUserName: _authenticationService.currentUser.userName);
    if (s['roomExists'] == true) {
      _roomName = s['roomName'];
      setState();
    }
  }

  getMessages() async {
    _messages = await _firestoreService.getMessages(roomName: _roomName);
    print(_messages);
    setState();
  }

  scrollToLast() async {
    print(" this called");
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  sendMessage() async {
    if (!isMessageSending && _messageController.text.length > 1) {
      _isMessageSending = true;
      setState();
      await _firestoreService.sendMessage(
        fromuser: _authenticationService.currentUser.userName,
        toUser: _toUserName,
        roomName: roomName,
        message: _messageController.text,
      );
      _messages.add(Message(
        from: _authenticationService.currentUser.userName,
        to: _toUserName,
        addedOn: "${DateTime.now()}",
        message: _messageController.text,
      ));
      _isMessageSending = false;
      _messageController.clear();

      setState();
      print("this completed");
    }
  }
}
