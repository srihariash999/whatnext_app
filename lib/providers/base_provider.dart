import 'package:flutter/widgets.dart';

/*

  Contains a few abstractions that are commonly used across all providers.

*/

class BaseProvider extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  void setState() {
    notifyListeners();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
