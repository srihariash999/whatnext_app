import 'package:whatnext/locator.dart';
import 'package:whatnext/models/about.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/viewmodels/base_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  AboutApp _aboutApp;
  AboutApp get aboutApp => _aboutApp;

  requestAboutApp() async {
    setBusy(true);
    _aboutApp = await _firestoreService.getAboutApp();
    setState();
    setBusy(false);
  }

  onTmdbtap() async {
    String _url = "https://www.themoviedb.org/";
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  onRatetap() async {
    String _url = _aboutApp.playStore;
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  onGithubTap(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  onTwitterTap(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
