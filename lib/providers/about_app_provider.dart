import 'package:whatnext/locator.dart';
import 'package:whatnext/models/about.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/providers/base_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/*

  This file contains control logic of 'About App' section's UI.

*/

/// Control logic for the about app section of the app.
class AboutAppProvider extends BaseProvider {
  // Reference to the firestore service provider.
  final FirestoreService _firestoreService = locator<FirestoreService>();

  // Actual information about the app is store in this private object.
  AboutApp _aboutApp;

  /// getter for private `_aboutApp` variable.
  AboutApp get aboutApp => _aboutApp;

  /// Method to be called from UI which will populate the `_aboutApp` variable.
  /// Data is fetched from firestore.
  requestAboutApp() async {
    // indicate the busy state of the app.
    setBusy(true);
    // Get the object from firestore DB.
    _aboutApp = await _firestoreService.getAboutApp();
    // set the state to not busy.
    setBusy(false);
  }

  /// Method to call from ui which contains handling of taps on TMDB logo in about app section.
  onTmdbtap() async {
    Uri _url = Uri.parse("https://www.themoviedb.org/");
    await canLaunchUrl(_url)
        ? await launchUrl(_url)
        : throw 'Could not launch $_url';
  }

  /// Method to call from ui which contains handling of taps on rating button in about app section.
  onRatetap() async {
    Uri _url = Uri.parse(_aboutApp.playStore);
    await canLaunchUrl(_url)
        ? await launchUrl(_url)
        : throw 'Could not launch $_url';
  }

  /// Method to call from ui which contains handling of taps on Github logo or Tmdb logo (urls) in about app section.
  onUrlTap(String url) async {
    Uri _url = Uri.parse(url);
    await canLaunchUrl(_url)
        ? await launchUrl(_url)
        : throw 'Could not launch $url';
  }
}
