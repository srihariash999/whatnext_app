import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/models/message.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
// import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/providers/base_provider.dart';

class ChatProvider extends BaseProvider {
  // Firestore instance.
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  // Firestore service for accessing db methods.
  final FirestoreService _firestoreService = locator<FirestoreService>();

  // Reference to auth service.
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  // final NavigationService _navigationService = locator<NavigationService>();

  // Text Editing Controller that controls the message sending.
  TextEditingController _messageController = TextEditingController();
  // Getter to get the private message text controller.
  TextEditingController get messageController => _messageController;

  // Scroll controller used in chat screen.
  ScrollController _scrollController = ScrollController();
  // Getter to get the private scroll controller.
  ScrollController get scrollController => _scrollController;

  // Username of the person other than the current user.
  String _toUserName = "";
  // Getter to get the private toUserName;
  String get toUserName => _toUserName;

  // Name of the chat room. (combination of the user names of both participants)
  String _roomName = "";
  // Getter to get the private roomname variable.
  String get roomName => _roomName;

  // Variable to keep track of last seen time.
  String _lastSeen = "  ";
  // Getter to get the private last seen.
  String get lastSeen => _lastSeen;

  // Boolean to indicate loading state while message is being sent.
  bool _isMessageSending = false;
  // Getter to get the private loader variable
  bool get isMessageSending => _isMessageSending;

  // List of messages.
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  // Initialising function.
  Future<void> init(String toUserName) async {
    // indicate busy.
    setBusy(true);
    // set the other person's username.
    _toUserName = toUserName;
    // Get the chat room's name.
    await getChatRoomName(toUserName);
    // Load all the messages.
    await getMessages();
    // Get the last seen time and laod it to variable.
    await getLastSeen(toUserName);

    // indicate not busy.
    setBusy(false);

    // Scroll to the last of the chat list.
    // WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLast());

    // Listen to the chatRoom updates. (new message arrival)
    _instance.collection('chatRooms').doc(roomName).snapshots().listen((event) {
      // print('event p : ${event.get('messages')} ');
      String _s = event.get('lastSeen$_toUserName');
      if (_s != 'never' && _s != null) {
        _lastSeen = DateFormat('MMMd').format(DateTime.parse(_s)) +
            ', ' +
            DateFormat('Hm').format(DateTime.parse(_s));
      } else {
        _lastSeen = 'Never';
      }
      _messages = [];
      for (var i in event.get('messages')) {
        _messages.insert(0, Message.fromJson(i));
      }
      setState();
      // WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLast());
    });
  }

  // Method used to get the curren chat room's name.
  getChatRoomName(String toUserName) async {
    var s = await _firestoreService.checkIfRoomExists(
        toUserName: toUserName,
        fromUserName: _authenticationService.currentUser.userName);
    if (s['roomExists'] == true) {
      _roomName = s['roomName'];
      setState();
    }
  }

  // Method to get list of all messages for current chat room.
  getMessages() async {
    _messages = await _firestoreService.getMessages(roomName: _roomName);
    _messages = _messages.reversed.toList();
    // print(_messages);

    //updating current user's last seen, as the messages are seen.
    await _firestoreService.updateLastSeen(
        roomName: _roomName,
        userName: _authenticationService.currentUser.userName);
    setState();
  }

  // Method to get the last seen time of the other person.
  getLastSeen(String toUserName) async {
    String _s = await _firestoreService.getLastSeen(
        roomName: _roomName, userName: toUserName);
    try {
      if (_s != 'never' && _s != null) {
        _lastSeen = DateFormat('MMMd').format(DateTime.parse(_s)) +
            ', ' +
            DateFormat('Hm').format(DateTime.parse(_s));
      } else {
        _lastSeen = 'Never';
      }
    } catch (e) {
      print(" err: $e");
    }
  }

  // Utility function used to scroll to the end of the messages list on screen.
  // scrollToLast() async {
  //   try {
  //     // print(" this called");
  //     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //         duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  //   } catch (e) {
  //     // print(" cannot scroll");
  //   }
  // }

  // Message to actually send a message.
  sendMessage() async {
    // check ig the message is not empty.
    if (!isMessageSending && _messageController.text.trim().length > 1) {
      // set the loader to true.
      _isMessageSending = true;
      setState();
      // send the message.
      await _firestoreService.sendMessage(
        fromuser: _authenticationService.currentUser.userName,
        toUser: _toUserName,
        roomName: roomName,
        message: _messageController.text.trim(),
      );
      // _messages.add(Message(
      //   from: _authenticationService.currentUser.userName,
      //   to: _toUserName,
      //   addedOn: "${DateTime.now()}",
      //   message: _messageController.text,
      // ));
      // set the loader to false.
      _isMessageSending = false;

      // store the message text in a variable.
      String msg = _messageController.text.trim();

      // clear the chat editing box.
      _messageController.clear();

      setState();
      // print("this completed");

      //get to user token

      // get the token of the to user.

      // Send a notification to the other person in chat.
      var res = await _firestoreService.getuserToken(_toUserName);
      if (res['tokenAvailable']) {
        // token is there, send notif.
        await _firestoreService.sendNotification(
            token: res['token'],
            body: "${_authenticationService.currentUser.userName} : $msg");
      }
    } else {
      // print(" message ignored: ${_messageController.text}");
      _messageController.clear();

      setState();
    }
  }
}
