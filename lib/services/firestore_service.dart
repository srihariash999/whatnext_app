import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:whatnext/models/movie_details.dart';
import 'package:whatnext/models/user.dart';

class FirestoreService {
  FirebaseFirestore _instance = FirebaseFirestore.instance;

  // final CollectionReference _usersCollectionReference =
  //     FirebaseFirestore.instance.collection("users");

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

  Future getUser(String userName) async {
    try {
      var userData = await _instance.collection("users").doc(userName).get();
      print(" user Dataa : ${userData.data()}");
      return UserModel.fromData(userData.data());
    } catch (e) {
      return e.message;
    }
  }

  Future getUserWatchList(String userName) async {
    try {
      var userData =
          await _instance.collection("watchLists").doc(userName).get();
      print(" user watch list : ****** : ${userData.data()}");
      return userData.data()['watchList'];
    } catch (e) {
      return e.message;
    }
  }

  addToUserWatchList(
      {@required MovieDetails movie,
      @required String userName,
      @required String status}) async {
    try {
      var userWatchList =
          await _instance.collection("watchLists").doc(userName).get();

      List _toUpdate = userWatchList.data()['watchList'] ?? [];
      _toUpdate.add(
        {
          'movieId': movie.id,
          'name': movie.title,
          'poster': movie.posterPath,
          "status": status
        },
      );

      print(" users watch list : $_toUpdate");
      await _instance
          .collection("watchLists")
          .doc(userName)
          .update({'watchList': _toUpdate});

      return {'res': true, 'message': 'user watchlist updated'};
    } catch (e) {
      return {'res': false, 'message': e.message};
    }
  }

  removeFromUserWatchList(MovieDetails movie, String userName) async {
    try {
      var userWatchList =
          await _instance.collection("watchLists").doc(userName).get();

      List _toUpdate = userWatchList.data()['watchList'] ?? [];

      var bb;
      for (var i in _toUpdate) {
        if (i['movieId'] == movie.id) {
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

  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    // await _instance.clearPersistence();
    try {
      // var usersList2 = await _instance.doc('users').get();
      // var x = usersList2.data().toString();
      // print(x);

      var usersList = await _instance.collection("users").get();

      return usersList.docs;
    } catch (e) {
      return e.message;
    }
  }
}
