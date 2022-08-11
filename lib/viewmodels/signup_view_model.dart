import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _fireStoreService = locator<FirestoreService>();

  String _selectedRole = 'Select a User Role';
  String get selectedRole => _selectedRole;

  //This function manages the setting of the ui in the dropdown in singup page, selecting user role.
  void setSelectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  goBack() {
    _navigationService.pop();
  }

  Future signUp(
      {@required String email,
      @required String password,
      @required String fullName,
      @required String userName}) async {
    setBusy(true);

    bool _isUserNameTaken = await isUsernameOkay(userName);

    if (_isUserNameTaken) {
      Fluttertoast.showToast(
          msg: "Username is taken !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.70),
          textColor: Colors.white,
          fontSize: 16.0);
      setBusy(false);
    } else {
      var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        userName: userName,
        // role: _selectedRole,
      );

      setBusy(false);
      if (result is bool) {
        if (result) {
          // _authenticationService.isUserLoggedIn();
          Fluttertoast.showToast(
              msg: "Signup succesful!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.70),
              textColor: Colors.white,
              fontSize: 16.0);
          _navigationService.navigateReplacement(LoginViewRoute);
        } else {
          await _dialogService.showDialog(
            title: 'Sign Up Failure',
            description: 'General sign up failure. Please try again later',
          );
        }
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: result,
        );
      }
    }
  }

  Future<bool> isUsernameOkay(String userName) async {
    List<QueryDocumentSnapshot> snap = await _fireStoreService.getAllUsers();
    bool _isUserNameTaken = false;
    for (var i in snap) {
      // print(i.data());
      // Object data = i.data();
      print(" username is : ${i['userName']} ");
      if (i['userName'] == userName) {
        _isUserNameTaken = true;
        print(' username is taken');
        break;
      }
    }
    return _isUserNameTaken;
  }
}
