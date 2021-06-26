import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:whatnext/constants/api_keys.dart';
import 'package:whatnext/models/about.dart';
import 'package:whatnext/models/feed.dart';
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

      // await _instance.collection("feed").add(
      //   {
      //     'userName': userName,
      //     'id': id,
      //     'name': name,
      //     'poster': posterPath,
      //     "status": status,
      //     "type": type,
      //     'addedOn': DateTime.now().toString(),
      //   },
      // );

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

  //method to get all the feed posts available.

  Future<List<QueryDocumentSnapshot>> getAllFeed() async {
    try {
      var feedList =
          await _instance.collection("feed").orderBy('addedOn').get();
      return feedList.docs;
    } catch (e) {
      return e.message;
    }
  }

  // this method will create a new feedpost in firestore db. Also adds the created doc id in user's profile.
  createNewPost(
      {@required String name,
      @required int id,
      @required String posterPath,
      @required String userName,
      @required String postBody,
      @required String type,
      @required UserModel user}) async {
    try {
      var res = await _instance.collection("feed").add(
        {
          'userName': userName,
          'id': id,
          'name': name,
          'poster': posterPath,
          'postBody': postBody,
          "type": type,
          'addedOn': DateTime.now().toString(),
        },
      );
      print(" firestore res: ${res.path}");
      var userData =
          await _instance.collection("users").doc(user.userName).get();
      List feedPosts = [];
      if (userData.data()['feedPosts'] != null) {
        feedPosts = userData.data()['feedPosts'];
      }
      print('5 : ${res.path.substring(5)}');
      print('6 : ${res.path.substring(6)}');
      feedPosts.add(res.path.substring(5));
      await _instance.collection("users").doc(user.userName).update(
        {"feedPosts": feedPosts},
      );

      return {'res': true, 'message': 'post added.'};
    } catch (e) {
      print(" error while adding post to feed: $e");
      return {'res': false, 'message': 'error while adding post !'};
    }
  }

  // this method will create a new object in notifications collection.
  createNewNotification({
    @required String userName,
    @required String title,
  }) async {
    try {
      var res = await _instance.collection("notifications").add(
        {
          'userName': userName,
          'title': title,
        },
      );
      print(" firestore res: ${res.path}");

      return {'res': true, 'message': 'notification added.'};
    } catch (e) {
      print(" error while adding post to feed: $e");
      return {'res': false, 'message': 'error while adding notification !'};
    }
  }

  Future<AboutApp> getAboutApp() async {
    try {
      var aboutAppDoc =
          await _instance.collection("aboutApp").doc('aboutApp').get();
      return AboutApp.fromJson(aboutAppDoc.data());
    } catch (e) {
      return e.message;
    }
  }

  getuserToken(String username) async {
    try {
      var doc = await _instance
          .collection("users")
          .doc(username)
          .collection('tokens')
          .get();
      for (var i in doc.docs) {
        print(' jee jee : ${i.data()}');
      }

      if (doc.docs.length > 0) {
        print("undi ro ${doc.docs.last}");
        return {
          'tokenAvailable': true,
          'token': doc.docs.last.data()['token'],
        };
      } else {
        return {
          'tokenAvailable': false,
          'token': "",
        };
      }
    } catch (e) {
      print("this is error : $e");
      return e.message;
    }
  }

  sendNotification({@required token, @required body}) async {
    Dio dio = Dio();

    dio.options.headers["Authorization"] = "key=$firebaseServerKey";

    Response resp =
        await dio.post('https://fcm.googleapis.com/fcm/send', data: {
      "to": "$token",
      "priority": "high",
      "notification": {"title": "", "body": "$body", "text": ""}
    });
    print(" notif resp : $resp");
  }

  Future<List> getUsersPosts({@required userName}) async {
    var doc = await _instance.collection("users").doc(userName).get();
    List s = doc.data()['feedPosts'];
    return s.reversed.toList();
  }

  Future<Feed> getFeedPostById({@required String id}) async {
    var _feedPost = await _instance.collection('feed').doc(id).get();
    print(' feedpost is :${_feedPost.data()}');

    if (_feedPost.data() != null) {
      return Feed.fromJson(_feedPost.data());
    } else {
      return null;
    }
  }

  deleteFeedPostById({@required String id, @required String userName}) async {
    print(" id to delete: $id");
    // delete the post from feeds;

    await _instance.collection('feed').doc(id).delete();

    print("post deleted from collection : 'feed'");
    // delete from user's profile;

    var doc = await _instance.collection("users").doc(userName).get();
    List s = doc.data()['feedPosts'];
    bool rem = s.remove(id);
    var newData = doc.data();
    newData['feedPosts'] = s;
    await _instance.collection("users").doc(userName).set(newData);
    print(" post deleted frm user profile ? : $rem");
  }

  Future<bool> updateDisplayName(
      {@required String userName, @required String newName}) async {
    try {
      await _instance
          .collection('users')
          .doc(userName)
          .update({'fullName': newName});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getCommonFriends({@required UserModel user}) async {
    List _f1 = user.followersList;
    List _f2 = user.followingList;

    List<String> _followersList = [];
    List<String> _followingList = [];

    for (var i in _f1) {
      _followersList.add(i['userName']);
    }

    for (var i in _f2) {
      _followingList.add(i['userName']);
    }

    List<String> _commonList = [];

    for (var i in _followersList) {
      if (_followingList.contains(i)) {
        _commonList.add(i);
      }
    }
    return _commonList;
  }
}
