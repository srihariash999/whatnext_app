import 'package:flutter/foundation.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

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

    var result = await _authenticationService.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
      role: _selectedRole,
    );

    setBusy(false);
    if (result is bool) {
      if (result) {
        // _authenticationService.isUserLoggedIn();
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
