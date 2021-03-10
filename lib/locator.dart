import 'package:get_it/get_it.dart';
import 'package:whatnext/services/authentication_service.dart';
import 'package:whatnext/services/dialog_service.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/services/navigation_service.dart';
import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/services/tmdb_service.dart';
// import 'package:whatnext/services/snackbar_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => TmdbService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
}
