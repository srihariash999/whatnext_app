import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/models/user.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  List _currentUserWatchList = [];
  List get currentUserWatchList => _currentUserWatchList;

  final _firestoreService = locator<FirestoreService>();

  setCurrentUser(UserModel user) => _currentUser = user;

  _populateCurrentUser(User user) async {
    if (user != null) {
      // print(" ***** \n\n\n  jeee-boom-ba \n\n\n****");
      // print(" ${user.displayName}");
      var res = await _firestoreService.getUser(user.displayName);
      // print(" ***** \n\n\n  $res \n\n\n****");
      _currentUser = res;
    }
  }

  populateCurrentUserWatchList(String userName) async {
    if (userName != null) {
      var res = await _firestoreService.getUserWatchList(userName);
      // print(" ***** \n\n\n  $res \n\n\n****");
      _currentUserWatchList = res;
    }
  }

  //Service function to perform login action
  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print(" logged in user : ${authResult.user}");
      await _populateCurrentUser(
          authResult.user); // Populate the user information

      // await populateCurrentUserWatchList(
      //     authResult.user != null ? authResult.user.displayName : null);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  //Service function to perform signup action
  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String userName,
    @required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await authResult.user.updateProfile(displayName: userName);

      await _firestoreService.createUser(
        UserModel(
          id: authResult.user.uid,
          email: email,
          userName: userName,
          fullName: fullName,
          userRole: role,
          followingList: [],
          followersList: [],
        ),
      );
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  logout() async {
    await _firebaseAuth.signOut();
    // print(" current user : ${_firebaseAuth.currentUser}");
    return _firebaseAuth.currentUser == null;
  }

  // Function returns true if the user is logged in , else ofc returns false
  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    // print(" is this web : $kIsWeb");
    // var user = kIsWeb
    //     ? await _firebaseAuth.authStateChanges().last
    //     : _firebaseAuth.currentUser;
    print(" user in isUseroggedIn func : $user");

    await _populateCurrentUser(user);
    // Populate the user information

    await populateCurrentUserWatchList(user != null ? user.displayName : null);
    // populate the user's watchlist

    return user != null;
  }
}
