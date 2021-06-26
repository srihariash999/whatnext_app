import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class MessagesViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  List<String> _canMessageUsers = [];
  List<String> _canMessageUsersToDisplay = [];

  List<String> get canMessageUsers => _canMessageUsersToDisplay;

  init() async {
    getFriendsWhoFollowBack();
  }

  getFriendsWhoFollowBack() async {
    _canMessageUsers = await _firestoreService.getCommonFriends(
        user: _authenticationService.currentUser);

    print("common : $_canMessageUsers");
  }
}
