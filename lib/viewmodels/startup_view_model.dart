import 'package:whatnext/constants/route_names.dart';
import 'package:whatnext/locator.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    print(" first thing yo");

    bool hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    print(
        " has user logged in : $hasLoggedInUser   and ${hasLoggedInUser.runtimeType} ");

    if (hasLoggedInUser == true) {
      await Future.delayed(Duration(seconds: 3));
      _navigationService.navigateReplacement(HomeViewRoute);
    } else {
      _navigationService.navigateReplacement(LoginViewRoute);
    }
  }
}
