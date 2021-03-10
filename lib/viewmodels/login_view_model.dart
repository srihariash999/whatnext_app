import 'package:flutter/foundation.dart';
import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/navigation_service.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({@required String email, @required String password}) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
        email: email, password: password);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateReplacement(StartupViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'Couldn\'t login at this moment. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  Future resetPassword({@required String email}) async {
    if (email.length < 1) {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Email should not be null',
      );
    } else {
      setBusy(true);
      await _authenticationService.resetPassword(email);
      setBusy(false);
      await _dialogService.showDialog(
        title: 'Reset password',
        description:
            'A link to reset your password has been sent successfully to your email',
      );
    }
  }

  navigateToSignUp() {
    try {
      _navigationService.navigateTo(SignUpViewRoute);
    } catch (e) {
      print(" cannot navigate to signup: $e");
    }
  }

  navigateToResetView() {
    try {
      _navigationService.navigateTo(ResetPasswordViewRoute);
    } catch (e) {
      print(" cannot navigate to reset view: $e");
    }
  }
}
