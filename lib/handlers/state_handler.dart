import 'package:flutter/foundation.dart';

class StateHandler with ChangeNotifier {
  void onDropDownValueChanged() {
    notifyListeners();
  }
}
