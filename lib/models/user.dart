import 'package:flutter/foundation.dart';

class UserModel {
  String id;
  String fullName;
  String userName;
  String email;
  // String userRole;
  String profilePicture;
  List<dynamic> followersList;
  List<dynamic> followingList;
  UserModel({
    @required this.id,
    @required this.fullName,
    @required this.email,
    // @required this.userRole,
    @required this.userName,
    @required this.followersList,
    @required this.followingList,
    @required this.profilePicture,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userName = data['userName'],
        fullName = data['fullName'],
        email = data['email'],
        // userRole = data['userRole'],
        profilePicture = data['profilePicture'],
        followersList = data['followersList'],
        followingList = data['followingList'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      // 'userRole': userRole,
      'profilePicture': profilePicture,
      'userName': userName,
      'followersList': followersList,
      'followingList': followingList
    };
  }
}
