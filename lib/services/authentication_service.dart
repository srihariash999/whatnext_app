import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/models/user.dart';

class AuthenticationService {
  //firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // This varible will hold the details of current user for use throughout the app
  UserModel _currentUser;

  // Getter for private variable _currentUser
  UserModel get currentUser => _currentUser;

  // This variable will hold the details of the watchlist for the current user for use theoughout the app
  List _currentUserWatchList = [];

  // Getter for the private field _currentUserWatchList
  List get currentUserWatchList => _currentUserWatchList;

  // Locating the firestore service to use it.
  final _firestoreService = locator<FirestoreService>();

  //Setter for the private variable _currentUser
  setCurrentUser(UserModel user) => _currentUser = user;

  // Private method to populate the variable _currentUser after getting it from firebase.
  _populateCurrentUser(User user) async {
    if (user != null) {
      var res = await _firestoreService.getUser(user.displayName);
      _currentUser = res;
    }
  }

  // Method to set the value of _currentUserWatchlist after getting it from firebase.
  populateCurrentUserWatchList(String userName) async {
    if (userName != null) {
      var res = await _firestoreService.getUserWatchList(userName);

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
    // @required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await authResult.user.updateDisplayName(userName);

      await _firestoreService.createUser(
        UserModel(
          id: authResult.user.uid,
          email: email,
          userName: userName,
          fullName: fullName,
          profilePicture: null,
          // userRole: role,
          followingList: [],
          followersList: [],
        ),
      );
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  // Service function to perform the logout action.
  logout() async {
    await _firebaseAuth.signOut();
    return _firebaseAuth.currentUser == null;
  }

  // Function returns true if the user is logged in , else ofc returns false
  Future<bool> isUserLoggedIn() async {
    try {
      var user = _firebaseAuth.currentUser;
      print(" current user: ${user.displayName}");
      await _populateCurrentUser(user);
      // populate the user's watchlist
      await populateCurrentUserWatchList(
          user != null ? user.displayName : null);

      return user != null;
    } catch (e) {
      // print("user : ${_firebaseAuth.currentUser} ");
      print(" error : $e   ");
      return false;
    }
  }

  //Service function to rest password uusing email
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
