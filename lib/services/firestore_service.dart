import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:whatnext/models/user.dart';

class FirestoreService {
  //firestore instance to user multiple times.
  FirebaseFirestore _instance = FirebaseFirestore.instance;

  // Method to create a user object in the firestore collection 'users' after successful signup (through firebase auth).
  Future createUser(UserModel user) async {
    try {
      await _instance.collection("users").doc(user.userName).set(user.toJson());
      await _instance
          .collection("watchLists")
          .doc(user.userName)
          .set({'watchList': []});
    } catch (e) {
      return e.message;
    }
  }

  // Method to get a user object from firestore collection 'users' using username.
  Future getUser(String userName) async {
    try {
      var userData = await _instance.collection("users").doc(userName).get();
      return UserModel.fromData(userData.data());
    } catch (e) {
      return e.message;
    }
  }

  //Method to get userWatchList item from firestore collection 'watchlists' using user's username.
  Future getUserWatchList(String userName) async {
    try {
      var userData =
          await _instance.collection("watchLists").doc(userName).get();

      return userData.data()['watchList'];
    } catch (e) {
      return e.message;
    }
  }

  // Method to add an item (movie/tv) to a user's watchlist in firestore collection.
  addToUserWatchList({
    @required String name,
    @required int id,
    @required String posterPath,
    @required String userName,
    @required String status,
    @required String type,
  }) async {
    try {
      var userWatchList =
          await _instance.collection("watchLists").doc(userName).get();

      List _toUpdate = userWatchList.data()['watchList'] ?? [];
      _toUpdate.add(
        {
          'id': id,
          'name': name,
          'poster': posterPath,
          "status": status,
          "type": type,
        },
      );

      await _instance
          .collection("watchLists")
          .doc(userName)
          .update({'watchList': _toUpdate});

      await _instance.collection("feed").add(
        {
          'userName': userName,
          'id': id,
          'name': name,
          'poster': posterPath,
          "status": status,
          "type": type,
          'addedOn': DateTime.now().toString(),
        },
      );

      return {'res': true, 'message': 'user watchlist updated'};
    } catch (e) {
      return {'res': false, 'message': e.message};
    }
  }

  // Method to remove an item (movie/tv) to a user's watchlist in firestore collection.
  removeFromUserWatchList(var item, String userName) async {
    try {
      var userWatchList =
          await _instance.collection("watchLists").doc(userName).get();

      List _toUpdate = userWatchList.data()['watchList'] ?? [];

      var bb;
      for (var i in _toUpdate) {
        if (i['id'] == item.id) {
          bb = i;
          break;
        }
      }
      var cc = _toUpdate.remove(bb);

      await _instance
          .collection("watchLists")
          .doc(userName)
          .update({'watchList': _toUpdate});

      return {'res': cc, 'message': 'user watchlist updated'};
    } catch (e) {
      return {'res': false, 'message': e.message};
    }
  }

  //  Method to update the whole user object. (name is slightly misleading, will refactor in future)
  updateUserFriends(UserModel user) async {
    try {
      await _instance
          .collection("users")
          .doc(user.userName)
          .update(user.toJson());

      return {'res': true, 'message': 'user data updated'};
    } catch (e) {
      return {'res': false, 'message': e.message};
    }
  }

  //Method to get a list of all users available.
  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    try {
      var usersList = await _instance.collection("users").get();

      return usersList.docs;
    } catch (e) {
      return e.message;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllFeed() async {
    try {
      var feedList = await _instance.collection("feed").get();
      return feedList.docs;
    } catch (e) {
      return e.message;
    }
  }
}
